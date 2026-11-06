// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_in_progress_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierInProgressShiftModel _$CashierInProgressShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierInProgressShiftModel(
  id: (json['id'] ?? '').toString(),
  date: (json['date'] as String?) ?? '',
  status: MyShiftStatusType.fromJson(json['status']),
  startTime: (json['start_time'] as String?) ?? '',
  endTime: (json['end_time'] as String?) ?? '',
  actualStartTime: json['actual_start_time'] as String?,
  openingBalance: openingBalanceFromJson(json['opening_balance']),
  closingBalance: (json['closing_balance'] as num?)?.toInt() ?? 0,
  assignedTo: (json['assigned_to'] as String?) ?? 'N/A',
  nextCashier: MyShiftStatusType.extractUserName(json['next_cashier']),
  assignedBy: (json['assigned_by'] as String?) ?? 'Branch Manager',
  assignedByUserType: UserType.fromJson(
    (json['assigned_by_user_type'] ?? json['type'])?.toString(),
  ),
);

Map<String, dynamic> _$CashierInProgressShiftModelToJson(
  CashierInProgressShiftModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'status': _$MyShiftStatusTypeEnumMap[instance.status]!,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'actual_start_time': instance.actualStartTime,
  'opening_balance': instance.openingBalance,
  'closing_balance': instance.closingBalance,
  'assigned_to': instance.assignedTo,
  'next_cashier': instance.nextCashier,
  'assigned_by': instance.assignedBy,
  'assigned_by_user_type': _$UserTypeEnumMap[instance.assignedByUserType]!,
};

const _$MyShiftStatusTypeEnumMap = {
  MyShiftStatusType.pending: 'not_started',
  MyShiftStatusType.reassigned: 'Reassigned',
  MyShiftStatusType.inProgress: 'In Progress',
  MyShiftStatusType.completed: 'Completed',
};

const _$UserTypeEnumMap = {
  UserType.cashier: 'cashier',
  UserType.manager: 'manager',
};
