// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_in_progress_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierInProgressShiftModel _$CashierInProgressShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierInProgressShiftModel(
  id: json['id'] as String,
  date: json['date'] as String,
  status: $enumDecode(_$MyShiftStatusTypeEnumMap, json['status']),
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  actualStartTime: json['actual_start_time'] as String?,
  openingBalance: openingBalanceFromJson(json['opening_balance']),
  closingBalance: (json['closing_balance'] as num).toInt(),
  assignedTo: json['assigned_to'] as String,
  nextCashier: json['next_cashier'] as String?,
  assignedBy: json['assigned_by'] as String,
  assignedByUserType: UserType.fromJson(
    json['assigned_by_user_type'] as String?,
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
