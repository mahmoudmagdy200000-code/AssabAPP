// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejection_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectionDetailsModel _$RejectionDetailsModelFromJson(
  Map<String, dynamic> json,
) => RejectionDetailsModel(
  rejectionReason: json['rejection_reason'] as String,
  rejectionCount: (json['rejection_count'] as num).toInt(),
  firstRejectedAt: json['first_rejected_at'] as String,
  secondRejectedAt: json['second_rejected_at'] as String?,
  isPermanentlyRejected: json['is_permanently_rejected'] as bool,
  canCashierEdit: json['can_cashier_edit'] as bool,
  rejectionFiles: (json['rejection_files'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RejectionDetailsModelToJson(
  RejectionDetailsModel instance,
) => <String, dynamic>{
  'rejection_reason': instance.rejectionReason,
  'rejection_count': instance.rejectionCount,
  'first_rejected_at': instance.firstRejectedAt,
  'second_rejected_at': instance.secondRejectedAt,
  'is_permanently_rejected': instance.isPermanentlyRejected,
  'can_cashier_edit': instance.canCashierEdit,
  'rejection_files': instance.rejectionFiles,
};
