#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
FIREBASE_BIN="${REPO_ROOT}/node_modules/.bin/firebase"

cd "${REPO_ROOT}"

if [[ ! -x "${FIREBASE_BIN}" ]]; then
  echo "Missing local Firebase CLI. Run 'npm ci' in ${REPO_ROOT}." >&2
  exit 1
fi

npm --prefix firebase/functions run lint
npm --prefix firebase/functions run test:functions
npm --prefix firebase/custom_cloud_functions run lint
npm --prefix firebase/custom_cloud_functions run test:functions

"${FIREBASE_BIN}" emulators:exec \
  --project demo-roast \
  --config firebase/firebase.json \
  --only firestore \
  "npm --prefix firebase/functions run test:rules"
