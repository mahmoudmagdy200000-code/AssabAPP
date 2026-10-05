import 'package:json_annotation/json_annotation.dart';

part 'attachment_model.g.dart';

@JsonSerializable()
class AttachmentModel {
  final String id;

  @JsonKey(name: 'file_name')
  final String fileName;

  @JsonKey(name: 'file_type')
  final String fileType;

  @JsonKey(name: 'file_size')
  final int fileSize;

  final String url;

  @JsonKey(name: 'uploaded_at')
  final String uploadedAt;

  AttachmentModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.url,
    required this.uploadedAt,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentModelToJson(this);
}
