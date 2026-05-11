# Dependency Upgrade Plan

Date: 2026-05-11

This plan is based on `flutter pub outdated --json` from the current
`flutterflow` workspace after removing discontinued packages and adding
`pubspec.lock`.

## Current Snapshot

| Signal | Value |
| --- | ---: |
| Direct/dev packages reported | 81 |
| Direct/dev packages with major latest versions | 26 |
| Discontinued packages | 0 |
| Current packages affected by advisory | 0 |
| `dependency_overrides` in `pubspec.yaml` | 0 |
| Functions high/critical npm advisories | 0 |
| Functions low npm advisories | 9 accepted |

Previously discontinued packages are no longer present:

- `firebase_vertexai` removed.
- `flutter_markdown` replaced by `flutter_markdown_plus`.

## Issue Acceptance Status

- [x] Discontinued packages are absent or have an approved exception.
- [x] `dependency_overrides` are minimal and documented.
- [x] `flutter pub outdated` shows no current advisories or discontinued direct/dev packages without a plan.
- [x] Functions `npm audit --omit=dev --audit-level=high` passes for both codebases.
- [ ] Dependency upgrade PRs stay small and verifiable.
- [ ] After upgrade waves, the app builds and passes smoke flows: auth, Home, add dish, chat, subscription.

## Accepted npm Low Findings

Both Functions codebases currently report 9 low-severity transitive npm audit
findings through the Firebase Admin / Google Cloud dependency chain:
`@google-cloud/firestore`, `@google-cloud/storage`, `google-gax`,
`retry-request`, `teeny-request`, `http-proxy-agent`, and
`@tootallnate/once`.

`npm audit fix --force` proposes semver-major downgrades such as
`firebase-admin` 10.3.0 / `firebase-functions` 4.9.0 or
`@google-cloud/storage` 5.18.3. Do not apply those forced fixes because the
project is on Firebase Functions v7, Node 22, and deployed source parity now
depends on the newer runtime stack.

Current policy:

- Block high/critical production advisories in `scripts/local_ci.sh`.
- Keep low findings accepted until upstream packages provide a non-downgrade
  fix.
- Recheck this section during each dependency wave.

## Upgrade Waves

Keep each wave as a small PR. Do not combine Firebase, auth, routing, billing,
and lints in one change.

### Wave 1: Patch/Minor Low-Risk Packages

Status: completed locally on 2026-05-11.

Candidates:

- `audio_session` 0.2.2 -> 0.2.3
- `easy_debounce` 2.0.1 -> 2.0.3
- `equatable` 2.0.7 -> 2.0.8
- `flutter_animate` 4.5.0 -> 4.5.2
- `http` 1.4.0 -> 1.6.0
- `just_audio` 0.10.4 -> 0.10.5
- `just_audio_platform_interface` 4.5.0 -> 4.6.0, required by `just_audio` 0.10.5.
- `path_provider` 2.1.4 -> 2.1.5
- `provider` 6.1.5 -> 6.1.5+1
- `shared_preferences` 2.5.3 -> 2.5.5
- `stream_transform` 2.1.0 -> 2.1.1
- `url_launcher` 6.3.1 -> 6.3.2

Verification completed:

```sh
flutter pub get
git diff --check
flutter analyze
flutter test
flutter build apk --release --target-platform android-arm64
flutter pub outdated --json
```

Result: analyzer passed, 26 Flutter tests passed, arm64 release APK built at
30.7 MB, and `flutter pub outdated --json` still reports 0 discontinued
packages and 0 current advisories.

Verification:

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --release --target-platform android-arm64
```

### Wave 2: Media And Picker Packages

Candidates:

- `image_picker` 1.1.2 -> 1.2.2 and platform packages.
- `video_player` 2.10.0 -> 2.11.1 and platform packages.
- `flutter_svg` 2.1.0 -> 2.3.0.
- `image` 4.2.0 -> 4.8.0.
- `file_picker` 10.1.9 -> 11.0.2 in its own PR because it is a major.

Smoke flows:

- Add dish from camera/gallery.
- Share dish/result.
- Audio/TTS playback.
- Any video/onboarding screens.

### Wave 3: Firebase Major Wave

Upgrade together because FlutterFire packages are coupled:

- `firebase_core` 3.14.0 -> 4.7.0
- `firebase_auth` 5.6.0 -> 6.4.0
- `cloud_firestore` 5.6.9 -> 6.3.0
- `cloud_functions` 5.5.2 -> 6.2.0
- `firebase_storage` 12.4.7 -> 13.3.0
- `firebase_performance` 0.10.1+7 -> 0.11.3

Required checks:

```sh
flutter analyze
flutter test
cd firebase
npx --yes firebase-tools@latest emulators:exec \
  --project demo-roast \
  --only firestore \
  "npm --prefix functions run test:rules"
```

Smoke flows:

- Auth login/signup/logout.
- Home Firestore reads.
- Add dish history write/read.
- Chat callable request.
- TTS HTTP request.
- Subscription/reload callable sync.

### Wave 4: Auth, Routing, Billing, Share Majors

Do these separately:

- `go_router` 12.1.3 -> 17.2.3.
- `google_sign_in` 6.3.0 -> 7.2.0 and platform packages.
- `purchases_flutter` 9.9.5 -> 10.0.2.
- `sign_in_with_apple` 7.0.1 -> 8.0.0.
- `share_plus` 12.0.2 -> 13.1.0.

Each PR needs a dedicated smoke pass for its flow.

### Wave 5: Lints

Upgrade after behavior changes are stable:

- `flutter_lints` 4.0.0 -> 6.0.0.
- `lints` 4.0.0 -> 6.1.0.

Do not enable new lints by broad excludes. Either fix warnings or document a
targeted rule exception.

## Direct Platform Package Cleanup

`pubspec.yaml` still pins many platform/interface packages directly. Because
this is a FlutterFlow export, remove those pins only in a dedicated PR after
confirming FlutterFlow does not reintroduce them. The first cleanup candidate is
packages that are normally transitives of `firebase_*`, `google_sign_in`,
`image_picker`, `shared_preferences`, `url_launcher`, and `video_player`.

## Per-Wave Exit Criteria

- `pubspec.lock` updated in the same PR.
- `flutter analyze` passes.
- `flutter test` passes.
- Android release build succeeds.
- Relevant auth/Home/add-dish/chat/subscription smoke flow is recorded in the
  PR or issue comment.
