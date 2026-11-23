import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/app_logger.dart';
import 'notification_service.dart';
import 'permission_service.dart';

/// Result class for download operations
class DownloadResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;
  final DownloadErrorType? errorType;

  const DownloadResult._({
    required this.success,
    this.filePath,
    this.errorMessage,
    this.errorType,
  });

  factory DownloadResult.success(String filePath) =>
      DownloadResult._(success: true, filePath: filePath);

  factory DownloadResult.failure(String message, DownloadErrorType type) =>
      DownloadResult._(success: false, errorMessage: message, errorType: type);
}

enum DownloadErrorType {
  permissionDenied,
  networkError,
  storageError,
  invalidUrl,
  cancelled,
  fileCorrupted,
  unknown,
}

/// Maps a file name to its subfolder under /storage/emulated/0/Assab/
enum AssabFolder {
  images,
  videos,
  audio,
  documents,
  archives,
  files; // catch-all

  String get dirName => name; // "images", "videos", …

  static AssabFolder fromFileName(String fileName) {
    final ext = _ext(fileName);
    if (_imageExts.contains(ext)) return AssabFolder.images;
    if (_videoExts.contains(ext)) return AssabFolder.videos;
    if (_audioExts.contains(ext)) return AssabFolder.audio;
    if (_docExts.contains(ext)) return AssabFolder.documents;
    if (_archiveExts.contains(ext)) return AssabFolder.archives;
    return AssabFolder.files;
  }

  static String _ext(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot == -1 || dot == fileName.length - 1) return '';
    return fileName.substring(dot + 1).toLowerCase();
  }

  static const _imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'};
  static const _videoExts = {'mp4', 'mov', 'avi', 'mkv', 'wmv'};
  static const _audioExts = {'mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a'};
  static const _docExts = {
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'csv',
  };
  static const _archiveExts = {'zip', 'rar', '7z', 'tar', 'gz'};
}

@LazySingleton()
class DownloadService {
  final Dio _dio;
  final Map<int, CancelToken> _activeDownloads = {};
  final Map<int, double> _downloadProgress = {};
  final Map<int, int> _lastNotifiedProgress = {};

  /// Primary root – always visible in the Files app
  static const _assabRoot = '/storage/emulated/0/Assab';

  static const _allowedExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'csv',
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
    'mp3',
    'mp4',
    'wav',
    'avi',
    'mov',
    'mkv',
    'aac',
    'ogg',
    'flac',
    'm4a',
  };

  static const _blockedPatterns = ['..', '/', '\\', '\x00'];

  DownloadService(this._dio);

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────────

  Future<DownloadResult> downloadFile({
    required String url,
    required String fileName,
    void Function(int progress)? onProgress,
  }) async {
    final downloadId = fileName.hashCode;

    try {
      // 1. Validate URL
      final urlValidation = _validateUrl(url);
      if (!urlValidation.isValid) {
        await _showErrorNotification(
          downloadId,
          'Invalid URL',
          urlValidation.message,
        );
        return DownloadResult.failure(
          urlValidation.message,
          DownloadErrorType.invalidUrl,
        );
      }

      // 2. Sanitize file name
      final sanitizedFileName = _sanitizeFileName(fileName);
      if (sanitizedFileName == null) {
        await _showErrorNotification(
          downloadId,
          'Invalid File Name',
          'The file name contains invalid characters.',
        );
        return DownloadResult.failure(
          'Invalid file name',
          DownloadErrorType.storageError,
        );
      }

      // 3. Permissions
      final permissionResult = await _requestStoragePermission();
      if (!permissionResult.granted) {
        await _showErrorNotification(
          downloadId,
          'Permission Denied',
          permissionResult.message,
        );
        return DownloadResult.failure(
          permissionResult.message,
          DownloadErrorType.permissionDenied,
        );
      }

      // 4. Resolve save path → /storage/emulated/0/Assab/<type>/<fileName>
      final savePath = await _resolveSavePath(sanitizedFileName);
      if (savePath == null) {
        await _showErrorNotification(
          downloadId,
          'Storage Error',
          'Unable to create the destination folder.',
        );
        return DownloadResult.failure(
          'Unable to create destination folder',
          DownloadErrorType.storageError,
        );
      }

      // 5. Init state & show starting notification
      final cancelToken = CancelToken();
      _activeDownloads[downloadId] = cancelToken;
      _downloadProgress[downloadId] = 0;
      _lastNotifiedProgress[downloadId] = -1;

      await NotificationService.show(
        id: downloadId,
        title: 'Downloading $sanitizedFileName',
        body: 'Starting download…',
        type: NotificationType.progress,
        progress: 0,
      );

      // 6. Download directly to final path – no temp file needed
      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        deleteOnError: true,
        options: Options(
          receiveTimeout: const Duration(minutes: 30),
          sendTimeout: const Duration(minutes: 5),
          headers: {'Accept': '*/*', 'Connection': 'keep-alive'},
        ),
        onReceiveProgress: (received, total) => _handleProgress(
          downloadId,
          sanitizedFileName,
          received,
          total,
          onProgress,
        ),
      );

      // 7. Verify file exists and is non-empty
      final file = File(savePath);
      if (!await file.exists()) {
        await _dismissNotification(downloadId);
        await _showErrorNotification(
          downloadId,
          'Download Failed',
          'File was not saved properly.',
        );
        return DownloadResult.failure(
          'File was not saved properly',
          DownloadErrorType.storageError,
        );
      }
      if (await file.length() == 0) {
        await file.delete();
        await _dismissNotification(downloadId);
        await _showErrorNotification(
          downloadId,
          'Download Failed',
          'Downloaded file is empty or corrupted.',
        );
        return DownloadResult.failure(
          'Downloaded file is corrupted',
          DownloadErrorType.fileCorrupted,
        );
      }

      // 8. Dismiss progress → success notification
      await _dismissNotification(downloadId);
      await NotificationService.show(
        id: downloadId + 1,
        title: 'Download Complete ✓',
        body: '$sanitizedFileName saved to ${_shortPath(savePath)}',
        type: NotificationType.complete,
      );

      AppLogger.log('File saved to $savePath');
      return DownloadResult.success(savePath);
    } on DioException catch (e) {
      await _dismissNotification(downloadId);
      return _handleDioError(e, downloadId, fileName);
    } catch (e, st) {
      AppLogger.log('Download error: $e\n$st');
      await _dismissNotification(downloadId);
      await _showErrorNotification(
        downloadId,
        'Download Failed',
        'An unexpected error occurred.',
      );
      return DownloadResult.failure(e.toString(), DownloadErrorType.unknown);
    } finally {
      _activeDownloads.remove(downloadId);
      _downloadProgress.remove(downloadId);
      _lastNotifiedProgress.remove(downloadId);
    }
  }

  Future<bool> cancelDownload(String fileName) async {
    final downloadId = fileName.hashCode;
    final cancelToken = _activeDownloads[downloadId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Cancelled by user');
      _activeDownloads.remove(downloadId);
      _downloadProgress.remove(downloadId);
      _lastNotifiedProgress.remove(downloadId);
      await _dismissNotification(downloadId);
      await NotificationService.show(
        id: downloadId,
        title: 'Download Cancelled',
        body: '$fileName was cancelled.',
        type: NotificationType.complete,
      );
      return true;
    }
    return false;
  }

  bool isDownloading(String fileName) =>
      _activeDownloads.containsKey(fileName.hashCode);
  double getDownloadProgress(String fileName) =>
      _downloadProgress[fileName.hashCode] ?? 0;

  // ─────────────────────────────────────────────────────────────────────────────
  // PATH RESOLUTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Returns the full path where the file will be saved.
  ///
  /// Priority:
  ///   1. /storage/emulated/0/Assab/<type>/          ← always visible in Files app
  ///   2. <externalStorageDir>/Assab/<type>/          ← app-scoped fallback
  ///   3. <appDocumentsDir>/Assab/<type>/             ← internal last resort
  Future<String?> _resolveSavePath(String fileName) async {
    final subDir = AssabFolder.fromFileName(fileName).dirName;

    // 1. Primary – direct external storage
    try {
      final dir = Directory('$_assabRoot/$subDir');
      if (!await dir.exists()) await dir.create(recursive: true);
      return '${dir.path}/$fileName';
    } catch (e) {
      AppLogger.log('Primary path unavailable: $e');
    }

    // 2. Fallback – app-scoped external storage
    try {
      final ext = await getExternalStorageDirectory();
      if (ext != null) {
        final dir = Directory('${ext.path}/Assab/$subDir');
        if (!await dir.exists()) await dir.create(recursive: true);
        return '${dir.path}/$fileName';
      }
    } catch (e) {
      AppLogger.log('External fallback unavailable: $e');
    }

    // 3. Last resort – internal documents
    try {
      final doc = await getApplicationDocumentsDirectory();
      final dir = Directory('${doc.path}/Assab/$subDir');
      if (!await dir.exists()) await dir.create(recursive: true);
      return '${dir.path}/$fileName';
    } catch (e) {
      AppLogger.log('Internal fallback failed: $e');
      return null;
    }
  }

  /// "Assab/images" from a full path – used in notification body
  String _shortPath(String path) {
    final parts = path.split('/');
    final idx = parts.lastIndexOf('Assab');
    if (idx != -1 && idx + 1 < parts.length) {
      return '${parts[idx]}/${parts[idx + 1]}';
    }
    return 'Assab';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PERMISSIONS
  // ─────────────────────────────────────────────────────────────────────────────

  Future<({bool granted, String message})> _requestStoragePermission() async {
    if (Platform.isIOS) {
      await PermissionService.requestPermission(permission: Permission.photos);
      return (granted: true, message: 'Granted');
    }
    if (Platform.isAndroid) return _requestAndroidPermissions();
    return (granted: true, message: 'Granted');
  }

  Future<({bool granted, String message})> _requestAndroidPermissions() async {
    await PermissionService.requestPermission(
      permission: Permission.notification,
    );

    final sdk = await _getAndroidSdkVersion();

    if (sdk >= 33) {
      // Android 13+: granular media + MANAGE_EXTERNAL_STORAGE for the shared path
      await PermissionService.requestPermission(permission: Permission.photos);
      await PermissionService.requestPermission(permission: Permission.videos);
      await PermissionService.requestPermission(permission: Permission.audio);
      final manage = await Permission.manageExternalStorage.request();
      if (!manage.isGranted) {
        AppLogger.log(
          'MANAGE_EXTERNAL_STORAGE denied – '
          '/storage/emulated/0/Assab may not be writable. '
          'Declare MANAGE_EXTERNAL_STORAGE in AndroidManifest.xml and direct '
          'the user to Settings → Apps → Special access → All files access.',
        );
      }
      return (granted: true, message: 'Granted');
    }

    if (sdk >= 30) {
      // Android 11-12: MANAGE_EXTERNAL_STORAGE required for /storage/emulated/0
      final manage = await Permission.manageExternalStorage.request();
      if (!manage.isGranted) {
        AppLogger.log('MANAGE_EXTERNAL_STORAGE denied on Android 11-12');
      }
      return (granted: true, message: 'Granted');
    }

    // Android ≤ 10: legacy READ/WRITE_EXTERNAL_STORAGE
    final granted = await PermissionService.requestPermission(
      permission: Permission.storage,
    );
    if (!granted) {
      return (
        granted: false,
        message: 'Storage permission is required to download files.',
      );
    }
    return (granted: true, message: 'Granted');
  }

  Future<int> _getAndroidSdkVersion() async {
    try {
      final r = await Process.run('getprop', ['ro.build.version.sdk']);
      return int.tryParse(r.stdout.toString().trim()) ?? 29;
    } catch (_) {
      return 29;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECURITY
  // ─────────────────────────────────────────────────────────────────────────────

  ({bool isValid, String message}) _validateUrl(String url) {
    if (url.isEmpty) return (isValid: false, message: 'URL cannot be empty');
    final uri = Uri.tryParse(url);
    if (uri == null) return (isValid: false, message: 'Invalid URL format');
    if (!kDebugMode && uri.scheme != 'https') {
      return (isValid: false, message: 'Only HTTPS URLs are allowed');
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return (isValid: false, message: 'Invalid URL scheme');
    }
    final host = uri.host.toLowerCase();
    if (!kDebugMode &&
        (host == 'localhost' ||
            host == '127.0.0.1' ||
            host.startsWith('192.168.') ||
            host.startsWith('10.') ||
            host.startsWith('172.'))) {
      return (isValid: false, message: 'Local URLs are not allowed');
    }
    return (isValid: true, message: 'Valid');
  }

  String? _sanitizeFileName(String fileName) {
    if (fileName.isEmpty) return null;
    for (final p in _blockedPatterns) {
      if (fileName.contains(p)) return null;
    }
    var s = fileName.split('/').last.split('\\').last.trim();
    while (s.startsWith('.')) {
      s = s.substring(1);
    }
    if (s.isEmpty) return null;

    final ext = _getFileExtension(s);
    if (ext != null && !_allowedExtensions.contains(ext)) {
      AppLogger.log('Extension not in allow-list: $ext');
    }
    if (s.length > 255) {
      final e = ext ?? '';
      s = e.isNotEmpty
          ? '${s.substring(0, 250 - e.length - 1)}.$e'
          : s.substring(0, 255);
    }
    return s;
  }

  String? _getFileExtension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot == -1 || dot == fileName.length - 1) return null;
    return fileName.substring(dot + 1).toLowerCase();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PROGRESS
  // ─────────────────────────────────────────────────────────────────────────────

  void _handleProgress(
    int id,
    String fileName,
    int received,
    int total,
    void Function(int progress)? onProgress,
  ) {
    if (total <= 0) return;
    final progress = (received / total * 100).clamp(0, 100).toInt();
    _downloadProgress[id] = progress.toDouble();

    final lastNotified = _lastNotifiedProgress[id] ?? -1;
    if (progress - lastNotified >= 5 || progress == 100) {
      _lastNotifiedProgress[id] = progress;
      NotificationService.show(
        id: id,
        title: 'Downloading $fileName',
        body: '$progress% complete',
        type: NotificationType.progress,
        progress: progress,
      );
    }
    onProgress?.call(progress);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NOTIFICATION HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _dismissNotification(int id) async {
    try {
      await NotificationService.cancel(id);
    } catch (e) {
      AppLogger.log('Error dismissing notification $id: $e');
    }
  }

  Future<void> _showErrorNotification(int id, String title, String message) =>
      NotificationService.show(
        id: id,
        title: title,
        body: message,
        type: NotificationType.basic,
      );

  // ─────────────────────────────────────────────────────────────────────────────
  // DIO ERROR HANDLING
  // ─────────────────────────────────────────────────────────────────────────────

  Future<DownloadResult> _handleDioError(
    DioException e,
    int downloadId,
    String fileName,
  ) async {
    if (CancelToken.isCancel(e)) {
      await NotificationService.show(
        id: downloadId,
        title: 'Download Cancelled',
        body: '$fileName was cancelled.',
        type: NotificationType.complete,
      );
      return DownloadResult.failure(
        'Cancelled by user',
        DownloadErrorType.cancelled,
      );
    }

    final String errorMessage;
    final DownloadErrorType errorType;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timed out. Please check your internet.';
        errorType = DownloadErrorType.networkError;
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection. Please try again.';
        errorType = DownloadErrorType.networkError;
        break;
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        errorMessage = switch (code) {
          404 => 'File not found on server.',
          403 => 'Access denied.',
          500 || 502 || 503 => 'Server error. Please try again later.',
          _ => 'Server returned error: $code',
        };
        errorType = DownloadErrorType.networkError;
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Download was cancelled.';
        errorType = DownloadErrorType.cancelled;
        break;
      default:
        errorMessage = e.message ?? 'An unknown network error occurred.';
        errorType = DownloadErrorType.unknown;
    }

    await _showErrorNotification(downloadId, 'Download Failed', errorMessage);
    AppLogger.log('Download error: ${e.type} - ${e.message}');
    return DownloadResult.failure(errorMessage, errorType);
  }
}
