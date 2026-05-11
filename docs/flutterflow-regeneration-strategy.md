# FlutterFlow Regeneration Strategy

Date: 2026-05-10

This project contains FlutterFlow-generated screens plus hand-written service,
backend, and custom code. Treat generated files as editable only when the change
is small, tested, and easy to reapply after a FlutterFlow export.

## Prefer Stable Code Boundaries

Put durable logic outside page widgets:

| Logic | Preferred location |
| --- | --- |
| Nutrition totals, progress, conversions | `lib/services/nutrition_summary.dart` |
| Usage limit decisions | `lib/services/usage_limit_service.dart` |
| Server-owned user mutations | `lib/services/user_account_mutations.dart` + Firebase callables |
| Safe client error reporting envelope | `lib/services/error_reporter.dart` |
| Cloud callable timeout/error contract | `lib/backend/cloud_functions/cloud_functions.dart` |
| HTTP API timeout/error contract | `lib/backend/api_requests/api_calls.dart` |
| Firestore ownership and billing protections | `firebase/firestore.rules` |
| Firebase Functions operational notes | `docs/functions-runbook.md` |

Widgets should mostly render state, collect input, call services/actions, and
show user feedback.

## Generated File Change Rules

- Keep generated widget edits narrow and repeatable.
- Prefer replacing duplicated predicates with service calls instead of adding
  more branches to the widget.
- Avoid introducing new long-lived business rules directly into page widgets.
- After any FlutterFlow export, run the verification checklist below and
  reapply service imports/calls if the export overwrites them.
- Do not reintroduce broad analyzer exclusions for `lib/custom_code/**` or
  generated helper files.

## Current Manual Edits To Watch After Export

| Area | Files |
| --- | --- |
| RevenueCat startup moved after first frame and SDK keys use `--dart-define` | `lib/main.dart`, `lib/flutter_flow/revenue_cat_util.dart` |
| Home day-scoped query and daily totals service | `lib/main_page/home/home_widget.dart` |
| Chat send controller, history preload, user-scoped thread id, render ordering, and stable message keys | `lib/chat/chat_copy/chat_copy_widget.dart`, `lib/services/chat_controller.dart`, `lib/services/chat_history_view.dart` |
| Debounced chat history persistence under `ff_chathistory` | `lib/app_state.dart` |
| Usage limit service calls and backend usage accounting | `lib/chat/chat_copy/chat_copy_widget.dart`, `lib/dish_info/dish_info/dish_info_widget.dart`, `lib/main_page/choose_person/choose_person_widget.dart` |
| Subscription/reload purchase sync via backend | `lib/subscription_page/subscription_page_widget.dart`, `lib/roast_reload_pack/roast_reload_pack_widget.dart`, `lib/main_page/home/home_widget.dart` |
| Local font usage after removing Google Fonts | generated widgets that previously imported `package:google_fonts` |
| Structured AI/cloud error handling | `lib/backend/ai_agents/ai_agent_cloud_function_call.dart` |
| Global Flutter/Platform error handler | `lib/main.dart`, `lib/services/error_reporter.dart` |

## Verification Checklist

```sh
flutter pub get
flutter analyze
flutter test
git diff --check

actual_mb="$(du -sm assets/fonts | cut -f1)"
test "${actual_mb}" -le 10

cd firebase/functions
npm ci
npm audit --audit-level=high
npm run lint
node -e "require('./index.js'); console.log('functions source loads')"

cd ..
npx --yes firebase-tools@latest emulators:exec \
  --project demo-roast \
  --only firestore \
  "npm --prefix functions run test:rules"
```

For release-size-impacting changes:

```sh
flutter build apk --release --analyze-size --target-platform android-arm64
```

Compare against the snapshots documented in `docs/performance-baseline.md`.
