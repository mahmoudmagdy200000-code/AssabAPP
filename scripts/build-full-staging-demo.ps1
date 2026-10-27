$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)

if (-not $env:API_BASE_URL) {
    throw "Set `$env:API_BASE_URL to the verified staging API URL ending in /api/v1/"
}

$env:CI = "true"
$env:FLUTTER_SUPPRESS_ANALYTICS = "true"

if (-not (Test-Path ".env")) {
    Set-Content -Path ".env" -Value "# full-staging-demo: intentionally empty, non-secret asset" -Encoding UTF8
}

flutter pub get --enforce-lockfile
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter analyze --no-fatal-infos --no-fatal-warnings
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build apk --debug --flavor development --target lib/main_development.dart `
    --dart-define="API_BASE_URL=$($env:API_BASE_URL)"
exit $LASTEXITCODE
