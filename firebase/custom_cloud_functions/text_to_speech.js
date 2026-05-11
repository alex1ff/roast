"use strict";

const functions = require("firebase-functions/v1");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {Storage} = require("@google-cloud/storage");

const DEFAULT_BUCKET = "roast-nutri-tracker-7c67ct.firebasestorage.app";
const DEFAULT_MAX_TEXT_CHARS = 4000;
const DEFAULT_DAILY_CALL_LIMIT = 50;
const DEFAULT_DAILY_CHAR_LIMIT = 50000;
const ELEVENLABS_SECRET = "ELEVENLABS_API_KEY";
const ALLOWED_MODEL_IDS = new Set(["eleven_multilingual_v2"]);
const ALLOWED_OUTPUT_FORMATS = new Set(["mp3_44100_128"]);
const VOICE_ID_PATTERN = /^[A-Za-z0-9_-]{6,128}$/;
const storage = new Storage();

function firebaseRuntimeConfig() {
  try {
    return functions.config?.() || {};
  } catch (_) {
    return {};
  }
}

function getElevenLabsKey() {
  const runtimeConfig = firebaseRuntimeConfig();
  return process.env.ELEVENLABS_API_KEY ||
    process.env.ELEVEN_KEY ||
    runtimeConfig.elevenlabs?.api_key ||
    runtimeConfig.elevenlabs?.key ||
    "";
}

function getStorageBucket() {
  const runtimeConfig = firebaseRuntimeConfig();
  return process.env.TTS_BUCKET ||
    process.env.FIREBASE_STORAGE_BUCKET ||
    runtimeConfig.firebase?.storageBucket ||
    DEFAULT_BUCKET;
}

function uuid() {
  return globalThis.crypto?.randomUUID?.() ||
    Math.random().toString(36).slice(2) +
    Math.random().toString(36).slice(2);
}

function pickFileExt({contentType, outputFormat}) {
  if (contentType?.includes("mpeg") || /^mp3_/i.test(outputFormat || "")) {
    return "mp3";
  }
  if (contentType?.includes("wav") || /^wav/i.test(outputFormat || "")) {
    return "wav";
  }
  if (contentType?.includes("ogg")) {
    return "ogg";
  }
  if (contentType?.includes("aac")) {
    return "aac";
  }
  if (contentType?.includes("flac")) {
    return "flac";
  }
  return "bin";
}

function textValue(value) {
  return typeof value === "string" ? value.trim() : "";
}

function maxTextChars(options = {}) {
  const configured = Number(
    options.maxTextChars ?? process.env.TTS_MAX_TEXT_CHARS,
  );
  return Number.isInteger(configured) && configured > 0 ?
    configured :
    DEFAULT_MAX_TEXT_CHARS;
}

function positiveInt(value, fallback) {
  const parsed = Number(value);
  return Number.isInteger(parsed) && parsed > 0 ? parsed : fallback;
}

function dailyCallLimit(options = {}) {
  return positiveInt(
    options.dailyCallLimit ?? process.env.TTS_DAILY_CALL_LIMIT,
    DEFAULT_DAILY_CALL_LIMIT,
  );
}

function dailyCharLimit(options = {}) {
  return positiveInt(
    options.dailyCharLimit ?? process.env.TTS_DAILY_CHAR_LIMIT,
    DEFAULT_DAILY_CHAR_LIMIT,
  );
}

function requireAuth(context) {
  if (!context.auth?.uid) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Authentication is required.",
    );
  }
  return context.auth.uid;
}

function parseCsvSet(value) {
  if (value instanceof Set) {
    return value;
  }
  if (!value || typeof value !== "string") {
    return new Set();
  }
  return new Set(
    value.split(",")
      .map((item) => item.trim())
      .filter(Boolean),
  );
}

function ensureAllowedValue(value, allowedValues, fieldName) {
  if (!allowedValues.has(value)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      `Unsupported ${fieldName}.`,
    );
  }
}

function sanitizeVoiceSettings(value) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return undefined;
  }

  const sanitized = {};
  for (const field of ["stability", "similarity_boost", "style"]) {
    if (value[field] === undefined) {
      continue;
    }
    if (typeof value[field] !== "number" ||
        value[field] < 0 ||
        value[field] > 1) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        `Invalid voice_settings.${field}.`,
      );
    }
    sanitized[field] = value[field];
  }

  if (value.use_speaker_boost !== undefined) {
    if (typeof value.use_speaker_boost !== "boolean") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid voice_settings.use_speaker_boost.",
      );
    }
    sanitized.use_speaker_boost = value.use_speaker_boost;
  }

  return Object.keys(sanitized).length > 0 ? sanitized : undefined;
}

async function defaultVerifyVoiceId(voiceId) {
  const snapshot = await getFirestore()
    .collection("persons")
    .where("voice_id", "==", voiceId)
    .limit(1)
    .get();
  return !snapshot.empty;
}

async function verifyVoiceId(voiceId, options = {}) {
  if (!VOICE_ID_PATTERN.test(voiceId)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Unsupported voiceid.",
    );
  }

  const configuredAllowlist = parseCsvSet(
    options.allowedVoiceIds ?? process.env.TTS_ALLOWED_VOICE_IDS,
  );
  if (configuredAllowlist.size > 0) {
    if (!configuredAllowlist.has(voiceId)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Voice is not allowlisted.",
      );
    }
    return;
  }

  const verifier = options.verifyVoiceId || defaultVerifyVoiceId;
  if (!await verifier(voiceId)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Voice is not allowlisted.",
    );
  }
}

function ttsUsageDateKey(nowMs) {
  return new Date(nowMs).toISOString().slice(0, 10).replace(/-/g, "");
}

function normalizePositiveInt(value) {
  return Number.isInteger(value) && value > 0 ? value : 0;
}

function buildTtsQuotaUsage(currentUsage, textLength, limits) {
  const calls = normalizePositiveInt(currentUsage?.calls);
  const chars = normalizePositiveInt(currentUsage?.chars);

  if (calls >= limits.dailyCallLimit ||
      chars + textLength > limits.dailyCharLimit) {
    throw new functions.https.HttpsError(
      "resource-exhausted",
      "Text-to-speech daily limit exceeded.",
    );
  }

  return {
    calls: calls + 1,
    chars: chars + textLength,
  };
}

async function consumeTtsQuota(uid, textLength, options = {}) {
  const firestore = options.firestore || getFirestore();
  const nowMs = options.nowMs ?? Date.now();
  const dateKey = ttsUsageDateKey(nowMs);
  const usageRef = firestore.doc(`users/${uid}/private_usage/tts_${dateKey}`);
  const limits = {
    dailyCallLimit: dailyCallLimit(options),
    dailyCharLimit: dailyCharLimit(options),
  };

  return firestore.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(usageRef);
    const nextUsage = buildTtsQuotaUsage(
      snapshot.exists ? snapshot.data() : {},
      textLength,
      limits,
    );

    transaction.set(
      usageRef,
      {
        calls: FieldValue.increment(1),
        chars: FieldValue.increment(textLength),
        date_key: dateKey,
        updated_at: FieldValue.serverTimestamp(),
      },
      {merge: true},
    );

    return nextUsage;
  });
}

async function synthesizeSpeech(data, options = {}) {
  const elevenLabsKey = options.elevenLabsKey ?? getElevenLabsKey();
  const bucketName = options.bucketName ?? getStorageBucket();
  const fetchImpl = options.fetchImpl || fetch;
  const storageClient = options.storageClient || storage;
  const nowMs = options.now ? options.now() : Date.now();
  const uuidFactory = options.uuidFactory || uuid;

  if (!elevenLabsKey) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "ElevenLabs API key is not configured.",
    );
  }
  if (!bucketName) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Storage bucket is not configured.",
    );
  }

  const text = textValue(data?.text);
  const voiceId = textValue(data?.voiceid);
  const modelId = textValue(data?.modelid) || "eleven_multilingual_v2";
  const outputFormat = textValue(data?.outputformat) || "mp3_44100_128";
  const voiceSettings = sanitizeVoiceSettings(data?.voice_settings);

  if (!text || !voiceId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Pass text and voiceid.",
    );
  }
  if (text.length > maxTextChars(options)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Text is too long.",
    );
  }
  ensureAllowedValue(modelId, ALLOWED_MODEL_IDS, "modelid");
  ensureAllowedValue(outputFormat, ALLOWED_OUTPUT_FORMATS, "outputformat");
  await verifyVoiceId(voiceId, options);
  if (options.uid && !options.skipQuota) {
    await consumeTtsQuota(options.uid, text.length, {
      dailyCallLimit: options.dailyCallLimit,
      dailyCharLimit: options.dailyCharLimit,
      firestore: options.firestore,
      nowMs,
    });
  }

  const requestUrl =
    `https://api.elevenlabs.io/v1/text-to-speech/${encodeURIComponent(voiceId)}`;
  const body = {text, model_id: modelId, output_format: outputFormat};
  if (voiceSettings && typeof voiceSettings === "object") {
    body.voice_settings = voiceSettings;
  }

  const response = await fetchImpl(requestUrl, {
    method: "POST",
    headers: {
      "xi-api-key": elevenLabsKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    console.error("[textToSpeech] ElevenLabs request failed", {
      status: response.status,
    });
    throw new functions.https.HttpsError(
      "internal",
      `ElevenLabs request failed: ${response.status}`,
    );
  }

  const contentType =
    response.headers.get("content-type") || "application/octet-stream";
  const buffer = Buffer.from(await response.arrayBuffer());
  const extension = pickFileExt({contentType, outputFormat});
  const objectPath = `tts/${nowMs}-${uuidFactory()}.${extension}`;
  const downloadToken = uuidFactory();
  const file = storageClient.bucket(bucketName).file(objectPath);

  await file.save(buffer, {
    contentType,
    metadata: {
      contentType,
      metadata: {
        firebaseStorageDownloadTokens: downloadToken,
        model_id: modelId,
        output_format: outputFormat,
        voice_id: voiceId,
      },
    },
    resumable: false,
    validation: false,
  });

  const encodedPath = encodeURIComponent(objectPath);
  return {
    audiopath:
      `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encodedPath}?alt=media&token=${downloadToken}`,
  };
}

const textToSpeech = functions
  .region("us-central1")
  .runWith({
    minInstances: 0,
    timeoutSeconds: 60,
    memory: "256MB",
    secrets: [ELEVENLABS_SECRET],
  })
  .https.onCall(async (data, context) => {
    const uid = requireAuth(context);
    return synthesizeSpeech(data, {uid});
  });

module.exports = {
  textToSpeech,
  _test: {
    buildTtsQuotaUsage,
    consumeTtsQuota,
    pickFileExt,
    maxTextChars,
    requireAuth,
    sanitizeVoiceSettings,
    synthesizeSpeech,
    textValue,
    verifyVoiceId,
  },
};
