# Performance Baseline

Date: 2026-05-10
Branch: `flutterflow`
Base commit at audit start: `8ecc9bd`

This document records the reproducible baseline and follow-up commands for
Roast Them All optimization work. Device profiling is still a separate
follow-up task because it needs representative account data and target devices.

## Environment

| Tool | Version |
| --- | --- |
| Flutter | 3.35.3 stable |
| Dart | 3.9.2 |
| DevTools | 2.48.0 |
| Node | 20.18.0 |
| npm | 10.8.2 |
| Firebase CLI | 14.18.0 |
| Java | 22 |

## Initial Audit Signals

| Metric | Initial value | Current value | Notes |
| --- | ---: | ---: | --- |
| `assets` directory | 157 MB | 4.4 MB | Initial value from first audit pass. |
| `assets/fonts` directory | 153 MB | 1.3 MB | Heavy unused fonts removed. |
| Flutter analyzer | 29 issues | 0 issues | `flutter analyze` passes. |
| Flutter tests | failing smoke test | passing | Firebase core mocks added. |
| Functions npm audit | 4 critical, 8 high | 0 high/critical | 9 low transitive findings remain. |
| Discontinued Flutter packages | 2 | 0 | `firebase_vertexai` removed, `flutter_markdown_plus` used. |
| Android arm64 release APK | 140.5 MB APK / 134 MB compressed analysis | 30.7 MB APK / 29 MB compressed analysis | 78.1% APK reduction after asset/font cleanup. |
| Android arm64 release AAB | Not captured before cleanup | 29.1 MB AAB artifact | Local Flutter command currently exits after artifact creation because Android SDK command-line tools / `apkanalyzer` are missing. |
| iOS release app | Not captured before cleanup | 71.1 MB `Runner.app` / 68 MB displayed analysis | Built with `--no-codesign --analyze-size`. |
| Android `flutter_assets` | 101 MB | 4 MB | From release APK size analysis. |

## Release Size Snapshot

Baseline snapshot from `8ecc9bd`:

| Artifact | Value |
| --- | ---: |
| Build command wall time | 141.5 s |
| APK file | 140.5 MB |
| Compressed APK analysis total | 134 MB |
| `assets/flutter_assets` | 101 MB |
| `lib/arm64-v8a` | 27 MB |

Baseline size analysis file:

```text
/Users/patrikkardenas/.flutter-devtools/apk-code-size-analysis_03.json
```

Latest local snapshot after asset cleanup and Google Fonts removal:

| Artifact | Value |
| --- | ---: |
| Build command wall time | 104.9 s |
| APK file | 30.7 MB |
| Compressed APK analysis total | 29 MB |
| `assets/flutter_assets` | 4 MB |
| `lib/arm64-v8a` | 20 MB |
| Dart AOT symbols accounted decompressed size | 10 MB |

Size analysis file:

```text
/Users/patrikkardenas/.flutter-devtools/apk-code-size-analysis_04.json
```

Latest Android AAB snapshot after asset cleanup:

| Artifact | Value |
| --- | ---: |
| Build command | `flutter build appbundle --release --target-platform android-arm64` |
| AAB file | 29.1 MB |
| `du -sh` display | 28 MB |
| `base/lib/arm64-v8a/libflutter.so` in AAB | 11,037,000 bytes |
| `BUNDLE-METADATA/.../libflutter.so.sym` in AAB | 18,162,288 bytes |

The AAB artifact is created at:

```text
build/app/outputs/bundle/release/app-release.aab
```

Local caveat: Flutter 3.35.3 currently exits after creating the AAB because
this workstation's Android SDK does not have command-line tools / `apkanalyzer`.
`flutter doctor -v` reports the missing `cmdline-tools` component. The AAB
itself contains the expected debug symbols metadata and stripped `libflutter.so`.

Latest iOS release snapshot after asset cleanup:

| Artifact | Value |
| --- | ---: |
| Build command | `flutter build ios --release --no-codesign --analyze-size` |
| `Runner.app` built artifact | 71.1 MB |
| Displayed app analysis total | 68 MB |
| `Runner` executable | 35 MB |
| `Flutter.framework` | 9 MB |
| `App.framework` | 16 MB |
| Dart AOT symbols accounted decompressed size | 11 MB |

iOS size analysis file:

```text
/Users/patrikkardenas/.flutter-devtools/ios-code-size-analysis_01.json
```

Current improvement:

| Metric | Improvement |
| --- | ---: |
| APK file | -109.8 MB |
| Compressed APK analysis total | -105 MB |
| `assets/flutter_assets` | -97 MB |

Top accounted Dart AOT packages in this snapshot:

| Package | Size |
| --- | ---: |
| `package:flutter` | 3 MB |
| `package:image` | 762 KB |
| `package:roast_nutri_tracker` | 707 KB |
| `package:lottie` | 347 KB |

## Current Quality Gates

Run these before comparing optimization results:

```sh
flutter pub get
flutter analyze
flutter test

cd firebase/functions
npm ci
npm audit --audit-level=high
npm run lint
node -e "require('./index.js')"

cd ..
npx --yes firebase-tools@latest emulators:exec \
  --project demo-roast \
  --only firestore \
  "npm --prefix functions run test:rules"
```

## Asset Budget

The CI workflow enforces `assets/fonts <= 10 MB`.

```sh
actual_mb="$(du -sm assets/fonts | cut -f1)"
echo "assets/fonts size: ${actual_mb} MB"
test "${actual_mb}" -le 10
```

## Release Size Commands

Use these for APK/AAB comparison after Android signing/build setup is confirmed:

```sh
flutter build apk --release --analyze-size --target-platform android-arm64
flutter build appbundle --release --analyze-size
```

For this local workstation, install Android SDK command-line tools first so
Flutter can run `apkanalyzer` during AAB post-build validation:

```sh
flutter doctor -v
flutter doctor --android-licenses
```

Record the generated `.json` size snapshots and compare them with:

```sh
flutter pub global run devtools --appSizeBase=<old-size.json> --appSizeTest=<new-size.json>
```

## Runtime Profiling Targets

| Flow | Metric | Target |
| --- | --- | --- |
| Cold start | Time to first usable frame | Establish device baseline, then improve by 20% |
| Home | Firestore reads and frame time | No client-side date filtering in build path |
| DishInfo | Build/raster frame time | Keep p95 below 16 ms on target device |
| Chat | AI request latency and message rebuild cost | Add traces and stabilize message history |
| TTS | Callable latency and failure rate | Add timeout/error observability |
