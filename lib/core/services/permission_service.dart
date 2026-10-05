import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../utils/app_logger.dart';

/// Result class for permission requests
class PermissionResult {
  final bool granted;
  final String message;
  final PermissionStatus status;
  final bool isPermanentlyDenied;

  const PermissionResult({
    required this.granted,
    required this.message,
    required this.status,
    this.isPermanentlyDenied = false,
  });

  factory PermissionResult.success() => const PermissionResult(
    granted: true,
    message: 'Permission granted',
    status: PermissionStatus.granted,
  );

  factory PermissionResult.denied(PermissionStatus status) => PermissionResult(
    granted: false,
    message: 'Permission denied',
    status: status,
    isPermanentlyDenied: status.isPermanentlyDenied,
  );
}

/// Comprehensive permission service with Android version handling
class PermissionService {
  const PermissionService._();

  /// Get Android SDK version
  static Future<int> getAndroidSdkVersion() async {
    if (!Platform.isAndroid) return 0;
    try {
      final result = await Process.run('getprop', ['ro.build.version.sdk']);
      final sdkString = result.stdout.toString().trim();
      return int.tryParse(sdkString) ?? 29;
    } catch (e) {
      AppLogger.log('Error getting SDK version: $e');
      return 29; // Default to Android 10
    }
  }

  /// Request a single permission
  static Future<bool> requestPermission({
    required Permission permission,
  }) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    final result = await permission.request();

    if (result.isGranted) {
      return true;
    }

    return false;
  }

  /// Request storage permission based on Android version
  static Future<PermissionResult> requestStoragePermission() async {
    if (Platform.isIOS) {
      // iOS uses app sandbox - no explicit permission needed
      return PermissionResult.success();
    }

    if (!Platform.isAndroid) {
      return PermissionResult.success();
    }

    final sdkVersion = await getAndroidSdkVersion();
    AppLogger.log('Android SDK Version: $sdkVersion');

    // Always request notification permission for progress updates
    await _requestNotificationPermission();

    if (sdkVersion >= 33) {
      // Android 13+ (API 33): Granular media permissions
      return _requestAndroid13StoragePermission();
    } else if (sdkVersion >= 30) {
      // Android 11-12 (API 30-32): Scoped storage
      return _requestAndroid11StoragePermission();
    } else if (sdkVersion >= 29) {
      // Android 10 (API 29): Scoped storage with legacy option
      return _requestAndroid10StoragePermission();
    } else {
      // Below Android 10: Legacy storage
      return _requestLegacyStoragePermission();
    }
  }

  /// Request media access permission (for images/PDFs)
  static Future<PermissionResult> requestMediaPermission({
    bool forImages = true,
    bool forVideos = false,
    bool forAudio = false,
  }) async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        return PermissionResult.success();
      }
      return PermissionResult.denied(status);
    }

    if (!Platform.isAndroid) {
      return PermissionResult.success();
    }

    final sdkVersion = await getAndroidSdkVersion();

    if (sdkVersion >= 33) {
      // Android 13+: Request specific media permissions
      final permissions = <Permission>[];
      if (forImages) permissions.add(Permission.photos);
      if (forVideos) permissions.add(Permission.videos);
      if (forAudio) permissions.add(Permission.audio);

      if (permissions.isEmpty) {
        return PermissionResult.success();
      }

      final statuses = await permissions.request();
      final allGranted = statuses.values.every(
        (status) => status.isGranted || status.isLimited,
      );

      if (allGranted) {
        return PermissionResult.success();
      }

      final firstDenied = statuses.entries.firstWhere(
        (e) => !e.value.isGranted && !e.value.isLimited,
        orElse: () => statuses.entries.first,
      );
      return PermissionResult.denied(firstDenied.value);
    } else if (sdkVersion >= 30) {
      // Android 11-12: Try manage external storage first
      return _requestAndroid11StoragePermission();
    } else {
      // Below Android 11: Legacy storage
      return _requestLegacyStoragePermission();
    }
  }

  /// Request camera permission
  static Future<PermissionResult> requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return PermissionResult.success();
    }

    final result = await Permission.camera.request();

    if (result.isGranted) {
      return PermissionResult.success();
    }

    return PermissionResult.denied(result);
  }

  /// Request notification permission
  static Future<bool> _requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final sdkVersion = await getAndroidSdkVersion();
    if (sdkVersion < 33) return true; // Not needed below Android 13

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Android 13+ storage permission
  static Future<PermissionResult> _requestAndroid13StoragePermission() async {
    // On Android 13+, need photos permission for gallery access
    final photosStatus = await Permission.photos.request();

    if (photosStatus.isGranted || photosStatus.isLimited) {
      return PermissionResult.success();
    }

    AppLogger.log('Photos permission not granted: $photosStatus');
    return PermissionResult.denied(photosStatus);
  }

  /// Android 11-12 storage permission
  static Future<PermissionResult> _requestAndroid11StoragePermission() async {
    // First try MANAGE_EXTERNAL_STORAGE for broad access
    var status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      return PermissionResult.success();
    }

    // Request manage external storage
    status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return PermissionResult.success();
    }

    // Fallback: Try regular storage permission
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      return PermissionResult.success();
    }

    // Permission not granted
    return PermissionResult.denied(storageStatus);
  }

  /// Android 10 storage permission
  static Future<PermissionResult> _requestAndroid10StoragePermission() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      return PermissionResult.success();
    }

    // Permission not granted
    return PermissionResult.denied(status);
  }

  /// Legacy storage permission (Android 9 and below)
  static Future<PermissionResult> _requestLegacyStoragePermission() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      return PermissionResult.success();
    }

    return PermissionResult.denied(status);
  }

  /// Get current permission status
  static Future<PermissionStatus> getPermissionStatus({
    required Permission permission,
  }) async {
    return await permission.status;
  }

  /// Check if permission is granted
  static Future<bool> isPermissionGranted({
    required Permission permission,
  }) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Open app settings if permission is permanently denied
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Check if we can access external storage
  static Future<bool> canAccessExternalStorage() async {
    if (!Platform.isAndroid) return true;

    final sdkVersion = await getAndroidSdkVersion();

    if (sdkVersion >= 30) {
      // Android 11+: Check manage external storage
      final status = await Permission.manageExternalStorage.status;
      if (status.isGranted) return true;

      // Downloads folder is accessible without permission
      return true;
    } else {
      // Below Android 11: Check storage permission
      final status = await Permission.storage.status;
      return status.isGranted;
    }
  }
}
