#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${API_BASE_URL:?Set the verified staging API URL, including /api/v1/}"
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true
if [[ ! -e .env ]]; then
  printf '# full-staging-demo: intentionally empty, non-secret asset\n' > .env
fi
flutter pub get --enforce-lockfile
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
flutter build apk --debug --flavor development --target lib/main_development.dart \
  --dart-define="API_BASE_URL=$API_BASE_URL"
