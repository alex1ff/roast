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
  const roastMode = asText(dish.roast_mode) || "roast";
  const subjectType = asText(dish.subject_type);
  const showNutrition = shouldShowNutrition({
    roastMode,
    subjectType,
    showNutrition: asBool(dish.show_nutrition),
    kcal: asNumber(dish.kcal),
    proteins: asNumber(dish.proteins),
    fats: asNumber(dish.fats),
    carbs: asNumber(dish.carbs),
  });

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
      roastMode,
      occasionKey: asText(dish.occasion_key),
      occasionLabel: asText(dish.occasion_label),
      subjectType,
      showNutrition,
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
  const occasionLabel = asText(dish.occasion_label);
  if (isCongratuRoastShare({
    roast_mode: dish.roast_mode,
    occasion_label: occasionLabel,
  })) {
    const subjectName = isPlaceholderSubject(dishName) ? "" : dishName;
    return subjectName ?
      `${subjectName} got congraturoasted` :
      `${occasionLabel || "CongratuRoast"} from Roast Them All`;
  }
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
    asText(share.excerpt) || "A roast from Roast Them All.";
  const content = asText(share.content);
  const ogImage = asUrl(share.ogImageUrl) || DEFAULT_OG_IMAGE;
  const canonicalUrl = `${SHARE_BASE_URL}/r/${encodeURIComponent(shareId)}`;
  const rawDishName = asText(share.dishName);
  const dishWeight = asDisplay(share.dishWeight);
  const itemImageUrl = asUrl(share.itemImageUrl) || asUrl(share.imageUrl);
  const roastImageUrl = asUrl(share.roastImageUrl) || itemImageUrl;
  const audioUrl = asUrl(share.audioUrl);
  const primaryImageUrl = itemImageUrl || roastImageUrl;
  const actionClass = audioUrl ? "primary-actions" : "primary-actions single-action";
  const isCongratuRoast = isCongratuRoastShare(share);
  const showNutrition = isCongratuRoast ? false : shouldShowNutrition(share);
  const headlineParts = buildHeadlineParts({
    dishName: rawDishName,
    dishWeight,
    share,
    showNutrition,
    isCongratuRoast,
  });
  const imageAlt = headlineParts.join(" ") || rawDishName || "Shared roast";
  const bodyClass = isCongratuRoast ? "celebration-body" : "";
  const bodyAttributes = bodyClass ? ` class="${escapeAttr(bodyClass)}"` : "";
  const dishCardClass = isCongratuRoast ?
    "dish-card celebration-card" :
    "dish-card";
  const roastBubbleClass = isCongratuRoast ?
    "roast-bubble celebration-bubble" :
    "roast-bubble";
  const downloadTitle = isCongratuRoast ?
    "Return the favor. Roast them back." :
    "Don’t just take it! Roast back!";
  const downloadCopy = isCongratuRoast ?
    "Get Roast Them All & start the chaos. Roast friends, pets, dishes, congratulate them with roasts, or do both." :
    "Get Roast Them All app & start the chaos: roast friends, dishes, or whatever you want.";
  const sectionLabel = isCongratuRoast ?
    "Congratu'Roast" :
    showNutrition ? "Dish Roast" : "Roast Result";
  const heroCaption = isCongratuRoast ?
    "" :
    renderHeroCaption(headlineParts, share, showNutrition);

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
<body${bodyAttributes}>
  <main class="app-shell">
    <section class="${escapeAttr(dishCardClass)}">
      ${isCongratuRoast ? renderCelebrationHeader(share) : ""}
      <div class="hero-frame">
        ${renderImage(primaryImageUrl, "hero-image", imageAlt)}
        ${heroCaption}
      </div>
      <div class="${escapeAttr(actionClass)}">
        ${renderAudioPlayer(audioUrl, isCongratuRoast ? "Play Congratu'Roast" : "Play roast")}
        ${renderRoastBackButton("top-cta")}
      </div>
      <div class="section-label">${escapeHtml(sectionLabel)}</div>
      <div class="${escapeAttr(roastBubbleClass)}">${renderParagraphs(content)}</div>
      ${showNutrition ? renderNutrition(share) : ""}
    </section>
    <section class="download-card">
      <div>
        <p class="download-title">${escapeHtml(downloadTitle)}</p>
        <p class="download-copy">${escapeHtml(downloadCopy)}</p>
      </div>
      ${renderRoastBackButton("bottom-cta")}
    </section>
  </main>
</body>
</html>`;
}

function buildHeadlineParts({
  dishName,
  dishWeight,
  share,
  showNutrition,
  isCongratuRoast,
}) {
  if (isCongratuRoast) {
    const occasionLabel = asText(share.occasionLabel || share.occasion_label);
    const subjectName = isPlaceholderSubject(dishName) ? "" : asText(dishName);
    return [
      occasionLabel || "CongratuRoast",
      subjectName,
    ].filter(Boolean);
  }

  return [
    asText(dishName) || "Shared roast",
    showNutrition ? dishWeight : "",
  ].filter(Boolean);
}

function renderCelebrationHeader(share) {
  const occasionLabel = asText(share.occasionLabel || share.occasion_label);
  const title = occasionLabel || "CongratuRoast";
  return `<div class="celebration-header"><span>Congrats, roasted</span><strong>${escapeHtml(
    title,
  )}</strong></div>`;
}

function renderHeroCaption(headlineParts, share, showNutrition) {
  const headline = headlineParts.join(" | ");
  const restaurant = renderRestaurant(share.restaurant);
  const meta = renderMetaPills(share, showNutrition);

  if (!headline && !restaurant && !meta) {
    return "";
  }

  return `<div class="hero-caption">${
    headline ? `<p class="dish-title">${escapeHtml(headline)}</p>` : ""
  }${restaurant}${meta}</div>`;
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

function renderMetaPills(share, showNutrition) {
  const pills = showNutrition ? [
    [share.badge, "danger"],
    [share.impact, ""],
    [share.calorieShare, ""],
  ].filter(([value]) => asText(value)) : [
    [share.occasionLabel, ""],
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

function renderAudioPlayer(audioUrl, label = "Play roast") {
  if (!audioUrl) {
    return "";
  }

  return `<div class="audio-card"><span>${escapeHtml(label)}</span><audio controls preload="none" src="${escapeAttr(
    audioUrl,
  )}"></audio></div>`;
}

function renderRoastBackButton(extraClass) {
  const className = ["store-button", extraClass].filter(Boolean).join(" ");
  return `<a class="${escapeAttr(className)}" href="${escapeAttr(
    APP_STORE_URL,
  )}" rel="noopener">Roast Back</a>`;
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
    body.celebration-body { background: radial-gradient(circle at 18% 8%, rgba(255, 255, 255, 0.52) 0 2px, transparent 3px), radial-gradient(circle at 82% 16%, rgba(255, 255, 255, 0.46) 0 3px, transparent 4px), radial-gradient(circle at 28% 72%, rgba(255, 255, 255, 0.38) 0 2px, transparent 3px), linear-gradient(135deg, #ff7a18 0%, #ffd166 48%, #ff4f87 100%); background-size: 92px 92px, 118px 118px, 76px 76px, auto; }
    .app-shell { width: min(100%, 430px); min-height: 100vh; margin: 0 auto; padding: max(14px, env(safe-area-inset-top)) 14px 34px; }
    .dish-card, .download-card, .status-card { background: var(--card); border-radius: 20px; box-shadow: var(--shadow); }
    .dish-card { display: grid; gap: 14px; padding: 14px; }
    .celebration-card { position: relative; overflow: hidden; border: 2px solid rgba(255, 196, 107, 0.95); background: linear-gradient(180deg, #fff9df 0%, #fff2ec 58%, #fff7db 100%); box-shadow: 0 24px 60px rgba(115, 45, 0, 0.18); }
    .celebration-card::before { content: ""; position: absolute; inset: 0; pointer-events: none; background: radial-gradient(circle at 12% 12%, rgba(255, 79, 135, 0.18) 0 2px, transparent 3px), radial-gradient(circle at 88% 18%, rgba(255, 138, 31, 0.2) 0 3px, transparent 4px), radial-gradient(circle at 74% 86%, rgba(255, 209, 102, 0.32) 0 4px, transparent 5px); background-size: 84px 84px, 110px 110px, 96px 96px; }
    .celebration-card > * { position: relative; z-index: 1; }
    .celebration-header { display: grid; gap: 3px; padding: 15px 16px 16px; border-radius: 18px; background: linear-gradient(135deg, #ff6b00 0%, #ffb703 58%, #ff4f87 100%); box-shadow: inset 0 1px 0 rgba(255,255,255,0.38), 0 14px 28px rgba(255, 107, 0, 0.2); }
    .celebration-header span { color: rgba(255, 255, 255, 0.88); font-size: 12px; font-weight: 850; text-transform: uppercase; letter-spacing: 0.1em; }
    .celebration-header strong { color: #fff; font-size: 30px; line-height: 1.02; font-weight: 900; text-shadow: 0 2px 12px rgba(80, 22, 0, 0.18); }
    .celebration-card .hero-frame { background: #fff4d6; border: 2px solid rgba(255, 184, 77, 0.95); box-shadow: 0 16px 34px rgba(255, 138, 31, 0.18); }
    .hero-frame { position: relative; overflow: hidden; border-radius: 18px; background: var(--soft); }
    .hero-image { display: block; width: 100%; height: min(62vh, 360px); object-fit: cover; background: var(--soft); }
    .hero-caption { position: absolute; left: 0; right: 0; bottom: 0; padding: 42px 14px 14px; color: #fff; background: linear-gradient(180deg, rgba(20, 20, 20, 0), rgba(20, 20, 20, 0.82)); }
    .dish-title { margin: 0; color: var(--text); font-size: 16px; font-weight: 600; }
    .hero-caption .dish-title { color: #fff; }
    .restaurant { margin: 6px 0 0; color: var(--muted); font-size: 13px; font-weight: 500; }
    .hero-caption .restaurant { color: rgba(255, 255, 255, 0.78); }
    .meta-pills { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px; }
    .meta-pill { min-height: 25px; display: inline-flex; align-items: center; max-width: 100%; padding: 0 12px; border-radius: 999px; background: var(--soft); color: var(--text); font-size: 12px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .hero-caption .meta-pill { background: rgba(255, 255, 255, 0.18); color: #fff; }
    .celebration-card .hero-caption .meta-pill { background: rgba(255, 209, 102, 0.32); color: #fff; }
    .meta-pill.danger { color: var(--danger); }
    .hero-caption .meta-pill.danger { color: #ffdfdc; }
    .primary-actions { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 10px; align-items: center; }
    .primary-actions.single-action { grid-template-columns: 1fr; }
    .nutrition-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 8px; margin-top: 14px; }
    .nutrition-item { min-height: 56px; border-radius: 16px; background: var(--soft); display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; }
    .nutrition-item strong { font-size: 16px; font-weight: 700; }
    .nutrition-item span { display: block; margin-top: 2px; color: var(--muted); font-size: 11px; font-weight: 600; }
    .section-label { margin: 2px 0 -4px; color: var(--muted); font-size: 13px; font-weight: 700; }
    .celebration-card .section-label { width: fit-content; margin-top: 4px; padding: 6px 12px; border-radius: 999px; background: #ff6b00; color: #fff; box-shadow: 0 8px 18px rgba(255, 107, 0, 0.2); }
    .image-placeholder { display: flex; align-items: center; justify-content: center; color: rgba(20, 20, 20, 0.38); font-size: 12px; font-weight: 800; letter-spacing: 0.04em; }
    .roast-bubble { min-height: 60px; padding: 12px; border-radius: 16px; background: var(--roast); color: #000; font-size: 16px; font-weight: 400; }
    .celebration-bubble { background: linear-gradient(135deg, #fff3c4 0%, #ffe0ec 72%, #fffaf0 100%); border: 2px solid rgba(255, 184, 77, 0.95); box-shadow: 0 14px 30px rgba(255, 138, 31, 0.18); font-weight: 500; }
    .roast-bubble p { margin: 0; }
    .roast-bubble p + p { margin-top: 10px; }
    .audio-card { min-width: 0; display: grid; align-content: center; gap: 8px; padding: 10px 12px 12px; border-radius: 16px; background: var(--soft); }
    .celebration-card .audio-card { background: rgba(255, 255, 255, 0.72); border: 2px solid rgba(255, 196, 107, 0.82); box-shadow: 0 10px 24px rgba(255, 138, 31, 0.12); }
    .celebration-card .audio-card span { color: #b45309; }
    .audio-card span { color: var(--muted); font-size: 12px; font-weight: 700; }
    audio { width: 100%; height: 34px; }
    .download-card { display: grid; grid-template-columns: minmax(0, 1fr) auto; align-items: center; gap: 12px; margin-top: 14px; padding: 16px; }
    .celebration-body .download-card { background: #fffaf0; border: 1px solid rgba(255, 196, 107, 0.9); }
    .download-title { margin: 0; font-size: 16px; font-weight: 700; }
    .download-copy { margin: 5px 0 0; max-width: 260px; color: var(--muted); font-size: 13px; font-weight: 500; }
    .store-button { flex: 0 0 auto; display: inline-flex; min-height: 38px; align-items: center; justify-content: center; padding: 0 14px; border-radius: 999px; background: #141414; color: #fff; text-decoration: none; font-size: 13px; font-weight: 700; white-space: nowrap; }
    .celebration-body .store-button { background: #ff6b00; box-shadow: 0 10px 22px rgba(255, 107, 0, 0.24); }
    .top-cta { min-height: 48px; padding: 0 18px; align-self: center; }
    .status { display: grid; place-items: center; }
    .status-card { padding: 24px; text-align: center; }
    .status-card h1 { margin: 0; font-size: 24px; }
    .status-card p { margin: 10px 0 18px; color: var(--muted); font-size: 14px; }
    @media (max-width: 360px) {
      .primary-actions, .download-card { grid-template-columns: 1fr; }
      .store-button { width: 100%; }
      .top-cta { min-height: 48px; }
    }
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

function asBool(value) {
  if (typeof value === "boolean") {
    return value;
  }
  if (typeof value === "string") {
    const normalized = value.trim().toLowerCase();
    if (normalized === "true") {
      return true;
    }
    if (normalized === "false") {
      return false;
    }
  }
  return null;
}

function shouldShowNutrition(share) {
  const mode = asText(share.roastMode || share.roast_mode) || "roast";
  const subjectType = asText(share.subjectType || share.subject_type);
  if (mode === "congratu_roast" || isCongratuRoastShare(share)) {
    return false;
  }
  if (subjectType && subjectType !== "dish") {
    return false;
  }
  const explicit = asBool(share.showNutrition ?? share.show_nutrition);
  if (explicit !== null) {
    return explicit;
  }
  return [
    share.kcal,
    share.proteins,
    share.fats,
    share.carbs,
  ].some((value) => {
    const number = Number(value);
    return Number.isFinite(number) && number > 0;
  });
}

function isCongratuRoastShare(share) {
  const mode = asText(share.roastMode || share.roast_mode);
  if (mode === "congratu_roast") {
    return true;
  }

  if (asText(share.occasionLabel || share.occasion_label)) {
    return true;
  }

  return /congraturoast/i.test(
    [
      asText(share.title),
      asText(share.excerpt),
      asText(share.content),
    ].join(" "),
  );
}

function isPlaceholderSubject(value) {
  switch (asText(value).toLowerCase()) {
    case "":
    case "-":
    case "dish":
    case "friend":
    case "shared roast":
    case "roast result":
      return true;
    default:
      return false;
  }
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
    renderSharePage,
    shouldShowNutrition,
    summarize,
  },
};
