// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_handover_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierHandoverDetailsModel _$CashierHandoverDetailsModelFromJson(
  Map<String, dynamic> json,
) => CashierHandoverDetailsModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: CashierHandoverData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashierHandoverDetailsModelToJson(
  CashierHandoverDetailsModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

CashierHandoverData _$CashierHandoverDataFromJson(Map<String, dynamic> json) =>
    CashierHandoverData(
      handover: CashierHandover.fromJson(
        json['handover'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CashierHandoverDataToJson(
  CashierHandoverData instance,
) => <String, dynamic>{'handover': instance.handover};

CashierHandover _$CashierHandoverFromJson(Map<String, dynamic> json) =>
    CashierHandover(
      handoverId: (json['handover_id'] ?? '').toString(),
      cashierShiftId: (json['cashier_shift_id'] ?? '').toString(),
      cashierName: (json['cashier_name'] as String?) ?? 'N/A',
      cashierId: (json['cashier_id'] ?? '').toString(),
      shiftTime: (json['shift_time'] as String?) ?? '',
      shiftId: (json['shift_id'] ?? '').toString(),
      handoverAmount: (json['handover_amount'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      netSales: (json['net_sales'] as num?)?.toDouble() ?? 0.0,
      vatAmount: (json['vat_amount'] as num?)?.toDouble() ?? 0.0,
      cashCollected: (json['cash_collected'] as num?)?.toDouble() ?? 0.0,
      cardPayments: (json['card_payments'] as num?)?.toDouble() ?? 0.0,
      deliveryAppPayments: (json['delivery_app_payments'] as num?)?.toDouble() ?? 0.0,
      varianceAmount: (json['variance_amount'] as num?)?.toDouble() ?? 0.0,
      varianceType: $enumDecodeNullable(_$VarianceTypeEnumMap, json['variance_type']) ?? VarianceType.none,
      varianceReason: json['variance_reason'] as String?,
      attachedFiles: (json['attached_files'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: handoverStatusFromJson(json['status'] as String?),
      rejectionReason: json['rejection_reason'] as String?,
      rejectionCount: (json['rejection_count'] as num?)?.toInt() ?? 0,
      handedOverAt: json['handed_over_at'] as String?,
      approvedAt: json['approved_at'],
      approvedBy: json['approved_by'] as String?,
      approvedById: json['approved_by_id']?.toString(),
      canApprove: json['can_approve'] as bool? ?? false,
      canReject: json['can_reject'] as bool? ?? false,
      varianceDetails: json['variance_details'] is Map<String, dynamic>
          ? VarianceDetailsModel.fromJson(
              json['variance_details'] as Map<String, dynamic>,
            )
          : null,
      handoverToType: (json['handover_to_type'] as String?) ?? 'cashier',
      handoverTo: (json['handover_to'] as String?) ?? 'N/A',
      handoverToId: (json['handover_to_id'] ?? '').toString(),
      handoverDate: (json['handover_date'] as String?) ?? '',
      handoverTime: (json['handover_time'] as String?) ?? '',
      handoverNotes: json['handover_notes'] as String?,
      correctionDetails: json['correction_details'] is Map<String, dynamic>
          ? CorrectionDetailsModel.fromJson(
              json['correction_details'] as Map<String, dynamic>,
            )
          : null,
    );

Map<String, dynamic> _$CashierHandoverToJson(CashierHandover instance) =>
    <String, dynamic>{
      'handover_id': instance.handoverId,
      'cashier_shift_id': instance.cashierShiftId,
      'cashier_name': instance.cashierName,
      'cashier_id': instance.cashierId,
      'shift_time': instance.shiftTime,
      'shift_id': instance.shiftId,
      'handover_amount': instance.handoverAmount,
      'total_sales': instance.totalSales,
      'net_sales': instance.netSales,
      'vat_amount': instance.vatAmount,
      'cash_collected': instance.cashCollected,
      'card_payments': instance.cardPayments,
      'delivery_app_payments': instance.deliveryAppPayments,
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
      'approved_by_id': instance.approvedById,
      'can_approve': instance.canApprove,
      'can_reject': instance.canReject,
      'variance_details': instance.varianceDetails,
      'handover_to_type': instance.handoverToType,
      'handover_to': instance.handoverTo,
      'handover_to_id': instance.handoverToId,
      'handover_date': instance.handoverDate,
      'handover_time': instance.handoverTime,
      'handover_notes': instance.handoverNotes,
      'correction_details': instance.correctionDetails,
    };

const _$VarianceTypeEnumMap = {
  VarianceType.over: 'Over',
  VarianceType.short: 'Short',
  VarianceType.none: 'None',
};
