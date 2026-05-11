# Firebase Functions Runbook

Date: 2026-05-11

## Current Source Status

Functions source in this repository currently exports:

| Function | Trigger | Status |
| --- | --- | --- |
| `onUserDeleted` | Auth `onDelete` | Deletes `users/{uid}`. |
| `aIAssistent` | callable | Requires auth; OpenAI Responses API, plaintext response, safe request-id logging, API key from env/runtime config only. |
| `roast` | callable | Requires auth; OpenAI Responses API, JSON response contract for dish/roast analysis, API key from env/runtime config only. |
| `createRoastShare` | callable | Requires auth; validates `AddedDishHistory/{id}` ownership, writes stable `shared_roasts/{shareId}`, returns `shareUrl`. |
| `renderRoastShare` | HTTP | Renders `/r/{shareId}` HTML/OG preview from `shared_roasts`; no payload logging. |
| `syncRevenueCatSubscription` | callable | Requires auth and RevenueCat secret; verifies active `Premium` entitlement before writing subscription fields and resetting usage counters. |
| `recordUsage` | callable | Requires auth; transactionally increments included usage or decrements extra credits for `roast` / `chat`. |
| `syncReloadPackPurchase` | callable | Requires auth and RevenueCat secret; credits unsynced `Roast_Reload_Pack` purchases idempotently. |

The repository also includes the deployed `custom_cloud_functions` codebase:

| Function | Trigger | Status |
| --- | --- | --- |
| `textToSpeech` | callable/HTTP callable protocol | Requires Firebase auth; validates voice/model/output controls, enforces per-user TTS daily quota, calls ElevenLabs, writes audio to Firebase Storage `tts/`, returns `result.audiopath`; ElevenLabs key from env/runtime config only. |

The local source now matches all callable/HTTP function names used by the
Flutter client. Deployment parity still requires provisioning runtime config /
secrets in Firebase before deploy.

## Local Setup

Preferred full local check:

```sh
./scripts/local_ci.sh
```

Manual function checks:

```sh
cd firebase/functions
npm ci
npm run test:functions
npm run lint
npm audit --audit-level=high
node -e "require('./index.js'); console.log('functions source loads')"

cd ../custom_cloud_functions
npm ci
npm run test:functions
npm run lint
npm audit --audit-level=high
node -e "require('./index.js'); console.log('custom functions source loads')"
```

Firestore rules tests run from `firebase/`:

```sh
cd firebase
npx --yes firebase-tools@latest emulators:exec \
  --project demo-roast \
  --only firestore \
  "npm --prefix functions run test:rules"
```

## Emulator Commands

Use the real Firebase project only when you need deployed-project parity:

```sh
cd firebase/functions
npm run serve
npm run shell
npm run logs
```

Use the demo project for rules regression tests so local tests cannot touch
production services.

## Runtime Contracts

Callable client wrapper:

- Region: `us-central1`.
- Timeout: 120 seconds.
- Success: map response from the callable.
- Failure: map with `_error: true`, `code`, `message`, local `request_id`,
  and optional `details`.
- Observability: `cloud_function_call` trace records call name, region, status,
  request id, and error code only. Callable payloads include
  `_clientRequestId` so backend logs can be correlated. It must not include
  prompts, nutrition details, tokens, user ids, or request payloads.

HTTP API client wrapper:

- Each request gets `X-Client-Request-Id`.
- `api_call` traces record call name, HTTP method, request id, status, and
  response status code.
- Request ids are correlation metadata, not auth tokens. They must not be used
  for authorization or written with user content.

Backend callable logging:

- `syncRevenueCatSubscription`, `recordUsage`, and `syncReloadPackPurchase`
  sanitize `_clientRequestId` and log only function name, request id, error
  code, and message.
- Do not log raw Axios/Firebase error objects in payment paths because they may
  contain provider request config.

Subscription and usage callables:

- `syncRevenueCatSubscription` accepts optional `entitlementId`, defaults to
  `Premium`, and reads RevenueCat by Firebase Auth uid as RevenueCat app user id.
  It uses RevenueCat API v1 `GET /subscribers/{app_user_id}`:
  https://www.revenuecat.com/docs/api-v1#tag/customers/operation/subscribers
- `recordUsage` accepts `feature: "roast" | "chat"` and performs all counter /
  extra-credit mutations server-side.
- `syncReloadPackPurchase` accepts optional `productId`, defaults to
  `Roast_Reload_Pack`, and only credits purchases newer than
  `users/{uid}.reload_pack_last_synced_at`.
- These functions rely on Admin SDK writes. Firestore rules intentionally block
  direct client writes to `dateSub*`, `SubPlan`, `count_limited*`, and
  `extra_*`.

AI callable wrapper:

- `aIAssistent` and `roast` use OpenAI Responses API.
- Secrets are read from `OPENAI_API_KEY`, `openai.api_key`, or `openai.key`.
- Agent configs are checked in at `firebase/functions/agent_configs.js` with
  provider keys stripped.
- Before provider calls, each authenticated uid is rate-limited server-side in
  `users/{uid}/private_usage/ai_{agent}_YYYYMMDD`.
- Default daily limits: `AI_DAILY_ROAST_CALL_LIMIT=80` and
  `AI_DAILY_CHAT_CALL_LIMIT=200`.
- Backend logs must not include prompts, image URLs, OpenAI request bodies, or
  provider responses.

Share functions:

- `createRoastShare` accepts `dishPath` or `dishId`.
- Only `AddedDishHistory/{id}` is accepted for `dishPath`.
- The dish owner must match `context.auth.uid`.
- `shareUrl` is `${SHARE_BASE_URL}/r/{shareId}`; default base URL is Firebase
  Hosting for the project.

TTS HTTP/callable wrapper:

- Timeout: 90 seconds.
- Client sends the Firebase ID token in the `Authorization: Bearer ...` header.
- Timeout result: `ApiCallResponse` status `408` with `TimeoutException`.
- UI must treat non-success TTS responses as user-visible failures.
- `textToSpeech` is deployed from `firebase/custom_cloud_functions` so its
  codebase name matches the deployed Firebase project.
- Secrets are read from `ELEVENLABS_API_KEY`, `ELEVEN_KEY`,
  `elevenlabs.api_key`, or `elevenlabs.key`.
- Storage bucket is read from `TTS_BUCKET`, `FIREBASE_STORAGE_BUCKET`,
  `firebase.storageBucket`, then falls back to the app bucket.
- Text payloads are capped by `TTS_MAX_TEXT_CHARS`, default 4000 characters.
- `modelid` is allowlisted to `eleven_multilingual_v2`.
- `outputformat` is allowlisted to `mp3_44100_128`.
- `voiceid` must match a safe id pattern and either be present in the
  Firestore `persons` collection or in `TTS_ALLOWED_VOICE_IDS`.
- `voice_settings` passthrough is sanitized to numeric `0..1` values for
  `stability`, `similarity_boost`, `style`, plus boolean
  `use_speaker_boost`.
- Per-user quota defaults: `TTS_DAILY_CALL_LIMIT=50` and
  `TTS_DAILY_CHAR_LIMIT=50000`. Usage is stored server-side under
  `users/{uid}/private_usage/tts_YYYYMMDD`.

## Secrets And Configuration

Before local AI/TTS function parity can be verified, document and provision the
required secrets:

| Area | Expected secret/config |
| --- | --- |
| OpenAI/LangChain providers | `OPENAI_API_KEY`, optional `AI_DAILY_ROAST_CALL_LIMIT`, `AI_DAILY_CHAT_CALL_LIMIT`. |
| Anthropic / Google GenAI | API keys if providers are enabled. |
| ElevenLabs or TTS provider | `ELEVENLABS_API_KEY`, optional `TTS_BUCKET`, `TTS_MAX_TEXT_CHARS`, `TTS_ALLOWED_VOICE_IDS`, `TTS_DAILY_CALL_LIMIT`, `TTS_DAILY_CHAR_LIMIT`. |
| Firebase Admin | Project service account or emulator credentials. |
| RevenueCat | `REVENUECAT_SECRET_KEY`; optional `revenuecat.secret_key` / `revenuecat.api_key` runtime config fallback. |
| Billing/webhooks | Provider webhook secret and entitlement/product mapping. |

Never commit secret values. Use Firebase Functions secrets or environment
configuration and document only the variable names.

Flutter client RevenueCat SDK keys are build-time configuration, not source
constants. Pass them with Dart defines:

```sh
flutter build ios --release \
  --dart-define=REVENUECAT_APPSTORE_API_KEY=...

flutter build apk --release \
  --dart-define=REVENUECAT_PLAYSTORE_API_KEY=...
```

## Deployment Checklist

- `npm ci` succeeds from `firebase/functions`.
- `npm run test:functions` passes.
- `npm run lint` passes with zero warnings.
- `npm audit --audit-level=high` has no high/critical findings.
- `node -e "require('./index.js')"` loads source without throwing.
- The same npm/test/lint/audit/source-load checks pass from
  `firebase/custom_cloud_functions`.
- Firestore rules tests pass in the demo emulator.
- Deployed callable names match Flutter client calls.
- AI functions enforce auth. TTS enforces auth, payload-size controls,
  model/output/voice controls, and per-user daily quota while preserving the
  callable HTTP response contract expected by the Flutter client.
- Timeout/error responses stay compatible with the Flutter client.
- Protected subscription/limit mutations use backend-validated writes, not
  direct client Firestore writes.

## Client Error Reporting

Flutter controlled failures use `AppErrorReporter` as the local safe envelope
before any Crashlytics/Sentry sink is attached. It reports only area, stable
message ids, request ids, status/error codes, and exception type. Do not add
prompts, dish names, user ids, request bodies, tokens, or provider responses to
report attributes.
