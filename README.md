# Roast Them All

Flutter nutrition tracker that turns a meal photo or description into a structured, intentionally playful “roast” with estimated calories and macros. Results feed a daily diary, progress summaries, follow-up chat, and audio playback.

## Engineering highlights

- presentation kept separate from nutrition, usage-limit, chat, audio, and error-reporting services;
- Firebase rules protect user-owned history and server-owned billing fields;
- AI calls and account mutations go through bounded backend adapters;
- RevenueCat entitlements and reload packs are reconciled through server-owned state;
- 51 Flutter tests plus Cloud Functions, lint, and emulator-backed Firestore rule checks.

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the request flow, component boundaries, and security model.

## Source ownership

The original interface was exported from FlutterFlow. FlutterFlow regeneration is retired: GitHub is now the only source of truth and generated-style files are maintained like normal code.

Durable logic lives outside large page widgets where practical:

| Concern | Maintained boundary |
| --- | --- |
| Nutrition totals and goals | `lib/services/nutrition_summary.dart`, `calorie_goal_service.dart` |
| AI result normalization | `lib/services/roast_analysis.dart`, backend AI adapters |
| Chat state and persistence | `lib/services/chat_controller.dart`, `chat_history_view.dart` |
| Usage and purchase state | `usage_limit_service.dart`, `user_account_mutations.dart` |
| Errors and performance | `error_reporter.dart`, `performance_monitor.dart` |

More detail: [docs/source-ownership.md](docs/source-ownership.md).

## Local setup

Required versions: Flutter 3.35.3 / Dart 3.9.2, Node.js 22, and Java 21 for Firebase emulators.

```bash
flutter pub get
flutter analyze
flutter test
```

Backend checks use repository-pinned Firebase tooling:

```bash
npm ci
npm ci --prefix firebase/functions
npm ci --prefix firebase/custom_cloud_functions
npm run backend:checks
```

The backend command runs lint, function tests, and Firestore rule tests against a local demo emulator. It does not deploy or access production data.

## Project structure

| Path | Responsibility |
| --- | --- |
| `lib/services/` | Maintained application use cases |
| `lib/backend/` | Firebase, Cloud Functions, API, and AI transport boundaries |
| `lib/main_page/` | Meal capture, diary, and home surfaces |
| `lib/dish_info/` | Roast result and nutrition detail UI |
| `lib/chat/` | Follow-up conversation UI |
| `firebase/functions/` | AI/share endpoints and Firestore rule tests |
| `firebase/custom_cloud_functions/` | Media-oriented custom functions |
| `test/` | Unit, widget, contract, and regression tests |

## Runtime configuration

Local API values belong in untracked `dart_defines*.json` files or explicit `--dart-define` arguments. Firebase platform identifiers and RevenueCat public SDK keys are client configuration; server credentials and private provider keys must remain in Firebase secrets or the deployment environment.

## CI quality gate

GitHub Actions runs pinned Flutter analysis/tests and an independent backend job. Both must pass before `main` is considered releasable.
