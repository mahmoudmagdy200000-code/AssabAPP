// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverStatusModel _$HandoverStatusModelFromJson(Map<String, dynamic> json) =>
    HandoverStatusModel(
      id: json['id'] as String,
      status: handoverStatusFromJson(json['status'] as String?),
      reviewedBy: json['reviewed_by'] as String?,
    );

Map<String, dynamic> _$HandoverStatusModelToJson(
  HandoverStatusModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': handoverStatusToJson(instance.status),
  'reviewed_by': instance.reviewedBy,
};
