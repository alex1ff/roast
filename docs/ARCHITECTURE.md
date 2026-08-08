# Architecture

## Overview

Roast is a Flutter client backed by Firebase Authentication, Firestore, Storage, and Cloud Functions. The app collects a photo or text prompt, invokes the analysis boundary, normalizes the result, and stores a user-owned diary entry with nutrition metadata.

## Request flow

```text
photo/text -> request context -> AI/backend adapter -> normalized roast result
                                                       |
                                                       +-> daily diary and totals
                                                       +-> follow-up chat
                                                       +-> optional audio
```

Presentation code can initiate a use case, but durable rules are kept in services or backend functions. This makes generated-style screens replaceable without moving billing, usage, or nutrition logic back into widgets.

## Component boundaries

| Component | Responsibility |
| --- | --- |
| Flutter pages | Input, rendering, navigation, and user feedback |
| `services` | Nutrition calculations, chat state, usage policy, audio, telemetry |
| `backend` | Firebase records, callable functions, HTTP/AI transport, timeouts |
| Cloud Functions | Provider credentials, privileged mutations, sharing, media generation |
| Firebase rules | Ownership and protection of server-managed account fields |

## Security and failure handling

1. User documents and meal history are scoped to the authenticated owner.
2. Subscription dates, plans, and usage balances cannot be changed directly by the client.
3. Provider calls use bounded adapters and return a structured safe error envelope.
4. Production logs avoid raw prompts, credentials, and full provider payloads.
5. Client API configuration uses untracked Dart defines; server secrets stay outside Git.
6. Firestore rule tests cover both allowed and denied mutations in a local emulator.

## FlutterFlow boundary

The codebase retains FlutterFlow naming and widget structure in parts of `lib/`, but export compatibility is no longer a constraint. Active custom functions and custom code are included in `flutter analyze`. New durable logic should continue to enter through services, typed backend adapters, or Cloud Functions rather than adding branches to page widgets.

## Verification strategy

- `flutter analyze` has no source exclusions.
- `flutter test` runs 51 unit, widget, contract, and regression tests.
- Backend checks run ESLint, Cloud Function logic tests, and Firestore rule tests.
- CI pins Flutter 3.35.3 / Dart 3.9.2, Node.js 22, Java 21, Firebase CLI, and npm lockfiles.
