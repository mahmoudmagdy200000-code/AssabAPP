// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) =>
    AttachmentModel(
      id: json['id'] as String,
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      url: json['url'] as String,
      uploadedAt: json['uploaded_at'] as String,
    );

Map<String, dynamic> _$AttachmentModelToJson(AttachmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_name': instance.fileName,
      'file_type': instance.fileType,
      'file_size': instance.fileSize,
      'url': instance.url,
      'uploaded_at': instance.uploadedAt,
    };
