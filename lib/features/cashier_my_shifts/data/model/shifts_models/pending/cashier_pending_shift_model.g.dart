// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_pending_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierPendingShiftModel _$CashierPendingShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierPendingShiftModel(
  id: (json['id'] ?? '').toString(),
  date: (json['date'] as String?) ?? '',
  status: MyShiftStatusType.fromJson(json['status']),
  statusLabel: (json['status_label'] as String?) ?? '',
  startTime: (json['start_time'] as String?) ?? '',
  endTime: (json['end_time'] as String?) ?? '',
  openingBalance: (json['opening_balance'] as num?)?.toInt() ?? 0,
  cashGiven: (json['cash_given'] as num?)?.toInt() ?? 0,
  variance: (json['variance'] as num?)?.toInt() ?? 0,
  cashFrom: CashierShiftUserModel.tryFromJson(json['cash_from']),
  handoverTo: CashierShiftUserModel.tryFromJson(json['handover_to']),
  assignedTo: (json['assigned_to'] as String?) ?? 'N/A',
  nextCashier: MyShiftStatusType.extractUserName(json['next_cashier']),
  assignedBy: (json['assigned_by'] as String?) ?? 'Branch Manager',
  assignedByUserType: (json['assigned_by_user_type'] as String?) ?? '',
  isNextShift: json['is_next_shift'] as bool? ?? false,
  canStart: json['can_start'] as bool? ?? false,
  actions: json['actions'] is Map<String, dynamic>
      ? CashierPendingShiftActionsModel.fromJson(
          json['actions'] as Map<String, dynamic>,
        )
      : const CashierPendingShiftActionsModel(
          viewDetails: false,
          reassignShift: false,
        ),
);

Map<String, dynamic> _$CashierPendingShiftModelToJson(
  CashierPendingShiftModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'status': _$MyShiftStatusTypeEnumMap[instance.status]!,
  'status_label': instance.statusLabel,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'opening_balance': instance.openingBalance,
  'cash_given': instance.cashGiven,
  'variance': instance.variance,
  'cash_from': instance.cashFrom,
  'handover_to': instance.handoverTo,
  'assigned_to': instance.assignedTo,
  'next_cashier': instance.nextCashier,
  'assigned_by': instance.assignedBy,
  'assigned_by_user_type': instance.assignedByUserType,
  'is_next_shift': instance.isNextShift,
  'can_start': instance.canStart,
  'actions': instance.actions,
};

const _$MyShiftStatusTypeEnumMap = {
  MyShiftStatusType.pending: 'not_started',
  MyShiftStatusType.reassigned: 'Reassigned',
  MyShiftStatusType.inProgress: 'In Progress',
  MyShiftStatusType.completed: 'Completed',
};
