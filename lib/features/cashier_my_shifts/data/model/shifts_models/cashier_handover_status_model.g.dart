// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_handover_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierHandoverStatusModel _$CashierHandoverStatusModelFromJson(
  Map<String, dynamic> json,
) => CashierHandoverStatusModel(
  status: cashierMyShiftsHandoverStatusFromJson(json['status'] as String?),
  reviewedBy: json['reviewed_by'] as String?,
);

Map<String, dynamic> _$CashierHandoverStatusModelToJson(
  CashierHandoverStatusModel instance,
) => <String, dynamic>{
  'status': _$CashierMyShiftsHandoverStatusEnumMap[instance.status]!,
  'reviewed_by': instance.reviewedBy,
};

const _$CashierMyShiftsHandoverStatusEnumMap = {
  CashierMyShiftsHandoverStatus.pending: 'pending',
  CashierMyShiftsHandoverStatus.accepted: 'accepted',
  CashierMyShiftsHandoverStatus.rejected: 'rejected',
  CashierMyShiftsHandoverStatus.notStarted: 'notStarted',
  CashierMyShiftsHandoverStatus.noHandover: 'noHandover',
};
