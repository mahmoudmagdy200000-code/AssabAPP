import 'dart:async';
import 'dart:io';

import 'package:assab/core/services/image_picker/image_picker_service.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/image_scanner_service/image_scanner_service.dart';
import '../../../../core/services/pdf_scanner_service/pdf_scanner_service.dart';
import '../../enums/media_file_type.dart';
import '../../helpers/safe_cubit.dart';
import '../../models/media_file_model.dart';
import '../../services/permission_service.dart';
import '../../utils/app_logger.dart';
import 'media_state.dart';

/// Optimized MediaCubit with streaming, pagination, and smooth UI updates
@injectable
class MediaCubit extends SafeCubit<MediaState> {
  final ImagePickerService _imagePickerService;

  MediaCubit(this._imagePickerService) : super(const MediaInitial());

  bool singleSelectionMode = false;

  // Main file lists (confirmed selection)
  final List<MediaFile> _pdfFiles = [];
  final List<MediaFile> _imageFiles = [];

  // Temporary lists (working selection)
  final List<MediaFile> _tempPdfFiles = [];
  final List<MediaFile> _tempImageFiles = [];

  // Camera image tracking
  final Set<String> _cameraImagePaths = {};
  final Set<String> _tempCameraImagePaths = {};

  // Loading state flags
  bool _areImagesLoaded = false;
  bool _arePdfsLoaded = false;
  bool _isLoadingImages = false;
  bool _isLoadingPdfs = false;

  // Stream subscriptions for cancellation
  StreamSubscription<File>? _imageStreamSub;
  StreamSubscription<File>? _pdfStreamSub;

  // Batch update control - prevents excessive UI rebuilds
  static const int _batchSize = 50;
  Timer? _batchUpdateTimer;
  bool _pendingUpdate = false;

  // Throttle duration for UI updates (in milliseconds)
  static const int _throttleDuration = 100;

  /// Request storage permission with Android version awareness
  Future<bool> _ensureStoragePermission() async {
    if (Platform.isIOS) return true;

    try {
      final result = await PermissionService.requestStoragePermission();

      if (result.granted) {
        return true;
      }

      // Permission not granted - emit denied state and stop
      emit(const MediaPermissionDenied());
      return false;
    } catch (e) {
      AppLogger.log('Permission error: $e');
      emit(const MediaPermissionDenied());
      return false;
    }
  }

  /// Request media permission with Android version awareness
  Future<bool> _ensureMediaPermission({bool forImages = true}) async {
    if (Platform.isIOS) return true;

    try {
      final result = await PermissionService.requestMediaPermission(
        forImages: forImages,
      );

      if (result.granted) {
        return true;
      }

      // Permission not granted - emit denied state and stop
      emit(const MediaPermissionDenied());
      return false;
    } catch (e) {
      AppLogger.log('Media permission error: $e');
      emit(const MediaPermissionDenied());
      return false;
    }
  }

  /// Open app settings for user to grant permission manually
  Future<void> openPermissionSettings() async {
    await PermissionService.openSettings();
  }

  /// Capture image from camera
  void captureImage() async {
    final cameraPermission = await PermissionService.requestCameraPermission();
    if (!cameraPermission.granted) {
      if (cameraPermission.isPermanentlyDenied) {
        await PermissionService.openSettings();
      }
      return;
    }

    final picked = await _imagePickerService.pickImageFromCamera();
    if (picked == null) return;

    final fileName = picked.path.split(Platform.pathSeparator).last;
    final extension = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : '';

    final mediaFile = MediaFile(
      path: picked.path,
      name: fileName,
      type: MediaFileType.image,
      selected: true,
      size: File(picked.path).lengthSync(),
      fileExtension: extension,
    );

    _imageFiles.add(mediaFile);
    _tempImageFiles.insert(0, mediaFile); // Add to beginning
    _cameraImagePaths.add(picked.path);
    _tempCameraImagePaths.add(picked.path);

    _emitLoadedState();
  }

  /// Load all media with streaming for smooth UI
  /// Only loads if not already loaded (cached)
  void loadAllMedia({bool forceReload = false}) async {
    if (isClosed) return;

    // Always force reload if coming from permission denied state
    final wasPermissionDenied = state is MediaPermissionDenied;
    if (wasPermissionDenied) {
      forceReload = true;
    }

    // Check if we actually have cached data (not just flags)
    final hasCachedData =
        _tempImageFiles.isNotEmpty || _tempPdfFiles.isNotEmpty;

    // Skip if already loaded WITH data and not forcing reload
    if (!forceReload && _areImagesLoaded && _arePdfsLoaded && hasCachedData) {
      // Just emit current state to refresh UI
      _emitLoadedState();
      return;
    }

    // If flags say loaded but no data, reset flags
    if (_areImagesLoaded && _tempImageFiles.isEmpty) {
      _areImagesLoaded = false;
    }
    if (_arePdfsLoaded && _tempPdfFiles.isEmpty) {
      _arePdfsLoaded = false;
    }

    // If currently loading, don't restart
    if (_isLoadingImages || _isLoadingPdfs) {
      return;
    }

    // Reset loaded flags if forcing reload
    if (forceReload) {
      _areImagesLoaded = false;
      _arePdfsLoaded = false;
    }

    final granted = await _ensureStoragePermission();
    if (!granted) {
      // Permission was denied - don't proceed
      return;
    }

    // Cancel any existing streams
    await _cancelStreams();

    // Show initial loading state
    emit(const MediaLoading(isInitialLoad: true));

    // Start loading images and PDFs with streaming
    _loadImagesWithStreaming();
    _loadPdfsWithStreaming();
  }

  /// Force reload all media (clears cache)
  void reloadAllMedia() {
    _tempImageFiles.clear();
    _tempPdfFiles.clear();
    _areImagesLoaded = false;
    _arePdfsLoaded = false;
    loadAllMedia(forceReload: true);
  }

  /// Load images using streaming for incremental UI updates
  void _loadImagesWithStreaming() async {
    if (_isLoadingImages || _areImagesLoaded) return;
    _isLoadingImages = true;

    try {
      // Request permission
      await _ensureMediaPermission(forImages: true);

      // Preserve camera images
      final existingCameraImages = _tempImageFiles
          .where((f) => _cameraImagePaths.contains(f.path))
          .toList();

      _tempImageFiles.clear();
      _tempImageFiles.addAll(existingCameraImages);

      int batchCount = 0;
      final List<File> batchFiles = [];

      // Use streaming to load images incrementally
      _imageStreamSub = ImageScannerService.streamImages().listen(
        (file) {
          if (isClosed) return;

          batchFiles.add(file);
          batchCount++;

          // Process in batches to avoid UI jank
          if (batchCount >= _batchSize) {
            _processBatchFiles(batchFiles, isImage: true);
            batchFiles.clear();
            batchCount = 0;
          }
        },
        onDone: () {
          if (isClosed) return;

          // Process remaining files
          if (batchFiles.isNotEmpty) {
            _processBatchFiles(batchFiles, isImage: true);
          }

          _areImagesLoaded = true;
          _isLoadingImages = false;
          _scheduleUpdate();
        },
        onError: (error) {
          AppLogger.log('Image streaming error: $error');
          _isLoadingImages = false;
          _scheduleUpdate();
        },
        cancelOnError: false,
      );
    } catch (e) {
      AppLogger.log('Error loading images: $e');
      _isLoadingImages = false;
      _scheduleUpdate();
    }
  }

  /// Load PDFs using streaming
  void _loadPdfsWithStreaming() async {
    if (_isLoadingPdfs || _arePdfsLoaded) return;
    _isLoadingPdfs = true;

    try {
      await _ensureStoragePermission();

      _tempPdfFiles.clear();

      int batchCount = 0;
      final List<File> batchFiles = [];

      _pdfStreamSub = PdfScannerService.streamPDFs().listen(
        (file) {
          if (isClosed) return;

          batchFiles.add(file);
          batchCount++;

          if (batchCount >= _batchSize) {
            _processBatchFiles(batchFiles, isImage: false);
            batchFiles.clear();
            batchCount = 0;
          }
        },
        onDone: () {
          if (isClosed) return;

          if (batchFiles.isNotEmpty) {
            _processBatchFiles(batchFiles, isImage: false);
          }

          _arePdfsLoaded = true;
          _isLoadingPdfs = false;
          _scheduleUpdate();
        },
        onError: (error) {
          AppLogger.log('PDF streaming error: $error');
          _isLoadingPdfs = false;
          _scheduleUpdate();
        },
        cancelOnError: false,
      );
    } catch (e) {
      AppLogger.log('Error loading PDFs: $e');
      _isLoadingPdfs = false;
      _scheduleUpdate();
    }
  }

  /// Process a batch of files and convert to MediaFile
  void _processBatchFiles(List<File> files, {required bool isImage}) {
    if (files.isEmpty || isClosed) return;

    // Convert files to MediaFile objects
    final mediaFiles = files
        .map((file) {
          try {
            return MediaFile.fromFile(file);
          } catch (e) {
            return null;
          }
        })
        .whereType<MediaFile>()
        .toList();

    if (isImage) {
      // Filter out duplicates
      final existingPaths = _tempImageFiles.map((f) => f.path).toSet();
      final newFiles = mediaFiles
          .where((f) => !existingPaths.contains(f.path))
          .toList();
      _tempImageFiles.addAll(newFiles);
    } else {
      final existingPaths = _tempPdfFiles.map((f) => f.path).toSet();
      final newFiles = mediaFiles
          .where((f) => !existingPaths.contains(f.path))
          .toList();
      _tempPdfFiles.addAll(newFiles);
    }

    _scheduleUpdate();
  }

  /// Schedule a throttled UI update to prevent excessive rebuilds
  void _scheduleUpdate() {
    if (_pendingUpdate || isClosed) return;
    _pendingUpdate = true;

    _batchUpdateTimer?.cancel();
    _batchUpdateTimer = Timer(
      const Duration(milliseconds: _throttleDuration),
      () {
        if (!isClosed) {
          _emitLoadedState();
          _pendingUpdate = false;
        }
      },
    );
  }

  /// Cancel active streams
  Future<void> _cancelStreams() async {
    await _imageStreamSub?.cancel();
    await _pdfStreamSub?.cancel();
    _imageStreamSub = null;
    _pdfStreamSub = null;
  }

  /// Load PDFs only
  Future<void> loadPDFsOnly() async {
    final granted = await _ensureStoragePermission();
    if (!granted) return;
    _loadPdfsWithStreaming();
  }

  /// Load images only
  Future<void> loadImagesOnly() async {
    final granted = await _ensureMediaPermission(forImages: true);
    if (!granted) return;
    _loadImagesWithStreaming();
  }

  void _toggleFileInList(List<MediaFile> list, MediaFile file) {
    final index = list.indexWhere((f) => f.path == file.path);
    if (index != -1) {
      list[index] = list[index].copyWith(selected: !list[index].selected);
    }
  }

  void toggleSelection(MediaFile file) {
    if (singleSelectionMode) {
      _clearAllSelections();
    }

    if (file.type == MediaFileType.pdf) {
      _toggleFileInList(_tempPdfFiles, file);
    } else {
      _toggleFileInList(_tempImageFiles, file);
    }

    _emitLoadedState();
  }

  void _clearAllSelections() {
    for (var i = 0; i < _tempPdfFiles.length; i++) {
      _tempPdfFiles[i] = _tempPdfFiles[i].copyWith(selected: false);
    }
    for (var i = 0; i < _tempImageFiles.length; i++) {
      _tempImageFiles[i] = _tempImageFiles[i].copyWith(selected: false);
    }
  }

  void confirmSelection() {
    _pdfFiles
      ..clear()
      ..addAll(List.from(_tempPdfFiles));

    _imageFiles
      ..clear()
      ..addAll(List.from(_tempImageFiles));

    _cameraImagePaths
      ..clear()
      ..addAll(_tempCameraImagePaths);

    _emitLoadedState();
  }

  void discardTempSelection() {
    // Only reset selections if main lists have confirmed data
    // Otherwise, keep the loaded temp files but just deselect non-camera items
    if (_pdfFiles.isNotEmpty || _imageFiles.isNotEmpty) {
      _tempPdfFiles
        ..clear()
        ..addAll(List.from(_pdfFiles));

      _tempImageFiles
        ..clear()
        ..addAll(List.from(_imageFiles));

      _tempCameraImagePaths
        ..clear()
        ..addAll(_cameraImagePaths);
    } else {
      // Just deselect all items but keep the loaded files
      for (var i = 0; i < _tempPdfFiles.length; i++) {
        _tempPdfFiles[i] = _tempPdfFiles[i].copyWith(selected: false);
      }
      for (var i = 0; i < _tempImageFiles.length; i++) {
        // Keep camera images selected
        if (!_tempCameraImagePaths.contains(_tempImageFiles[i].path)) {
          _tempImageFiles[i] = _tempImageFiles[i].copyWith(selected: false);
        }
      }
    }

    _emitLoadedState();
  }

  void clearSelection() {
    for (var i = 0; i < _pdfFiles.length; i++) {
      _pdfFiles[i] = _pdfFiles[i].copyWith(selected: false);
    }
    for (var i = 0; i < _imageFiles.length; i++) {
      _imageFiles[i] = _imageFiles[i].copyWith(selected: false);
    }
    for (var i = 0; i < _tempPdfFiles.length; i++) {
      _tempPdfFiles[i] = _tempPdfFiles[i].copyWith(selected: false);
    }
    for (var i = 0; i < _tempImageFiles.length; i++) {
      _tempImageFiles[i] = _tempImageFiles[i].copyWith(selected: false);
    }

    _emitLoadedState();
  }

  /// Refresh media files
  Future<void> refreshMedia() async {
    await _cancelStreams();
    _areImagesLoaded = false;
    _arePdfsLoaded = false;
    _isLoadingImages = false;
    _isLoadingPdfs = false;
    loadAllMedia();
  }

  void removeFile(MediaFile file) {
    final isPdf = file.type == MediaFileType.pdf;

    final mainList = isPdf ? _pdfFiles : _imageFiles;
    final tempList = isPdf ? _tempPdfFiles : _tempImageFiles;

    mainList.removeWhere((f) => f.path == file.path);
    tempList.removeWhere((f) => f.path == file.path);

    _cameraImagePaths.remove(file.path);
    _tempCameraImagePaths.remove(file.path);

    _emitLoadedState();
  }

  void unselectFile(MediaFile file) {
    if (file.type == MediaFileType.pdf) {
      _toggleFileInList(_tempPdfFiles, file.copyWith(selected: false));
    } else {
      _toggleFileInList(_tempImageFiles, file.copyWith(selected: false));
    }

    _emitLoadedState();
  }

  void _emitLoadedState() {
    if (isClosed) return;

    final isStillLoadingImages = _isLoadingImages && !_areImagesLoaded;
    final isStillLoadingPdfs = _isLoadingPdfs && !_arePdfsLoaded;

    emit(
      MediaLoaded(
        allFiles: [..._tempImageFiles, ..._tempPdfFiles],
        imageFiles: List.unmodifiable(_tempImageFiles),
        pdfFiles: List.unmodifiable(_tempPdfFiles),
        isLoadingMoreImages: isStillLoadingImages,
        isLoadingMorePdfs: isStillLoadingPdfs,
        totalImagesCount: _tempImageFiles.length,
        totalPdfsCount: _tempPdfFiles.length,
      ),
    );
  }

  int get selectedCount {
    var count = 0;

    for (final file in _tempImageFiles) {
      if (file.selected && !_isFromCamera(file)) count++;
    }

    for (final file in _tempPdfFiles) {
      if (file.selected) count++;
    }

    return count;
  }

  bool _isFromCamera(MediaFile file) {
    return _cameraImagePaths.contains(file.path);
  }

  List<MediaFile> get allFilesSelected =>
      [..._tempImageFiles, ..._tempPdfFiles].where((e) => e.selected).toList();

  List<MediaFile> get images => List.unmodifiable(_tempImageFiles);

  List<MediaFile> get pdfs => List.unmodifiable(_tempPdfFiles);

  @override
  Future<void> close() {
    _batchUpdateTimer?.cancel();
    _imageStreamSub?.cancel();
    _pdfStreamSub?.cancel();
    _pdfFiles.clear();
    _imageFiles.clear();
    _tempPdfFiles.clear();
    _tempImageFiles.clear();
    _cameraImagePaths.clear();
    _tempCameraImagePaths.clear();
    return super.close();
  }
}
