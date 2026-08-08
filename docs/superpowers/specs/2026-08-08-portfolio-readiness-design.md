# Roast portfolio-readiness design

## Goal

Present Roast as a maintained Flutter product with reproducible quality checks, not as an uncurated FlutterFlow export.

## Source of truth

FlutterFlow exports are retired. The local repository and `origin/flutterflow` currently point to the same product commit. GitHub becomes the authoritative source.

## Scope

- Create `main` from the validated local state and make it the GitHub default branch; retain `flutterflow` temporarily as history.
- Replace the template README and generic package description with product scope, architecture, maintained-code boundaries, setup, and verification commands.
- Add CI for `flutter analyze` and `flutter test`, pinned to Flutter 3.35.3 / Dart 3.9.2.
- Ignore generated output and local inspection artifacts; include only intentional documentation assets.
- Improve public repository description and topics.

## Non-goals

- No feature redesign or visual rewrite.
- No broad refactor of generated screen widgets.
- No change to Firebase, RevenueCat, AI, nutrition, or subscription behavior.

## Validation

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- Preserve test discovery: the full suite must report at least the current baseline of 51 passing tests.
- CI passes from a clean checkout on `main`.

## Publishing

Push the prepared `main` and wait for its CI to pass. Only then switch the GitHub default branch to `main`; keep `flutterflow` until the user confirms it can be removed.
