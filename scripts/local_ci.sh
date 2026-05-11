#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

step() {
  printf '\n==> %s\n' "$1"
}

step "Checking font asset budget"
actual_mb="$(du -sm assets/fonts | cut -f1)"
echo "assets/fonts size: ${actual_mb} MB"
test "${actual_mb}" -le 10

step "Secret scan"
if rg -n "sk-[A-Za-z0-9_-]+|appl_[A-Za-z0-9]+|ELEVEN_KEY\s*=\s*['\"]|OPENAI_API_KEY\s*=\s*['\"]" \
  firebase/functions firebase/custom_cloud_functions lib pubspec.yaml docs \
  -g '!**/node_modules/**' \
  -g '!**/package-lock.json'; then
  echo "Secret-like value found. Stop."
  exit 1
fi

step "Flutter dependencies"
flutter pub get

step "Flutter analyze"
flutter analyze

step "Flutter tests"
flutter test

step "Main Firebase Functions"
(
  cd firebase/functions
  npm ci
  npm audit --omit=dev --audit-level=high
  npm run lint
  npm run test:functions
  node -e "require('./index.js')"
)

step "Custom Firebase Functions"
(
  cd firebase/custom_cloud_functions
  npm ci
  npm audit --omit=dev --audit-level=high
  npm run lint
  npm run test:functions
  node -e "require('./index.js')"
)

step "Firestore rules emulator tests"
(
  cd firebase
  npx --yes firebase-tools@latest emulators:exec \
    --project demo-roast \
    --only firestore \
    "npm --prefix functions run test:rules"
)

step "Done"
