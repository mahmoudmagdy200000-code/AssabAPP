# DC-01–DC-04 — Flutter local validation and Debug build

Source baseline: `mahmoudmagdy200000-code/AssabAPP` at `660eb9c4bff214259346214aaf708d6da328ebdc`.
Task: `task/dc01-dc04-local-repair-20261030`. The final commit, Git bundle and binary patch are identified in the delivery manifest.

This client requires the matching backend `manager_workday_id` contract. It retains the loaded workday, uses server dates for day selection, clears state during changes and ignores superseded asynchronous results. Both cashier and app editing use `cashier_shift_id`. Gross sales and read-only server variance are preserved. Real corrections require the current revision and a manager-entered reason. Account Statement functionality is unchanged.

## Toolchain

- Flutter **3.35.7**, Dart **3.9.2**, matching `.fvmrc` and the lockfile.
- JDK **17** for the Android Gradle plugin; the project's Java/Kotlin source target remains 11.
- Android SDK platform **36**, Build Tools **35.0.0**, platform-tools and Android command-line tools with licenses accepted.
- NDK **27.0.12077973**, as selected by Flutter 3.35.7.
- Existing Gradle wrapper **8.13**, Android Gradle plugin **8.13.1** and Kotlin plugin **2.1.0**. Do not update these or the lockfile as part of this repair.

The pinned AGP/Gradle/JDK combination is also documented in the [official AGP 8.13 compatibility table](https://developer.android.com/build/releases/agp-8-13-0-release-notes#compatibility). These are toolchain requirements, not an assertion that an APK was built in this phase.

## Recover the exact local commit

Start with a clean clone containing the baseline above. The delivery's bundle has a prerequisite on that base.

```bash
git status --short
git cat-file -t 660eb9c4bff214259346214aaf708d6da328ebdc
git bundle verify /path/to/flutter-local-repair.bundle
git fetch /path/to/flutter-local-repair.bundle refs/heads/task/dc01-dc04-local-repair-20261030:refs/heads/task/dc01-dc04-local-repair-20261030
git switch task/dc01-dc04-local-repair-20261030
git rev-parse HEAD
```

Compare HEAD with the delivery manifest before building. The accompanying patch is an alternative for review/apply; applying it with a different committer can create a different commit SHA. The Git bundle preserves the exact commit.

## Linux/macOS

Put the pinned Flutter SDK on PATH. If using FVM, prefix Flutter commands with `fvm` after installing version 3.35.7.

```bash
set -euo pipefail
export CI=true
export BOT=true
export FLUTTER_SUPPRESS_ANALYTICS=true
# Optional on restricted cloud filesystems: avoids ownership changes while unpacking SDK caches.
export TAR_OPTIONS=--no-same-owner

flutter --version
# pubspec requires this local asset. Create a non-secret empty asset only if absent.
if [ ! -e .env ]; then printf '# local non-secret asset\n' > .env; fi
flutter pub get --enforce-lockfile
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test

# Supply an independently verified HTTPS API base ending in /api/v1/.
# This value is compile-time configuration; building does not authorize runtime financial tests.
export API_BASE_URL='https://VERIFIED-STAGING-HOST/api/v1/'
flutter build apk --debug --flavor development --target lib/main_development.dart \
  --dart-define="API_BASE_URL=$API_BASE_URL"
sha256sum build/app/outputs/flutter-apk/app-development-debug.apk
```

## Windows PowerShell

```powershell
$env:CI = 'true'
$env:BOT = 'true'
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
flutter --version
if (-not (Test-Path .env)) { Set-Content -Path .env -Value '# local non-secret asset' }
flutter pub get --enforce-lockfile
if ($LASTEXITCODE -ne 0) { throw 'Locked dependency restore failed' }
flutter analyze --no-fatal-infos --no-fatal-warnings
if ($LASTEXITCODE -ne 0) { throw 'Static analysis failed' }
flutter test
if ($LASTEXITCODE -ne 0) { throw 'Tests failed' }
$env:API_BASE_URL = 'https://VERIFIED-STAGING-HOST/api/v1/'
flutter build apk --debug --flavor development --target lib/main_development.dart "--dart-define=API_BASE_URL=$env:API_BASE_URL"
if ($LASTEXITCODE -ne 0) { throw 'Debug APK build failed' }
Get-FileHash build/app/outputs/flutter-apk/app-development-debug.apk -Algorithm SHA256
```

Output: **`build/app/outputs/flutter-apk/app-development-debug.apk`**. This is the full application development flavor. The separate `demo` flavor/`main_shift_demo.dart` does not exercise the repaired manager UI.

The previous handoff reported this API base:
`https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/`.
It was not independently reverified in this local-only phase. Do not claim it now runs the repair or assume the deployed SHA matches GitHub. Verify deployment/runtime/DB/timezone before any later environment-specific test, under a separate authorization.

Generated serializers and Retrofit output are included in the local commit. To regenerate only the changed contracts with the locked toolchain:

```bash
flutter pub run build_runner build --delete-conflicting-outputs \
  --build-filter='lib/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.g.dart' \
  --build-filter='lib/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/*.g.dart' \
  --build-filter='lib/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.g.dart'
```

Stop after local build/validation. Installing the APK, logging into staging or submitting financial operations is not part of this phase. Do not commit local assets with credentials, generated dependencies, SDKs or build output.
