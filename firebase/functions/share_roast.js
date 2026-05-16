"use strict";

const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const crypto = require("crypto");

const PROJECT_ID = "roast-nutri-tracker-7c67ct";
const SHARE_BASE_URL =
  process.env.SHARE_BASE_URL || `https://${PROJECT_ID}.web.app`;
const APP_STORE_URL =
  process.env.APP_STORE_URL ||
  "https://apps.apple.com/ru/app/roast-them-all/id6754046515";
const DEFAULT_OG_IMAGE =
  process.env.DEFAULT_OG_IMAGE ||
  `${SHARE_BASE_URL}/icons/Icon-512.png`;

function firestore() {
  return admin.firestore();
}

function resolveDishRef(data) {
  const dishPath = asText(data?.dishPath);
  const dishId = asText(data?.dishId);

  if (dishPath) {
    if (!/^AddedDishHistory\/[^/]+$/.test(dishPath)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "dishPath must point to AddedDishHistory/{id}.",
      );
    }
    return firestore().doc(dishPath);
  }

  if (dishId) {
    return firestore().collection("AddedDishHistory").doc(dishId);
  }

  throw new functions.https.HttpsError(
    "invalid-argument",
    "Pass dishPath or dishId.",
  );
}

function assertDishOwner(dish, uid) {
  const userPath = dish?.user?.path;
  if (userPath !== `users/${uid}`) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You can only share your own roasts.",
    );
  }
}

async function createRoastShare(data, context) {
  if (!context.auth?.uid) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Sign in is required to share a roast.",
    );
  }

  const dishRef = resolveDishRef(data);
  const dishSnap = await dishRef.get();

  if (!dishSnap.exists) {
    throw new functions.https.HttpsError("not-found", "Roast was not found.");
  }

  const dish = dishSnap.data() || {};
  assertDishOwner(dish, context.auth.uid);

  if (!asText(dish.roast_text)) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "This dish does not have roast text yet.",
    );
  }

  const shareId = buildStableShareId(context.auth.uid, dishRef.path);
  const shareRef = firestore().collection("shared_roasts").doc(shareId);
  const existingShareSnap = await shareRef.get();
  const now = admin.firestore.FieldValue.serverTimestamp();
  const itemImageUrl = asUrl(dish.image);
  const roastImageUrl = asUrl(dish.roast_image);
  const imageUrl = itemImageUrl || roastImageUrl;
  const audioUrl = asUrl(dish.roast_audio);
  const title = buildShareTitle(dish);
  const excerpt = summarize(dish.roast_text, 180);

  await shareRef.set(
    {
      active: true,
      sourcePath: dishRef.path,
      sourceRoastId: dishRef.id,
      ownerUid: context.auth.uid,
      title,
      excerpt,
      content: asText(dish.roast_text),
      dishName: asText(dish.dishName),
      dishWeight: asDisplay(dish.dishWeight),
      restaurant: asText(dish.restaurant),
      imageUrl: imageUrl || "",
      itemImageUrl: itemImageUrl || imageUrl || "",
      roastImageUrl: roastImageUrl || imageUrl || "",
      audioUrl: audioUrl || "",
      ogImageUrl: roastImageUrl || itemImageUrl || DEFAULT_OG_IMAGE,
      kcal: asNumber(dish.kcal),
      proteins: asNumber(dish.proteins),
      fats: asNumber(dish.fats),
      carbs: asNumber(dish.carbs),
      badge: asText(dish.badge),
      impact: asText(dish.impact),
      calorieShare: asText(dish.calorieshare || dish.calorieShare),
      roastPerson: asText(dish.roast_person),
      roastLevel: asText(dish.roastLevel),
      createdAt: existingShareSnap.exists ?
        existingShareSnap.get("createdAt") || now :
        now,
      updatedAt: now,
    },
    {merge: true},
  );

  const shareUrl = `${SHARE_BASE_URL}/r/${shareId}`;
  return {shareId, shareUrl};
}

async function renderRoastShare(req, res) {
  try {
    const shareId = extractShareId(req.path || req.url);

    if (!shareId) {
      sendHtml(res, 404, renderStatusPage(
        "Roast not found",
        "This shared roast link does not exist or was typed incorrectly.",
      ));
      return;
    }

    const shareSnap = await firestore()
      .collection("shared_roasts")
      .doc(shareId)
      .get();

    if (!shareSnap.exists) {
      sendHtml(res, 404, renderStatusPage(
        "Roast not found",
        "This shared roast link does not exist or was typed incorrectly.",
      ));
      return;
    }

    const share = shareSnap.data() || {};
    if (share.active !== true) {
      sendHtml(res, 410, renderStatusPage(
        "Roast unavailable",
        "This shared roast is no longer available.",
      ));
      return;
    }

    res.set("Cache-Control", "public, max-age=300, s-maxage=600");
    sendHtml(res, 200, renderSharePage(share, shareId));
  } catch (error) {
    console.error("renderRoastShare failed", {
      message: error?.message || "unknown",
    });
    sendHtml(res, 500, renderStatusPage(
      "Something went wrong",
      "The roast page could not be loaded right now.",
    ));
  }
}

function extractShareId(path) {
  const match = String(path || "").match(/\/r\/([^/?#]+)/);
  return match ? decodeURIComponent(match[1]) : "";
}

function buildShareTitle(dish) {
  const dishName = asText(dish.dishName);
  return dishName ? `${dishName} got roasted` : "Roast Them All";
}

function buildStableShareId(uid, sourcePath) {
  return crypto
    .createHash("sha256")
    .update(`${uid}:${sourcePath}`)
    .digest("base64url")
    .slice(0, 18);
}

function renderSharePage(share, shareId) {
  const title = asText(share.title) || "Roast Them All";
  const excerpt =
    asText(share.excerpt) || "A food roast from Roast Them All.";
  const content = asText(share.content);
  const ogImage = asUrl(share.ogImageUrl) || DEFAULT_OG_IMAGE;
  const canonicalUrl = `${SHARE_BASE_URL}/r/${encodeURIComponent(shareId)}`;
  const dishName = asText(share.dishName) || "Shared roast";
  const dishWeight = asDisplay(share.dishWeight);
  const itemImageUrl = asUrl(share.itemImageUrl) || asUrl(share.imageUrl);
  const roastImageUrl = asUrl(share.roastImageUrl) || itemImageUrl;
  const audioUrl = asUrl(share.audioUrl);
  const kcal = asNumber(share.kcal);
  const headlineParts = [
    dishName,
    dishWeight,
    Number.isFinite(kcal) && kcal > 0 ? `${formatNumber(kcal)} kcal/dish` : "",
  ].filter(Boolean);

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>${escapeHtml(title)}</title>
  <meta name="description" content="${escapeAttr(excerpt)}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="Roast Them All">
  <meta property="og:title" content="${escapeAttr(title)}">
  <meta property="og:description" content="${escapeAttr(excerpt)}">
  <meta property="og:image" content="${escapeAttr(ogImage)}">
  <meta property="og:url" content="${escapeAttr(canonicalUrl)}">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="${escapeAttr(title)}">
  <meta name="twitter:description" content="${escapeAttr(excerpt)}">
  <meta name="twitter:image" content="${escapeAttr(ogImage)}">
  <style>${renderCss()}</style>
</head>
<body>
  <main class="app-shell">
    <section class="dish-card">
      <div class="dish-summary">
        ${renderImage(itemImageUrl, "dish-image", dishName)}
        <div class="dish-copy">
          <p class="dish-title">${escapeHtml(headlineParts.join(" | "))}</p>
          ${renderRestaurant(share.restaurant)}
          ${renderMetaPills(share)}
        </div>
      </div>
      ${renderNutrition(share)}
      <div class="section-label">Roast</div>
      <div class="roast-row">
        ${renderImage(roastImageUrl, "roast-image", "Roast character")}
        <div class="roast-stack">
          <div class="roast-bubble">${renderParagraphs(content)}</div>
          ${renderAudioPlayer(audioUrl)}
        </div>
      </div>
    </section>
    <section class="download-card">
      <div>
        <p class="download-title">Roast your next meal</p>
        <p class="download-copy">Open Roast Them All to track food, hear the roast, and share the damage.</p>
      </div>
      <a class="store-button" href="${escapeAttr(APP_STORE_URL)}" rel="noopener">Get Roast</a>
    </section>
  </main>
</body>
</html>`;
}

function renderNutrition(share) {
  const items = [
    ["Kcal", share.kcal, ""],
    ["Proteins", share.proteins, "g"],
    ["Fats", share.fats, "g"],
    ["Carbs", share.carbs, "g"],
  ].filter((item) => Number.isFinite(item[1]) && item[1] > 0);

  if (!items.length) {
    return "";
  }

  return `<div class="nutrition-grid">${items
    .map(([label, value, unit]) =>
      `<div class="nutrition-item"><strong>${escapeHtml(
        formatNumber(value),
      )}${escapeHtml(unit)}</strong><span>${escapeHtml(label)}</span></div>`,
    )
    .join("")}</div>`;
}

function renderParagraphs(value) {
  const paragraphs = asText(value)
    .split(/\n{2,}|\r\n{2,}/)
    .map((part) => part.trim())
    .filter(Boolean);

  if (!paragraphs.length) {
    return "<p>This roast is not available.</p>";
  }

  return paragraphs.map((part) => `<p>${escapeHtml(part)}</p>`).join("");
}

function renderRestaurant(value) {
  const text = asText(value);
  return text ? `<p class="restaurant">${escapeHtml(text)}</p>` : "";
}

function renderMetaPills(share) {
  const pills = [
    [share.badge, "danger"],
    [share.impact, ""],
    [share.calorieShare, ""],
  ].filter(([value]) => asText(value));

  if (!pills.length) {
    return "";
  }

  return `<div class="meta-pills">${pills
    .map(([value, tone]) =>
      `<span class="meta-pill ${escapeAttr(tone)}">${escapeHtml(
        asText(value),
      )}</span>`,
    )
    .join("")}</div>`;
}

function renderImage(url, className, alt) {
  const imageUrl = asUrl(url);
  if (imageUrl) {
    return `<img class="${escapeAttr(className)}" src="${escapeAttr(
      imageUrl,
    )}" alt="${escapeAttr(alt)}" loading="eager">`;
  }

  return `<div class="${escapeAttr(
    className,
  )} image-placeholder" aria-hidden="true"><span>RN</span></div>`;
}

function renderAudioPlayer(audioUrl) {
  if (!audioUrl) {
    return "";
  }

  return `<div class="audio-card"><span>Listen to roast</span><audio controls preload="none" src="${escapeAttr(
    audioUrl,
  )}"></audio></div>`;
}

function renderStatusPage(title, message) {
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(title)}</title>
  <style>${renderCss()}</style>
</head>
<body>
  <main class="app-shell status">
    <section class="status-card">
      <h1>${escapeHtml(title)}</h1>
      <p>${escapeHtml(message)}</p>
      <a class="store-button" href="${escapeAttr(SHARE_BASE_URL)}">Back to Roast Them All</a>
    </section>
  </main>
</body>
</html>`;
}

function renderCss() {
  return `
    :root { color-scheme: light; --bg: #ff8a1f; --card: #fff; --text: #141414; --muted: #787880; --soft: #f2f2f7; --roast: #fae6d7; --danger: #ff3b30; --shadow: 0 18px 44px rgba(28, 28, 30, 0.08); }
    * { box-sizing: border-box; }
    body { margin: 0; min-height: 100vh; background: var(--bg); color: var(--text); font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", sans-serif; line-height: 1.35; }
    .app-shell { width: min(100%, 430px); min-height: 100vh; margin: 0 auto; padding: max(14px, env(safe-area-inset-top)) 14px 34px; }
    .dish-card, .download-card, .status-card { background: var(--card); border-radius: 20px; box-shadow: var(--shadow); }
    .dish-card { padding: 14px; }
    .dish-summary { display: grid; grid-template-columns: 80px 1fr; gap: 12px; align-items: stretch; }
    .dish-image { display: block; width: 80px; height: 110px; border: 1px solid var(--soft); border-radius: 16px; object-fit: cover; background: var(--soft); }
    .dish-copy { min-width: 0; display: flex; flex-direction: column; justify-content: center; }
    .dish-title { margin: 0; color: var(--text); font-size: 16px; font-weight: 600; }
    .restaurant { margin: 6px 0 0; color: var(--muted); font-size: 13px; font-weight: 500; }
    .meta-pills { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px; }
    .meta-pill { min-height: 25px; display: inline-flex; align-items: center; max-width: 100%; padding: 0 12px; border-radius: 999px; background: var(--soft); color: var(--text); font-size: 12px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .meta-pill.danger { color: var(--danger); }
    .nutrition-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 8px; margin-top: 14px; }
    .nutrition-item { min-height: 56px; border-radius: 16px; background: var(--soft); display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; }
    .nutrition-item strong { font-size: 16px; font-weight: 700; }
    .nutrition-item span { display: block; margin-top: 2px; color: var(--muted); font-size: 11px; font-weight: 600; }
    .section-label { margin: 18px 0 10px; color: var(--muted); font-size: 13px; font-weight: 700; }
    .roast-row { display: grid; grid-template-columns: 60px 1fr; gap: 10px; align-items: start; }
    .roast-image { display: block; width: 60px; height: 60px; border-radius: 14px; object-fit: cover; background: var(--soft); }
    .image-placeholder { display: flex; align-items: center; justify-content: center; color: rgba(20, 20, 20, 0.38); font-size: 12px; font-weight: 800; letter-spacing: 0.04em; }
    .roast-stack { min-width: 0; display: grid; gap: 10px; }
    .roast-bubble { min-height: 60px; padding: 12px; border-radius: 16px; background: var(--roast); color: #000; font-size: 16px; font-weight: 400; }
    .roast-bubble p { margin: 0; }
    .roast-bubble p + p { margin-top: 10px; }
    .audio-card { display: grid; gap: 8px; padding: 10px 12px 12px; border-radius: 16px; background: var(--soft); }
    .audio-card span { color: var(--muted); font-size: 12px; font-weight: 700; }
    audio { width: 100%; height: 34px; }
    .download-card { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-top: 14px; padding: 16px; }
    .download-title { margin: 0; font-size: 16px; font-weight: 700; }
    .download-copy { margin: 5px 0 0; max-width: 260px; color: var(--muted); font-size: 13px; font-weight: 500; }
    .store-button { flex: 0 0 auto; display: inline-flex; min-height: 38px; align-items: center; justify-content: center; padding: 0 14px; border-radius: 999px; background: #141414; color: #fff; text-decoration: none; font-size: 13px; font-weight: 700; }
    .status { display: grid; place-items: center; }
    .status-card { padding: 24px; text-align: center; }
    .status-card h1 { margin: 0; font-size: 24px; }
    .status-card p { margin: 10px 0 18px; color: var(--muted); font-size: 14px; }
  `;
}

function sendHtml(res, statusCode, html) {
  res.status(statusCode).set("Content-Type", "text/html; charset=utf-8").send(html);
}

function summarize(value, maxLength) {
  const text = asText(value).replace(/\s+/g, " ").trim();
  if (text.length <= maxLength) {
    return text;
  }
  return `${text.slice(0, maxLength - 1).trim()}...`;
}

function asText(value) {
  return typeof value === "string" ? value.trim() : "";
}

function asDisplay(value) {
  if (typeof value === "string") {
    return value.trim();
  }
  if (Number.isFinite(value)) {
    return formatNumber(value);
  }
  return "";
}

function asUrl(value) {
  const text = asText(value);
  return /^https?:\/\//i.test(text) ? text : "";
}

function asNumber(value) {
  const number = Number(value);
  return Number.isFinite(number) ? number : null;
}

function formatNumber(value) {
  const number = Number(value);
  if (!Number.isFinite(number)) {
    return "";
  }
  return Number.isInteger(number) ? String(number) : String(Math.round(number));
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function escapeAttr(value) {
  return escapeHtml(value).replace(/`/g, "&#96;");
}

module.exports = {
  createRoastShare,
  renderRoastShare,
  _test: {
    asNumber,
    asUrl,
    buildStableShareId,
    extractShareId,
    summarize,
  },
};
