// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_reassigned_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierReassignedShiftModel _$CashierReassignedShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierReassignedShiftModel(
  id: json['id'] as String,
  shiftDate: json['shift_date'] as String,
  shiftName: json['shift_name'] as String,
  reassignedAt: json['reassigned_at'] as String,
  reassignmentReason: json['reassignment_reason'] as String,
  closingBalance: (json['closing_balance'] as num).toInt(),
  variance: (json['variance'] as num).toInt(),
  cashGiven: (json['cash_given'] as num).toInt(),
  reassignedTo: CashierReassignUserModel.fromJson(
    json['reassigned_to'] as Map<String, dynamic>,
  ),
  reassignedFrom: CashierReassignUserModel.fromJson(
    json['reassigned_from'] as Map<String, dynamic>,
  ),
  reassignedBy: CashierReassignUserModel.fromJson(
    json['reassigned_by'] as Map<String, dynamic>,
  ),
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  nextCashier: json['next_cashier'] as String?,
  isMidReassign: json['is_mid_reassign'] as bool,
  canBeAccepted: json['can_be_accepted'] as bool,
  originalCashier: json['original_cashier'] as String,
  branchName: json['branch_name'] as String,
  branchId: json['branch_id'] as String,
  status: $enumDecode(_$MyShiftStatusTypeEnumMap, json['status']),
);

Map<String, dynamic> _$CashierReassignedShiftModelToJson(
  CashierReassignedShiftModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'shift_date': instance.shiftDate,
  'shift_name': instance.shiftName,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'reassigned_at': instance.reassignedAt,
  'reassignment_reason': instance.reassignmentReason,
  'closing_balance': instance.closingBalance,
  'variance': instance.variance,
  'cash_given': instance.cashGiven,
  'reassigned_to': instance.reassignedTo,
  'reassigned_from': instance.reassignedFrom,
  'reassigned_by': instance.reassignedBy,
  'next_cashier': instance.nextCashier,
  'is_mid_reassign': instance.isMidReassign,
  'can_be_accepted': instance.canBeAccepted,
  'original_cashier': instance.originalCashier,
  'branch_name': instance.branchName,
  'branch_id': instance.branchId,
  'status': _$MyShiftStatusTypeEnumMap[instance.status]!,
};

const _$MyShiftStatusTypeEnumMap = {
  MyShiftStatusType.pending: 'not_started',
  MyShiftStatusType.reassigned: 'Reassigned',
  MyShiftStatusType.inProgress: 'In Progress',
  MyShiftStatusType.completed: 'Completed',
};
