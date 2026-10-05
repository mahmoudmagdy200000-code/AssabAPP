import 'dart:io';

import '../enums/media_file_type.dart';

class MediaFile {
  final String path;
  final String name;
  final MediaFileType type;
  final bool selected;
  final int size;
  final String fileExtension;

  const MediaFile({
    required this.path,
    required this.name,
    required this.type,
    this.selected = false,
    this.size = 0,
    required this.fileExtension,
  });

  factory MediaFile.fromFile(File file) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final fileSize = file.existsSync() ? file.lengthSync() : 0;
    final isPdf = fileName.toLowerCase().endsWith('.pdf');
    final type = isPdf ? MediaFileType.pdf : MediaFileType.image;
    final extension = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : '';

    return MediaFile(
      path: file.path,
      name: fileName,
      type: type,
      size: fileSize,
      fileExtension: extension,
    );
  }

  MediaFile copyWith({bool? selected}) {
    return MediaFile(
      path: path,
      name: name,
      type: type,
      size: size,
      fileExtension: fileExtension,
      selected: selected ?? this.selected,
    );
  }

  File get toFile => File(path);

  bool get isPDF => type == MediaFileType.pdf;

  bool get isImage => type == MediaFileType.image;

  String get formattedSize {
    if (size <= 0) return '0 KB';
    const kb = 1024;
    const mb = 1024 * 1024;
    if (size >= mb) return '${(size / mb).toStringAsFixed(1)} MB';
    return '${(size / kb).toStringAsFixed(1)} KB';
  }
}
