// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correction_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CorrectionDetailsModel _$CorrectionDetailsModelFromJson(
  Map<String, dynamic> json,
) => CorrectionDetailsModel(
  requestedBy: json['requested_by'] as String,
  requestedById: json['requested_by_id'] as String,
  requestedByType: json['requested_by_type'] as String,
  managerComment: json['manager_comment'] as String?,
  requestedAt: json['requested_at'] as String,
  canCashierEdit: json['can_cashier_edit'] as bool,
);

Map<String, dynamic> _$CorrectionDetailsModelToJson(
  CorrectionDetailsModel instance,
) => <String, dynamic>{
  'requested_by': instance.requestedBy,
  'requested_by_id': instance.requestedById,
  'requested_by_type': instance.requestedByType,
  'manager_comment': instance.managerComment,
  'requested_at': instance.requestedAt,
  'can_cashier_edit': instance.canCashierEdit,
};
