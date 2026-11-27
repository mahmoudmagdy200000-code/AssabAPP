import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppUpdateConfiguration {
  const InAppUpdateConfiguration({
    required this.channel,
    required this.manifestUrl,
    required this.packageName,
    required this.versionCode,
    required this.versionName,
    required this.distributionAllowed,
    required this.playStoreManaged,
  });

  final String channel;
  final String manifestUrl;
  final String packageName;
  final int versionCode;
  final String versionName;
  final bool distributionAllowed;
  final bool playStoreManaged;

  factory InAppUpdateConfiguration.fromMap(Map<Object?, Object?> map) {
    return InAppUpdateConfiguration(
      channel: map['channel'] as String,
      manifestUrl: map['manifestUrl'] as String,
      packageName: map['packageName'] as String,
      versionCode: (map['versionCode'] as num).toInt(),
      versionName: map['versionName'] as String,
      distributionAllowed: map['distributionAllowed'] as bool? ?? true,
      playStoreManaged: map['playStoreManaged'] as bool? ?? false,
    );
  }
}

class InAppUpdateRelease {
  const InAppUpdateRelease({
    required this.channel,
    required this.packageName,
    required this.versionCode,
    required this.versionName,
    required this.apkUrl,
    required this.sizeBytes,
    required this.sha256,
    required this.changelogEn,
    required this.changelogAr,
  });

  final String channel;
  final String packageName;
  final int versionCode;
  final String versionName;
  final Uri apkUrl;
  final int sizeBytes;
  final String sha256;
  final String changelogEn;
  final String changelogAr;

  factory InAppUpdateRelease.fromJson(
    Map<String, dynamic> json,
    InAppUpdateConfiguration config,
  ) {
    if (json['schemaVersion'] != 1 ||
        json['channel'] != config.channel ||
        json['packageName'] != config.packageName) {
      throw const FormatException(
        'Update manifest identity does not match this app.',
      );
    }

    final code = json['versionCode'];
    final versionName = json['versionName'];
    final url = Uri.tryParse(json['apkUrl'] as String? ?? '');
    final size = json['sizeBytes'];
    final checksum = json['sha256'];
    final changelog = json['changelog'];
    if (code is! int || code <= 0) {
      throw const FormatException('Manifest versionCode is invalid.');
    }
    if (versionName is! String || versionName.trim().isEmpty) {
      throw const FormatException('Manifest versionName is invalid.');
    }
    if (url == null ||
        url.scheme != 'https' ||
        url.host.isEmpty ||
        url.userInfo.isNotEmpty) {
      throw const FormatException('APK download must use a valid HTTPS URL.');
    }
    if (size is! int || size <= 0 || size > 1024 * 1024 * 1024) {
      throw const FormatException('Manifest download size is invalid.');
    }
    if (checksum is! String ||
        !RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(checksum)) {
      throw const FormatException('Manifest SHA-256 is invalid.');
    }
    if (changelog is! Map<String, dynamic> ||
        changelog['en'] is! String ||
        changelog['ar'] is! String) {
      throw const FormatException(
        'Manifest changelog must include English and Arabic.',
      );
    }

    return InAppUpdateRelease(
      channel: config.channel,
      packageName: config.packageName,
      versionCode: code,
      versionName: versionName,
      apkUrl: url,
      sizeBytes: size,
      sha256: checksum.toLowerCase(),
      changelogEn: changelog['en'] as String,
      changelogAr: changelog['ar'] as String,
    );
  }
}

class InAppUpdateService {
  InAppUpdateService({Dio? dio, MethodChannel? channel})
    : _dio = dio ?? Dio(_options),
      _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'com.erp.assab/in_app_updates';
  static const _maxManifestBytes = 256 * 1024;
  static const _maxApkBytes = 1024 * 1024 * 1024;
  static final _options = BaseOptions(
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(minutes: 4),
    sendTimeout: const Duration(seconds: 12),
    responseType: ResponseType.json,
  );

  static final InAppUpdateService instance = InAppUpdateService();

  final Dio _dio;
  final MethodChannel _channel;
  CancelToken? _downloadToken;
  final Map<String, String> _verifiedApks = {};
  Future<InAppUpdateRelease?>? _pendingCheck;

  Future<InAppUpdateConfiguration> configuration() async {
    final map = await _channel.invokeMapMethod<Object?, Object?>(
      'getConfiguration',
    );
    if (map == null) {
      throw const FormatException('Update configuration is missing.');
    }
    return InAppUpdateConfiguration.fromMap(map);
  }

  Future<InAppUpdateRelease?> checkForUpdate({
    bool ignoreDeferred = false,
  }) async {
    if (!Platform.isAndroid) return null;
    final pending = _pendingCheck ??= _fetchLatestRelease();
    late final InAppUpdateRelease? release;
    try {
      release = await pending;
    } finally {
      if (identical(_pendingCheck, pending)) _pendingCheck = null;
    }
    if (release == null || ignoreDeferred) return release;
    final prefs = await SharedPreferences.getInstance();
    final deferredCode = prefs.getInt(_deferredKey(release.channel)) ?? 0;
    if (release.versionCode <= deferredCode) return null;
    return release;
  }

  Future<InAppUpdateRelease?> _fetchLatestRelease() async {
    final config = await configuration();
    if (!config.distributionAllowed ||
        config.channel == 'disabled' ||
        config.manifestUrl.isEmpty) {
      return null;
    }
    final manifestUri = Uri.tryParse(config.manifestUrl);
    if (manifestUri == null ||
        manifestUri.scheme != 'https' ||
        manifestUri.host.isEmpty ||
        manifestUri.userInfo.isNotEmpty) {
      throw const FormatException('Update manifest URL must use HTTPS.');
    }

    final manifestToken = CancelToken();
    final response = await _dio.getUri<String>(
      manifestUri,
      cancelToken: manifestToken,
      onReceiveProgress: (received, _) {
        if (received > _maxManifestBytes) {
          manifestToken.cancel('Update manifest exceeds the size limit.');
        }
      },
      options: Options(
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) => status == HttpStatus.ok,
      ),
    );
    final data = response.data;
    if (data == null || data.length > _maxManifestBytes) {
      throw const FormatException('Update manifest is missing or too large.');
    }
    final decoded = jsonDecode(data);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Update manifest is not a JSON object.');
    }
    final release = InAppUpdateRelease.fromJson(decoded, config);
    if (release.versionCode <= config.versionCode) return null;
    if (release.apkUrl.host.toLowerCase() != manifestUri.host.toLowerCase() ||
        release.apkUrl.port != manifestUri.port) {
      throw const FormatException(
        'APK must be hosted on the configured update server.',
      );
    }
    return release;
  }

  Future<void> defer(InAppUpdateRelease release) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_deferredKey(release.channel), release.versionCode);
  }

  void cancelDownload() =>
      _downloadToken?.cancel('User cancelled update download.');

  Future<String> downloadAndVerify(
    InAppUpdateRelease release, {
    required void Function(int received, int total) onProgress,
  }) async {
    if (release.apkUrl.scheme != 'https') {
      throw const FormatException('APK download must use HTTPS.');
    }
    final directory = await getTemporaryDirectory();
    final updateDirectory = Directory('${directory.path}/update-downloads');
    await updateDirectory.create(recursive: true);
    final file = File(
      '${updateDirectory.path}/assab-update-${release.channel}-${release.versionCode}.apk',
    );
    _verifiedApks.remove(file.path);
    if (await file.exists()) await file.delete();

    final token = CancelToken();
    _downloadToken = token;
    try {
      await _dio.download(
        release.apkUrl.toString(),
        file.path,
        cancelToken: token,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          if (received > release.sizeBytes || received > _maxApkBytes) {
            token.cancel('APK download exceeds the manifest size.');
            return;
          }
          onProgress(received, total);
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status == HttpStatus.ok,
        ),
      );
      if (await file.length() != release.sizeBytes) {
        throw const FormatException(
          'Downloaded APK size does not match the manifest.',
        );
      }
      final verification = await _channel.invokeMapMethod<Object?, Object?>(
        'verifyApk',
        {'path': file.path, 'sha256': release.sha256},
      );
      if (verification == null ||
          verification['signingCompatible'] != true ||
          verification['packageName'] != release.packageName ||
          verification['versionCode'] != release.versionCode ||
          verification['versionName'] != release.versionName) {
        throw const FormatException(
          'Downloaded APK identity or signature is incompatible.',
        );
      }
      _verifiedApks[file.path] = release.sha256;
      return file.path;
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    } finally {
      if (identical(_downloadToken, token)) _downloadToken = null;
    }
  }

  Future<void> install(String verifiedApkPath) async {
    final expectedSha256 = _verifiedApks.remove(verifiedApkPath);
    if (expectedSha256 == null) {
      throw const FormatException('Verify the APK before installing it.');
    }
    final started = await _channel.invokeMethod<bool>('installApk', {
      'path': verifiedApkPath,
      'sha256': expectedSha256,
    });
    if (started != true) {
      throw const FormatException('Android installer handoff did not start.');
    }
  }

  String _deferredKey(String channel) => 'assab.update.deferred.$channel';
}
