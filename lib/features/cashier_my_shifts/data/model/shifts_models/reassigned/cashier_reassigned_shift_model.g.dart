// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_reassigned_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierReassignedShiftModel _$CashierReassignedShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierReassignedShiftModel(
  id: (json['id'] ?? '').toString(),
  shiftDate: (json['shift_date'] as String?) ?? '',
  shiftName: (json['shift_name'] as String?) ?? 'Shift',
  reassignedAt: (json['reassigned_at'] as String?) ?? '',
  reassignmentReason: (json['reassignment_reason'] as String?) ?? '',
  closingBalance: (json['closing_balance'] as num?)?.toInt() ?? 0,
  variance: (json['variance'] as num?)?.toInt() ?? 0,
  cashGiven: (json['cash_given'] as num?)?.toInt() ?? 0,
  reassignedTo: CashierReassignUserModel.tryFromJson(json['reassigned_to']),
  reassignedFrom: CashierReassignUserModel.tryFromJson(json['reassigned_from']),
  reassignedBy: CashierReassignUserModel.tryFromJson(json['reassigned_by']),
  startTime: (json['start_time'] as String?) ?? '',
  endTime: (json['end_time'] as String?) ?? '',
  nextCashier: MyShiftStatusType.extractUserName(json['next_cashier']),
  isMidReassign: json['is_mid_reassign'] as bool? ?? false,
  canBeAccepted: json['can_be_accepted'] as bool? ?? false,
  originalCashier: (json['original_cashier'] as String?) ?? '',
  branchName: (json['branch_name'] as String?) ?? '-',
  branchId: (json['branch_id'] ?? '').toString(),
  status: MyShiftStatusType.fromJson(json['status']),
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
