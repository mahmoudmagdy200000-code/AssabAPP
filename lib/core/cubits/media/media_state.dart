import 'package:equatable/equatable.dart';

import '../../models/media_file_model.dart';

sealed class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

final class MediaInitial extends MediaState {
  const MediaInitial();
}

/// Loading state with optional progress info
final class MediaLoading extends MediaState {
  final int imagesLoaded;
  final int pdfsLoaded;
  final bool isInitialLoad;

  const MediaLoading({
    this.imagesLoaded = 0,
    this.pdfsLoaded = 0,
    this.isInitialLoad = true,
  });

  @override
  List<Object?> get props => [imagesLoaded, pdfsLoaded, isInitialLoad];
}

/// Main loaded state with streaming support
final class MediaLoaded extends MediaState {
  final List<MediaFile> allFiles;
  final List<MediaFile> imageFiles;
  final List<MediaFile> pdfFiles;

  /// Whether images are still being loaded in background
  final bool isLoadingMoreImages;

  /// Whether PDFs are still being loaded in background
  final bool isLoadingMorePdfs;

  /// Total count of images found so far
  final int totalImagesCount;

  /// Total count of PDFs found so far
  final int totalPdfsCount;

  const MediaLoaded({
    required this.allFiles,
    required this.imageFiles,
    required this.pdfFiles,
    this.isLoadingMoreImages = false,
    this.isLoadingMorePdfs = false,
    this.totalImagesCount = 0,
    this.totalPdfsCount = 0,
  });

  MediaLoaded copyWith({
    List<MediaFile>? allFiles,
    List<MediaFile>? imageFiles,
    List<MediaFile>? pdfFiles,
    bool? isLoadingMoreImages,
    bool? isLoadingMorePdfs,
    int? totalImagesCount,
    int? totalPdfsCount,
  }) {
    return MediaLoaded(
      allFiles: allFiles ?? this.allFiles,
      imageFiles: imageFiles ?? this.imageFiles,
      pdfFiles: pdfFiles ?? this.pdfFiles,
      isLoadingMoreImages: isLoadingMoreImages ?? this.isLoadingMoreImages,
      isLoadingMorePdfs: isLoadingMorePdfs ?? this.isLoadingMorePdfs,
      totalImagesCount: totalImagesCount ?? this.totalImagesCount,
      totalPdfsCount: totalPdfsCount ?? this.totalPdfsCount,
    );
  }

  @override
  List<Object?> get props => [
    allFiles,
    imageFiles,
    pdfFiles,
    isLoadingMoreImages,
    isLoadingMorePdfs,
    totalImagesCount,
    totalPdfsCount,
  ];
}

final class MediaFailure extends MediaState {
  final String message;

  const MediaFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class MediaPermissionDenied extends MediaState {
  const MediaPermissionDenied();
}
