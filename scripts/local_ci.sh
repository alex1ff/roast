#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

step() {
  printf '\n==> %s\n' "$1"
}

node22() {
  local major
  major="$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || true)"
  if [ "${major}" = "22" ]; then
    node "$@"
  else
    npx --yes node@22 "$@"
  fi
}

step "Checking font asset budget"
actual_mb="$(du -sm assets/fonts | cut -f1)"
echo "assets/fonts size: ${actual_mb} MB"
test "${actual_mb}" -le 10

step "Secret scan"
if rg -n "sk-[A-Za-z0-9_-]+|ELEVEN_KEY\s*=\s*['\"]|OPENAI_API_KEY\s*=\s*['\"]" \
  firebase/functions firebase/custom_cloud_functions lib pubspec.yaml docs \
  -g '!**/node_modules/**' \
  -g '!**/package-lock.json'; then
  echo "Secret-like value found. Stop."
  exit 1
fi

step "Repository tooling"
npm ci

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
  node22 --test test/functions.logic.test.js
  node22 -e "require('./index.js')"
)

step "Custom Firebase Functions"
(
  cd firebase/custom_cloud_functions
  npm ci
  npm audit --omit=dev --audit-level=high
  npm run lint
  node22 --test test/*.test.js
  node22 -e "require('./index.js')"
)

step "Firestore rules emulator tests"
(
  cd firebase
  ../node_modules/.bin/firebase emulators:exec \
    --project demo-roast \
    --only firestore \
    "npm --prefix functions run test:rules"
)

step "Done"
