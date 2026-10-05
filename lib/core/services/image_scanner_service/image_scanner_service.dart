import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/app_logger.dart';
import '../permission_service.dart';

/// High-performance image scanner service with isolate support
class ImageScannerService {
  const ImageScannerService._();

  // Supported image extensions
  static const Set<String> _imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
    '.heic',
    '.heif',
  };

  // Directories to exclude from scanning
  static const Set<String> _excludedDirs = {
    'android',
    'system',
    'data',
    'obb',
    'cache',
    '.thumbnails',
    '.trash',
    'lost+found',
    'thumbnails',
    'gradle',
    'build',
    '.git',
    'node_modules',
  };

  /// Priority directories to scan first for faster initial results
  static const List<String> _priorityDirs = [
    'DCIM',
    'Pictures',
    'Download',
    'Downloads',
    'Camera',
    'Screenshots',
    'WhatsApp/Media/WhatsApp Images',
    'Telegram/Telegram Images',
  ];

  /// Get all images with optimized parallel scanning
  static Future<List<File>> getAllImages({
    void Function(int count)? onProgress,
    int? limit,
  }) async {
    // Request permission first
    final permissionResult = await PermissionService.requestMediaPermission(
      forImages: true,
    );

    if (!permissionResult.granted) {
      AppLogger.log('Image permission not granted');
      // Try anyway - might work with scoped storage
    }

    if (Platform.isAndroid) {
      return _getAllImagesAndroid(onProgress: onProgress, limit: limit);
    } else if (Platform.isIOS) {
      return _getAllImagesIOS(onProgress: onProgress);
    } else {
      return [];
    }
  }

  /// Stream images as they are found (for faster UI updates)
  static Stream<File> streamImages() async* {
    final permissionResult = await PermissionService.requestMediaPermission(
      forImages: true,
    );

    if (!permissionResult.granted) {
      AppLogger.log('Image permission not granted for streaming');
    }

    if (Platform.isAndroid) {
      yield* _streamImagesAndroid();
    } else if (Platform.isIOS) {
      yield* _streamImagesIOS();
    }
  }

  /// Android image scanning with isolate for performance
  static Future<List<File>> _getAllImagesAndroid({
    void Function(int count)? onProgress,
    int? limit,
  }) async {
    try {
      // Use compute for isolate-based scanning
      final result = await compute(
        _scanAndroidInIsolate,
        _IsolateScanParams(
          rootPath: '/storage/emulated/0',
          extensions: _imageExtensions,
          excludedDirs: _excludedDirs,
          priorityDirs: _priorityDirs,
          limit: limit,
        ),
      );

      // Sort by modification time (newest first)
      result.sort((a, b) {
        try {
          final aTime = a.lastModifiedSync();
          final bTime = b.lastModifiedSync();
          return bTime.compareTo(aTime);
        } catch (_) {
          return 0;
        }
      });

      return result;
    } catch (e) {
      AppLogger.log('Error scanning images: $e');
      return [];
    }
  }

  /// Stream images from Android storage
  static Stream<File> _streamImagesAndroid() async* {
    final root = Directory('/storage/emulated/0');

    if (!root.existsSync()) {
      return;
    }

    // First yield from priority directories
    for (final priorityDir in _priorityDirs) {
      final dir = Directory('${root.path}/$priorityDir');
      if (dir.existsSync()) {
        await for (final file in _streamFromDirectory(dir)) {
          yield file;
        }
      }
    }

    // Then yield from remaining directories
    await for (final file in _streamFromDirectory(root, skipPriority: true)) {
      yield file;
    }
  }

  /// Stream images from a directory
  static Stream<File> _streamFromDirectory(
    Directory dir, {
    bool skipPriority = false,
  }) async* {
    try {
      await for (final entity in dir.list(followLinks: false)) {
        if (entity is File && _isImage(entity.path)) {
          yield entity;
        } else if (entity is Directory) {
          final name = entity.path.split('/').last.toLowerCase();

          // Skip excluded directories
          if (_excludedDirs.contains(name) || name.startsWith('.')) {
            continue;
          }

          // Skip priority dirs if we already scanned them
          if (skipPriority) {
            final relativePath = entity.path.replaceFirst(
              '/storage/emulated/0/',
              '',
            );
            final isPriority = _priorityDirs.any(
              (p) => relativePath.startsWith(p),
            );
            if (isPriority) continue;
          }

          yield* _streamFromDirectory(entity);
        }
      }
    } catch (e) {
      // Skip directories we can't access
    }
  }

  /// iOS image scanning
  static Future<List<File>> _getAllImagesIOS({
    void Function(int count)? onProgress,
  }) async {
    final List<File> imageFiles = [];
    try {
      final dir = await getApplicationDocumentsDirectory();
      await _scanDirectoryAsync(dir, imageFiles, onProgress);

      // Sort by modification time
      imageFiles.sort((a, b) {
        try {
          return b.lastModifiedSync().compareTo(a.lastModifiedSync());
        } catch (_) {
          return 0;
        }
      });

      return imageFiles;
    } catch (e) {
      AppLogger.log('Error scanning iOS images: $e');
      return [];
    }
  }

  /// Stream images from iOS
  static Stream<File> _streamImagesIOS() async* {
    try {
      final dir = await getApplicationDocumentsDirectory();
      yield* _streamFromDirectory(dir);
    } catch (e) {
      AppLogger.log('Error streaming iOS images: $e');
    }
  }

  /// Scan directory asynchronously
  static Future<void> _scanDirectoryAsync(
    Directory dir,
    List<File> result,
    void Function(int count)? onProgress,
  ) async {
    try {
      await for (final entity in dir.list(followLinks: false)) {
        if (entity is File && _isImage(entity.path)) {
          result.add(entity);
          onProgress?.call(result.length);
        } else if (entity is Directory) {
          final name = entity.path.split('/').last.toLowerCase();
          if (!_excludedDirs.contains(name) && !name.startsWith('.')) {
            await _scanDirectoryAsync(entity, result, onProgress);
          }
        }
      }
    } catch (_) {
      // Skip directories we can't access
    }
  }

  /// Check if file is an image
  static bool _isImage(String path) {
    final lower = path.toLowerCase();
    return _imageExtensions.any((ext) => lower.endsWith(ext));
  }
}

/// Parameters for isolate scanning
class _IsolateScanParams {
  final String rootPath;
  final Set<String> extensions;
  final Set<String> excludedDirs;
  final List<String> priorityDirs;
  final int? limit;

  const _IsolateScanParams({
    required this.rootPath,
    required this.extensions,
    required this.excludedDirs,
    required this.priorityDirs,
    this.limit,
  });
}

/// Isolate entry point for scanning
List<File> _scanAndroidInIsolate(_IsolateScanParams params) {
  final List<File> files = [];
  final root = Directory(params.rootPath);

  if (!root.existsSync()) {
    return files;
  }

  // Scan priority directories first
  for (final priorityDir in params.priorityDirs) {
    final dir = Directory('${params.rootPath}/$priorityDir');
    if (dir.existsSync()) {
      _scanDirSync(dir, files, params);
      if (params.limit != null && files.length >= params.limit!) {
        return files.take(params.limit!).toList();
      }
    }
  }

  // Then scan remaining directories
  _scanDirSync(root, files, params, skipPriority: true);

  if (params.limit != null && files.length > params.limit!) {
    return files.take(params.limit!).toList();
  }

  return files;
}

/// Synchronous directory scan for isolate
void _scanDirSync(
  Directory dir,
  List<File> result,
  _IsolateScanParams params, {
  bool skipPriority = false,
}) {
  try {
    final entities = dir.listSync(followLinks: false);
    for (final entity in entities) {
      if (entity is File) {
        final lower = entity.path.toLowerCase();
        if (params.extensions.any((ext) => lower.endsWith(ext))) {
          result.add(entity);
        }
      } else if (entity is Directory) {
        final name = entity.path.split('/').last.toLowerCase();

        // Skip excluded directories
        if (params.excludedDirs.contains(name) || name.startsWith('.')) {
          continue;
        }

        // Skip priority dirs if we already scanned them
        if (skipPriority) {
          final relativePath = entity.path.replaceFirst(
            '${params.rootPath}/',
            '',
          );
          final isPriority = params.priorityDirs.any(
            (p) => relativePath.startsWith(p),
          );
          if (isPriority) continue;
        }

        _scanDirSync(entity, result, params);
      }
    }
  } catch (_) {
    // Skip directories we can't access
  }
}
