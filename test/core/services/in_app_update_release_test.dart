import 'package:assab/core/services/in_app_update_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const configuration = InAppUpdateConfiguration(
    channel: 'staging',
    manifestUrl: 'https://updates.assab.example/android/staging/manifest.json',
    packageName: 'com.erp.assab.dev.debug',
    versionCode: 35,
    versionName: '1.0.1',
    distributionAllowed: true,
    playStoreManaged: false,
  );

  Map<String, dynamic> releaseManifest({
    String channel = 'staging',
    String packageName = 'com.erp.assab.dev.debug',
    String apkUrl = 'https://updates.assab.example/android/staging/assab.apk',
    String sha256 =
        '0000000000000000000000000000000000000000000000000000000000000000',
  }) => {
    'schemaVersion': 1,
    'channel': channel,
    'packageName': packageName,
    'versionCode': 36,
    'versionName': '1.0.2',
    'apkUrl': apkUrl,
    'sizeBytes': 4096,
    'sha256': sha256,
    'changelog': {'en': 'Security improvements.', 'ar': 'تحسينات أمنية.'},
  };

  test('accepts the authorized staging debug package and newer release', () {
    final release = InAppUpdateRelease.fromJson(
      releaseManifest(),
      configuration,
    );

    expect(release.packageName, 'com.erp.assab.dev.debug');
    expect(release.versionCode, 36);
    expect(release.apkUrl.scheme, 'https');
    expect(release.changelogAr, 'تحسينات أمنية.');
  });

  test('rejects a manifest from a different update channel or package', () {
    expect(
      () => InAppUpdateRelease.fromJson(
        releaseManifest(channel: 'production'),
        configuration,
      ),
      throwsFormatException,
    );
    expect(
      () => InAppUpdateRelease.fromJson(
        releaseManifest(packageName: 'com.erp.assab'),
        configuration,
      ),
      throwsFormatException,
    );
  });

  test('rejects insecure APK URLs and malformed checksums', () {
    expect(
      () => InAppUpdateRelease.fromJson(
        releaseManifest(apkUrl: 'http://updates.assab.example/app.apk'),
        configuration,
      ),
      throwsFormatException,
    );
    expect(
      () => InAppUpdateRelease.fromJson(
        releaseManifest(sha256: 'not-a-digest'),
        configuration,
      ),
      throwsFormatException,
    );
  });
}
