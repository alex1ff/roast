"use strict";

const functions = require("firebase-functions/v1");
const {Storage} = require("@google-cloud/storage");

const DEFAULT_BUCKET = "roast-nutri-tracker-7c67ct.firebasestorage.app";
const DEFAULT_MAX_TEXT_CHARS = 4000;
const ELEVENLABS_SECRET = "ELEVENLABS_API_KEY";
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

async function synthesizeSpeech(data, options = {}) {
  const elevenLabsKey = options.elevenLabsKey ?? getElevenLabsKey();
  const bucketName = options.bucketName ?? getStorageBucket();
  const fetchImpl = options.fetchImpl || fetch;
  const storageClient = options.storageClient || storage;
  const now = options.now || Date.now;
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
  const voiceSettings = data?.voice_settings;

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
  const objectPath = `tts/${now()}-${uuidFactory()}.${extension}`;
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
  .https.onCall(async (data) => synthesizeSpeech(data));

module.exports = {
  textToSpeech,
  _test: {
    pickFileExt,
    maxTextChars,
    synthesizeSpeech,
    textValue,
  },
};
