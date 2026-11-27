# Android in-app updates v1

The updater is APK-only and stages the verified bytes in an Android `PackageInstaller` session, which always asks the user to confirm installation. A successful Android package update preserves app data because the package ID remains the same and Android accepts the update only when its signer is compatible with the installed app. The app checks the install source at runtime and disables this updater for Google Play installs. The release preparation script refuses Play Store distribution targets.

## Channels and endpoint configuration

The `development` flavor is the **Staging** channel and has package ID `com.erp.assab.dev`; its authorized debug package is `com.erp.assab.dev.debug`. The `production` flavor is **Production** with package ID `com.erp.assab`. The distinct package IDs and separate Gradle properties prevent a Staging manifest or APK from updating a Production installation. Production debug APKs are not accepted by the release script.

Configure the static manifest endpoints in the build environment. Do not commit private signing credentials or APKs.

```powershell
$env:ASSAB_PRODUCTION_UPDATE_MANIFEST_URL = 'https://updates.example.com/android/production/manifest.json'
flutter build apk --release --flavor production -t lib/main_production.dart

$env:ASSAB_STAGING_UPDATE_MANIFEST_URL = 'https://updates.example.com/android/staging/manifest.json'
flutter build apk --release --flavor development -t lib/main_development.dart
```

Use the same configured URL on every release for that channel. A blank, malformed, non-HTTPS, unavailable, or invalid manifest safely disables the update check for that run. Host each APK and its manifest on HTTPS. The manifest endpoint must return HTTP 200 without redirects and JSON with this shape:

```json
{
  "schemaVersion": 1,
  "channel": "production",
  "packageName": "com.erp.assab",
  "versionCode": 35,
  "versionName": "1.0.1",
  "apkUrl": "https://updates.example.com/android/production/assab-production-35.apk",
  "sizeBytes": 123456789,
  "sha256": "0000000000000000000000000000000000000000000000000000000000000000",
  "changelog": {
    "en": "Fixes and improvements.",
    "ar": "إصلاحات وتحسينات."
  }
}
```

The all-zero digest above is only a format example. The release script generates the real digest; never publish this placeholder.

For Staging, set `channel` to `staging` and use the package ID embedded in the APK: `com.erp.assab.dev` for release or `com.erp.assab.dev.debug` for the authorized debug package. The app rejects another channel, package ID, non-increasing `versionCode`, non-HTTPS URL, invalid checksum, malformed bilingual changelog, incorrect file length, checksum mismatch, or APK whose signer is incompatible with the installed application. Downloads are kept in app cache and removed when cancelled or invalid. A localized App Version card with the same update check is shown at the bottom of each user role's Settings screen.

## Preparing a release

Build the intended release flavor with its existing `android/key.properties` and signing key, and increment `pubspec.yaml` versionCode. Then prepare artifacts, for example:

```powershell
.\scripts\prepare-android-update.ps1 `
  -Channel production `
  -DistributionTarget self-hosted-apk `
  -ApkPath .\build\app\outputs\flutter-apk\app-production-release.apk `
  -BaseApkUrl https://updates.example.com/android/production `
  -VersionCode 35 -VersionName 1.0.1 `
  -ChangelogEn 'Fixes and improvements.' `
  -ChangelogAr 'إصلاحات وتحسينات.'
```

For a Staging release APK, set `-Channel staging`, `-DistributionTarget self-hosted-apk`, and use `app-development-release.apk`. The script also accepts the authorized `app-development-debug.apk` package (`com.erp.assab.dev.debug`) for Staging only. It verifies package ID and version against the APK, verifies APK signing, prints the signer fingerprint, computes the SHA-256 and byte size, and writes `update-release/<channel>/manifest.json` beside the APK. The `play-store` target is rejected; Play builds remain Play-managed. Compare the reported signer fingerprint with the fingerprint used by the currently distributed APK before upload. Upload both files to their channel's HTTPS host only after review; this script does not publish anything.

The release signing keystore and `android/key.properties` are intentionally not stored in this source tree. Android will preserve data and accept an in-place update only when the incoming APK has a compatible signing identity. The verifier uses `GET_SIGNATURES` before API 28 and `GET_SIGNING_CERTIFICATES` on API 28+, including API 33's `PackageInfoFlags` overload. It accepts an exact signer-set match or a cryptographically declared single-signer rotation lineage and fails closed otherwise. The PackageInstaller session receives the APK bytes while rechecking their expected SHA-256, so it installs exactly the bytes verified by the app.

To build the authorized Staging debug package for a device already on versionCode 35, use a higher build number:

```powershell
flutter build apk --debug --flavor development -t lib/main_development.dart --build-number 36
```

## Device verification checklist

1. Reuse the accepted SM-A528B evidence showing the Staging app at versionCode 35 with its existing data/session.
2. Install only an authorized Staging APK at versionCode 36, accept Android's installer confirmation, and confirm app data/session remains available.
3. Exercise Later, cancel/retry, offline, malformed manifest, wrong checksum, wrong package, incompatible signer, and Play Store source gate paths.
4. Verify Production and Staging manifest URLs/package IDs remain isolated.

## Permanent Staging hosting & future APK publication procedure

The permanent Coolify Staging HTTPS host (`assab-staging-apk-updates`, `nginx:alpine`, persistent volume mounted at `/usr/share/nginx/html`) serves Staging updates at:

- **Manifest URL:** `https://updates-staging.62.72.19.141.sslip.io/android/staging/manifest.json`
- **Base APK URL:** `https://updates-staging.62.72.19.141.sslip.io/android/staging`

To publish a future Staging build (e.g. build `<N>`):

1. Build the APK with the permanent Staging manifest URL and Staging API base URL:
   ```powershell
   $env:ASSAB_STAGING_UPDATE_MANIFEST_URL = 'https://updates-staging.62.72.19.141.sslip.io/android/staging/manifest.json'
   flutter build apk --debug --flavor development -t lib/main_development.dart --build-number <N> --android-skip-build-dependency-validation --dart-define=API_BASE_URL=https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/
   ```
   (For release Staging APKs, use `--release` with `android/key.properties` and `app-development-release.apk`.)
2. Generate `manifest.json` and verify the signing certificate fingerprint matches the currently installed build:
   ```powershell
   .\scripts\prepare-android-update.ps1 `
     -Channel staging `
     -DistributionTarget self-hosted-apk `
     -ApkPath .\build\app\outputs\flutter-apk\app-development-debug.apk `
     -BaseApkUrl https://updates-staging.62.72.19.141.sslip.io/android/staging `
     -VersionCode <N> -VersionName 1.0.0 `
     -ChangelogEn '...' -ChangelogAr '...'
   ```
3. Upload `assab-staging-<N>.apk` to `/usr/share/nginx/html/android/staging/.assab-staging-<N>.apk.tmp` first, verify its `sha256sum` and byte count (`wc -c`), and `mv` it into `/usr/share/nginx/html/android/staging/assab-staging-<N>.apk`.
4. Upload `manifest.json` to `.manifest.json.tmp` and atomically `mv` it to `/usr/share/nginx/html/android/staging/manifest.json` only after the APK is verified in place.
5. Verify both `https://updates-staging.62.72.19.141.sslip.io/android/staging/manifest.json` and `assab-staging-<N>.apk` return `HTTP/1.1 200 OK` without redirects.

Verified on `SM-A528B` (`RZCRC0669EZ`): Staging `com.erp.assab.dev.debug` updated in-app from `Build 37` to `Build 38` via Android `PackageInstaller` (`installerPackageName=com.erp.assab.dev.debug`) with Branch Manager session and application data preserved.
