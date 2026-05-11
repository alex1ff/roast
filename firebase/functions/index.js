const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const axios = require("axios");
const {OpenAI} = require("openai");
const {AGENT_CONFIGS} = require("./agent_configs");
const {
  createRoastShare,
  renderRoastShare,
} = require("./share_roast");

admin.initializeApp();

const REGION = "us-central1";
const OPENAI_SECRET = "OPENAI_API_KEY";
const PREMIUM_ENTITLEMENT = "Premium";
const RELOAD_PACK_PRODUCT_ID = "Roast_Reload_Pack";
const RELOAD_PACK_CREDITS = {
  extra_chat: 25,
  extra_photo: 21,
  extra_nophoto: 7,
};
const AI_DAILY_CALL_LIMITS = {
  roast: 80,
  aIAssistent: 200,
};
const USAGE_FEATURES = {
  roast: {
    countField: "count_limited",
    extraField: "extra_photo",
    monthlyLimit: 280,
    yearlyLimit: 3360,
    freeLimit: 18,
  },
  chat: {
    countField: "count_limited_chat",
    extraField: "extra_chat",
    monthlyLimit: 300,
    yearlyLimit: 3600,
    freeLimit: 18,
  },
};

class CallableError extends Error {
  constructor(code, message) {
    super(message);
    this.code = code;
  }
}

function firebaseRuntimeConfig() {
  try {
    return functions.config?.() || {};
  } catch (_) {
    return {};
  }
}

function getRevenueCatSecret() {
  const runtimeConfig = firebaseRuntimeConfig();
  return process.env.REVENUECAT_SECRET_KEY ||
    runtimeConfig.revenuecat?.secret_key ||
    runtimeConfig.revenuecat?.api_key ||
    "";
}

function getOpenAiApiKey() {
  const runtimeConfig = firebaseRuntimeConfig();
  return process.env.OPENAI_API_KEY ||
    runtimeConfig.openai?.api_key ||
    runtimeConfig.openai?.key ||
    "";
}

function toDate(value) {
  if (!value) {
    return null;
  }
  if (value instanceof Date) {
    return Number.isNaN(value.getTime()) ? null : value;
  }
  if (typeof value.toDate === "function") {
    return value.toDate();
  }
  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime()) ? null : parsed;
}

function normalizeCount(value) {
  return Number.isInteger(value) && value > 0 ? value : 0;
}

function positiveInt(value, fallback) {
  const parsed = Number(value);
  return Number.isInteger(parsed) && parsed > 0 ? parsed : fallback;
}

function aiDailyLimit(agentName, options = {}) {
  const envName = agentName === "roast" ?
    "AI_DAILY_ROAST_CALL_LIMIT" :
    "AI_DAILY_CHAT_CALL_LIMIT";
  return positiveInt(
    options.dailyLimit ?? process.env[envName],
    AI_DAILY_CALL_LIMITS[agentName] || 100,
  );
}

function usageDateKey(nowMs) {
  return new Date(nowMs).toISOString().slice(0, 10).replace(/-/g, "");
}

function buildDailyRateLimitUsage(currentUsage, limit) {
  const calls = normalizeCount(currentUsage?.calls);
  if (calls >= limit) {
    throw new CallableError(
      "resource-exhausted",
      "Daily AI request limit exceeded.",
    );
  }
  return {calls: calls + 1};
}

async function consumeAiRateLimit(uid, agentName, options = {}) {
  const firestore = options.firestore || admin.firestore();
  const nowMs = options.nowMs ?? Date.now();
  const dateKey = usageDateKey(nowMs);
  const safeAgentName = agentName.replace(/[^A-Za-z0-9_-]/g, "_");
  const usageRef = firestore.doc(
    `users/${uid}/private_usage/ai_${safeAgentName}_${dateKey}`,
  );
  const limit = aiDailyLimit(agentName, options);

  return firestore.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(usageRef);
    const nextUsage = buildDailyRateLimitUsage(
      snapshot.exists ? snapshot.data() : {},
      limit,
    );

    transaction.set(
      usageRef,
      {
        calls: admin.firestore.FieldValue.increment(1),
        date_key: dateKey,
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );

    return nextUsage;
  });
}

function planForProductIdentifier(productIdentifier) {
  if (productIdentifier === "roast_99_1year") {
    return "yearly";
  }
  if (productIdentifier === "roast_9_1Month") {
    return "monthly";
  }

  const normalized = String(productIdentifier || "").toLowerCase();
  if (normalized.includes("year")) {
    return "yearly";
  }
  if (normalized.includes("month")) {
    return "monthly";
  }

  throw new CallableError(
    "failed-precondition",
    `Unsupported RevenueCat product: ${productIdentifier || "unknown"}`,
  );
}

function fallbackSubscriptionEnd(plan, now) {
  const date = new Date(now.getTime());
  if (plan === "yearly") {
    date.setFullYear(date.getFullYear() + 1);
  } else {
    date.setMonth(date.getMonth() + 1);
  }
  return date;
}

function resolveActiveEntitlement(subscriber, entitlementId, now = new Date()) {
  const entitlement = subscriber?.entitlements?.[entitlementId];
  if (!entitlement) {
    return null;
  }

  const expiresAt = toDate(entitlement.expires_date);
  if (expiresAt && expiresAt.getTime() <= now.getTime()) {
    return null;
  }

  const plan = planForProductIdentifier(entitlement.product_identifier);
  return {
    plan,
    productIdentifier: entitlement.product_identifier,
    purchaseDate: toDate(entitlement.purchase_date) || now,
    expiresAt: expiresAt || fallbackSubscriptionEnd(plan, now),
  };
}

function subscriptionUpdateForEntitlement(entitlement, fieldValue) {
  return {
    dateSubStart: entitlement.purchaseDate,
    dateSubEnd: entitlement.expiresAt,
    SubPlan: entitlement.plan,
    count_limited: fieldValue.delete(),
    count_limited_chat: fieldValue.delete(),
  };
}

function hasActivePremium(userData, now = new Date()) {
  const plan = userData?.SubPlan;
  if (plan !== "monthly" && plan !== "yearly") {
    return false;
  }

  const dateSubEnd = toDate(userData?.dateSubEnd);
  return Boolean(dateSubEnd && dateSubEnd.getTime() > now.getTime());
}

function buildUsageUpdate(userData, feature, fieldValue, now = new Date()) {
  const config = USAGE_FEATURES[feature];
  if (!config) {
    throw new CallableError("invalid-argument", "Unsupported usage feature.");
  }

  const usedCount = normalizeCount(userData?.[config.countField]);
  const extraCredits = normalizeCount(userData?.[config.extraField]);
  const premiumActive = hasActivePremium(userData, now);
  const plan = userData?.SubPlan === "monthly" ? "monthly" : "yearly";
  const includedLimit = premiumActive
    ? (plan === "monthly" ? config.monthlyLimit : config.yearlyLimit)
    : config.freeLimit;

  if (usedCount < includedLimit) {
    return {
      update: {
        [config.countField]: fieldValue.increment(1),
      },
      result: {
        feature,
        mode: "included",
        usedCount: usedCount + 1,
        includedLimit,
        extraCredits,
      },
    };
  }

  if (extraCredits > 0) {
    return {
      update: {
        [config.extraField]: fieldValue.increment(-1),
      },
      result: {
        feature,
        mode: "extra_credit",
        usedCount,
        includedLimit,
        extraCredits: extraCredits - 1,
      },
    };
  }

  throw new CallableError("resource-exhausted", "Usage limit exceeded.");
}

function reloadPurchasesAfter(subscriber, productId, lastSyncedAt) {
  const lastSyncedTime = toDate(lastSyncedAt)?.getTime() || 0;
  const purchases = subscriber?.non_subscriptions?.[productId] || [];

  return purchases
    .map((purchase) => ({
      id: purchase.id ||
        purchase.store_transaction_id ||
        purchase.transaction_id ||
        `${productId}:${purchase.purchase_date || ""}`,
      purchaseDate: toDate(purchase.purchase_date),
    }))
    .filter((purchase) =>
      purchase.purchaseDate &&
      purchase.purchaseDate.getTime() > lastSyncedTime)
    .sort((left, right) =>
      left.purchaseDate.getTime() - right.purchaseDate.getTime());
}

async function fetchRevenueCatSubscriber(appUserId, secretKey) {
  const response = await axios.get(
    `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(appUserId)}`,
    {
      headers: {
        Authorization: `Bearer ${secretKey}`,
      },
      timeout: 10000,
    },
  );

  return response.data?.subscriber || {};
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

function clientRequestId(data) {
  const value = data?._clientRequestId;
  if (typeof value !== "string" || value.length === 0) {
    return "missing";
  }

  const sanitized = value.replace(/[^A-Za-z0-9_-]/g, "_").slice(0, 100);
  return sanitized || "missing";
}

function safeErrorLogMetadata(functionName, requestId, error) {
  const code = error instanceof functions.https.HttpsError ||
      error instanceof CallableError ?
    error.code :
    "internal";
  return {
    functionName,
    requestId,
    code,
    message: error?.message || "Backend request failed.",
  };
}

function toHttpsError(error, functionName, requestId) {
  console.error(
    "Callable failed",
    safeErrorLogMetadata(functionName, requestId, error),
  );

  if (error instanceof functions.https.HttpsError) {
    return error;
  }
  if (error instanceof CallableError) {
    return new functions.https.HttpsError(
      error.code,
      error.message,
      {requestId},
    );
  }

  return new functions.https.HttpsError(
    "internal",
    "Backend request failed.",
    {requestId},
  );
}

function getSystemMessage(messages, responseType) {
  if (!Array.isArray(messages) || messages.length === 0) {
    return "";
  }

  const systemMessage = messages.find((message) =>
    message.role === "SYSTEM" || message.role === "system");
  let finalMessage = systemMessage ? systemMessage.text || "" : "";

  switch (responseType) {
    case "PLAINTEXT":
      finalMessage += "\n Please provide your responses in plain text format only, without any special formatting or markdown.";
      break;
    case "MARKDOWN":
      finalMessage += "\n Please format your responses using markdown syntax for better readability.";
      break;
    case "JSON":
      finalMessage += "\nPlease provide your responses in valid JSON format.";
      break;
    default:
      break;
  }

  return finalMessage;
}

function openAiInputContent(data) {
  const inputContent = [];
  const message = typeof data?.message === "string" ? data.message.trim() : "";
  const imageUrl = typeof data?.imageUrl === "string" ? data.imageUrl.trim() : "";

  if (message) {
    inputContent.push({type: "input_text", text: message});
  }

  if (imageUrl) {
    inputContent.push({type: "input_image", image_url: imageUrl});
  }

  if (inputContent.length === 0) {
    throw new CallableError("invalid-argument", "Message or imageUrl is required.");
  }

  return inputContent;
}

function extractOpenAiOutputText(response) {
  if (typeof response?.output_text === "string") {
    return response.output_text;
  }

  const output = Array.isArray(response?.output) ? response.output : [];
  return output
    .flatMap((item) => Array.isArray(item.content) ? item.content : [])
    .map((content) => content.text || "")
    .filter(Boolean)
    .join("\n")
    .trim();
}

async function runOpenAiAgent(agentName, data, options = {}) {
  const agent = AGENT_CONFIGS[agentName];
  if (!agent) {
    throw new CallableError("failed-precondition", "AI agent is not configured.");
  }

  const apiKey = options.apiKey ?? (options.openaiClient ? "" : getOpenAiApiKey());
  if (!apiKey && !options.openaiClient) {
    throw new CallableError("failed-precondition", "OpenAI API key is not configured.");
  }

  const openai = options.openaiClient || new OpenAI({
    apiKey,
    maxRetries: 3,
    timeout: 30000,
  });
  const responseType = agent.responseOptions?.responseType || "PLAINTEXT";
  const systemMessage = getSystemMessage(agent.aiModel?.messages, responseType);
  const input = [];

  if (responseType === "JSON" && systemMessage) {
    input.push({
      role: "system",
      content: systemMessage,
    });
  }

  input.push({
    role: "user",
    content: openAiInputContent(data),
  });

  const requestParams = {
    model: agent.aiModel?.model || "gpt-4o",
    input,
    instructions: systemMessage,
    max_output_tokens: agent.aiModel?.parameters?.maxTokens?.inputValue || 800,
  };

  if (responseType === "JSON") {
    requestParams.text = {format: {type: "json_object"}};
  }

  const previousResponseId = typeof data?.previousResponseId === "string" ?
    data.previousResponseId.trim() :
    "";
  if (previousResponseId) {
    requestParams.previous_response_id = previousResponseId;
  }

  if (!requestParams.model.includes("gpt-5")) {
    requestParams.temperature =
      agent.aiModel?.parameters?.temperature?.inputValue ?? 0.5;
    requestParams.top_p = agent.aiModel?.parameters?.topP?.inputValue ?? 1;
  }

  const response = await openai.responses.create(requestParams);
  return {
    response: extractOpenAiOutputText(response),
    responseId: response.id,
  };
}

function aiCallable(agentName) {
  return functions
    .region(REGION)
    .runWith({
      minInstances: 0,
      timeoutSeconds: 60,
      memory: "256MB",
      secrets: [OPENAI_SECRET],
    })
    .https.onCall(async (data, context) => {
      const requestId = clientRequestId(data);
      try {
        const uid = requireAuth(context);
        await consumeAiRateLimit(uid, agentName);
        return await runOpenAiAgent(agentName, data);
      } catch (error) {
        throw toHttpsError(error, agentName, requestId);
      }
    });
}

exports.aIAssistent = aiCallable("aIAssistent");
exports.roast = aiCallable("roast");
exports.createRoastShare = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    const requestId = clientRequestId(data);
    try {
      return await createRoastShare(data, context);
    } catch (error) {
      throw toHttpsError(error, "createRoastShare", requestId);
    }
  });
exports.renderRoastShare = functions
  .region(REGION)
  .https.onRequest(renderRoastShare);

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const firestore = admin.firestore();
  const userRef = firestore.doc(`users/${user.uid}`);
  await userRef.delete();
});

exports.syncRevenueCatSubscription = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    const requestId = clientRequestId(data);
    try {
      const uid = requireAuth(context);
      const secretKey = getRevenueCatSecret();
      if (!secretKey) {
        throw new CallableError(
          "failed-precondition",
          "RevenueCat secret is not configured.",
        );
      }

      const entitlementId = data?.entitlementId || PREMIUM_ENTITLEMENT;
      const subscriber = await fetchRevenueCatSubscriber(uid, secretKey);
      const entitlement = resolveActiveEntitlement(subscriber, entitlementId);
      if (!entitlement) {
        throw new CallableError(
          "permission-denied",
          "Active subscription entitlement was not found.",
        );
      }

      await admin.firestore()
        .doc(`users/${uid}`)
        .set(
          subscriptionUpdateForEntitlement(
            entitlement,
            admin.firestore.FieldValue,
          ),
          {merge: true},
        );

      return {
        status: "synced",
        plan: entitlement.plan,
        productIdentifier: entitlement.productIdentifier,
        expiresAt: entitlement.expiresAt.toISOString(),
      };
    } catch (error) {
      throw toHttpsError(error, "syncRevenueCatSubscription", requestId);
    }
  });

exports.recordUsage = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    const requestId = clientRequestId(data);
    try {
      const uid = requireAuth(context);
      const feature = data?.feature;
      const userRef = admin.firestore().doc(`users/${uid}`);

      return await admin.firestore().runTransaction(async (transaction) => {
        const userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) {
          throw new CallableError("not-found", "User document not found.");
        }

        const mutation = buildUsageUpdate(
          userSnapshot.data(),
          feature,
          admin.firestore.FieldValue,
        );
        transaction.update(userRef, mutation.update);
        return mutation.result;
      });
    } catch (error) {
      throw toHttpsError(error, "recordUsage", requestId);
    }
  });

exports.syncReloadPackPurchase = functions
  .region(REGION)
  .https.onCall(async (data, context) => {
    const requestId = clientRequestId(data);
    try {
      const uid = requireAuth(context);
      const secretKey = getRevenueCatSecret();
      if (!secretKey) {
        throw new CallableError(
          "failed-precondition",
          "RevenueCat secret is not configured.",
        );
      }

      const productId = data?.productId || RELOAD_PACK_PRODUCT_ID;
      const subscriber = await fetchRevenueCatSubscriber(uid, secretKey);
      const userRef = admin.firestore().doc(`users/${uid}`);

      return await admin.firestore().runTransaction(async (transaction) => {
        const userSnapshot = await transaction.get(userRef);
        const userData = userSnapshot.data() || {};
        const purchases = reloadPurchasesAfter(
          subscriber,
          productId,
          userData.reload_pack_last_synced_at,
        );

        if (purchases.length === 0) {
          return {
            status: "already_synced",
            creditedPurchases: 0,
          };
        }

        const latestPurchase = purchases[purchases.length - 1];
        transaction.set(
          userRef,
          {
            extra_chat: admin.firestore.FieldValue.increment(
              RELOAD_PACK_CREDITS.extra_chat * purchases.length,
            ),
            extra_photo: admin.firestore.FieldValue.increment(
              RELOAD_PACK_CREDITS.extra_photo * purchases.length,
            ),
            extra_nophoto: admin.firestore.FieldValue.increment(
              RELOAD_PACK_CREDITS.extra_nophoto * purchases.length,
            ),
            reload_pack_last_synced_at: latestPurchase.purchaseDate,
          },
          {merge: true},
        );

        return {
          status: "synced",
          creditedPurchases: purchases.length,
        };
      });
    } catch (error) {
      throw toHttpsError(error, "syncReloadPackPurchase", requestId);
    }
  });

exports._test = {
  buildDailyRateLimitUsage,
  buildUsageUpdate,
  clientRequestId,
  consumeAiRateLimit,
  extractOpenAiOutputText,
  fallbackSubscriptionEnd,
  getSystemMessage,
  hasActivePremium,
  openAiInputContent,
  planForProductIdentifier,
  reloadPurchasesAfter,
  resolveActiveEntitlement,
  runOpenAiAgent,
  safeErrorLogMetadata,
  subscriptionUpdateForEntitlement,
  toDate,
};
