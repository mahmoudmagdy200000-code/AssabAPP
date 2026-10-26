#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${API_BASE_URL:?Set the verified staging API URL, including /api/v1/}"
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true
# The root asset list expects .env. This entrypoint never loads it.
# Preserve any existing local configuration and never copy secrets into the APK.
if [[ -e .env ]] && [[ -s .env ]] && ! cmp -s .env <(printf '# shift-demo: intentionally empty, non-secret asset\n'); then
  echo 'Use a clean checkout without a private .env before building the demo.' >&2
  exit 1
fi
printf '# shift-demo: intentionally empty, non-secret asset\n' > .env
flutter pub get --enforce-lockfile
flutter analyze lib/main_shift_demo.dart lib/shift_demo test/shift_demo
flutter test test/shift_demo test/core/network/api_base_url_test.dart
flutter build apk --debug --flavor demo --target lib/main_shift_demo.dart \
  --dart-define=DEMO_MODE=true --dart-define="API_BASE_URL=$API_BASE_URL"
