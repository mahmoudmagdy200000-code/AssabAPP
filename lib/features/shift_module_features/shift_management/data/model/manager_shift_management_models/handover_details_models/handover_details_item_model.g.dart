// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_details_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverDetailsItemModel _$HandoverDetailsItemModelFromJson(
  Map<String, dynamic> json,
) => HandoverDetailsItemModel(
  handoverId: json['handover_id'] as String,
  cashierShiftId: json['cashier_shift_id'] as String,
  cashierName: json['cashier_name'] as String,
  shiftTime: json['shift_time'] as String,
  handoverAmount: (json['handover_amount'] as num).toDouble(),
  handoverDate: json['handover_date'] as String,
  handoverTime: json['handover_time'] as String,
  handoverNotes: json['handover_notes'] as String?,
  handoverFrom: json['handover_from'] as String,
  handoverTo: json['handover_to'] as String,
  handoverToId: json['handover_to_id'] as String,
  totalSales: (json['total_sales'] as num).toDouble(),
  varianceAmount: (json['variance_amount'] as num).toDouble(),
  varianceType: $enumDecode(_$VarianceTypeEnumMap, json['variance_type']),
  varianceReason: json['variance_reason'] as String?,
  attachedFiles: (json['attached_files'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  status: handoverStatusFromJson(json['status'] as String?),
  rejectionReason: json['rejection_reason'] as String?,
  rejectionCount: (json['rejection_count'] as num).toInt(),
  handedOverAt: json['handed_over_at'] as String?,
  approvedAt: json['approved_at'] as String?,
  approvedBy: json['approved_by'] as String?,
  canApprove: json['can_approve'] as bool,
  canReject: json['can_reject'] as bool,
  varianceDetails: json['variance_details'] == null
      ? null
      : VarianceDetailsModel.fromJson(
          json['variance_details'] as Map<String, dynamic>,
        ),
  accountingName: json['accounting_name'] as String,
);

Map<String, dynamic> _$HandoverDetailsItemModelToJson(
  HandoverDetailsItemModel instance,
) => <String, dynamic>{
  'handover_id': instance.handoverId,
  'cashier_shift_id': instance.cashierShiftId,
  'cashier_name': instance.cashierName,
  'shift_time': instance.shiftTime,
  'handover_amount': instance.handoverAmount,
  'handover_date': instance.handoverDate,
  'handover_time': instance.handoverTime,
  'handover_notes': instance.handoverNotes,
  'handover_from': instance.handoverFrom,
  'handover_to': instance.handoverTo,
  'handover_to_id': instance.handoverToId,
  'total_sales': instance.totalSales,
  'variance_amount': instance.varianceAmount,
  'variance_type': _$VarianceTypeEnumMap[instance.varianceType]!,
  'variance_reason': instance.varianceReason,
  'attached_files': instance.attachedFiles,
  'status': handoverStatusToJson(instance.status),
  'rejection_reason': instance.rejectionReason,
  'rejection_count': instance.rejectionCount,
  'handed_over_at': instance.handedOverAt,
  'approved_at': instance.approvedAt,
  'approved_by': instance.approvedBy,
  'can_approve': instance.canApprove,
  'can_reject': instance.canReject,
  'variance_details': instance.varianceDetails,
  'accounting_name': instance.accountingName,
};

const _$VarianceTypeEnumMap = {
  VarianceType.over: 'Over',
  VarianceType.short: 'Short',
  VarianceType.none: 'None',
};
