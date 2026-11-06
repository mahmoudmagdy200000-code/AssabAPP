// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_completed_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierCompletedShiftModel _$CashierCompletedShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierCompletedShiftModel(
  id: (json['id'] ?? '').toString(),
  shiftDate: (json['shift_date'] as String?) ?? '',
  shiftName: (json['shift_name'] as String?) ?? 'Shift',
  startTime: (json['start_time'] as String?) ?? '',
  endTime: (json['end_time'] as String?) ?? '',
  status: MyShiftStatusType.fromJson(json['status']),
  closingBalance: (json['closing_balance'] as num?)?.toInt() ?? 0,
  totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
  variance: (json['variance'] as num?)?.toInt() ?? 0,
  varianceType: (json['variance_type'] as String?) ?? 'None',
  nextCashier: CashierShiftUserModel.tryFromJson(json['next_cashier']),
  assignedTo: CashierShiftUserModel.tryFromJson(json['assigned_to']),
  handoverStatus: json['handover_status'] is Map<String, dynamic>
      ? CashierHandoverStatusModel.fromJson(
          json['handover_status'] as Map<String, dynamic>,
        )
      : null,
  handoverTo: CashierShiftUserModel.tryFromJson(json['handover_to']),
  handoverApprovedOrRejectedBy: json['handover_approved_or_rejected_by'] is Map<String, dynamic>
      ? CashierHandoverApprovedOrRejectedByModel.fromJson(
          json['handover_approved_or_rejected_by'] as Map<String, dynamic>,
        )
      : null,
  branchName: (json['branch_name'] as String?) ?? '-',
  branchId: (json['branch_id'] ?? '').toString(),
);

Map<String, dynamic> _$CashierCompletedShiftModelToJson(
  CashierCompletedShiftModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'shift_date': instance.shiftDate,
  'shift_name': instance.shiftName,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'status': _$MyShiftStatusTypeEnumMap[instance.status]!,
  'closing_balance': instance.closingBalance,
  'total_sales': instance.totalSales,
  'variance': instance.variance,
  'variance_type': instance.varianceType,
  'next_cashier': instance.nextCashier,
  'assigned_to': instance.assignedTo,
  'handover_status': instance.handoverStatus,
  'handover_to': instance.handoverTo,
  'handover_approved_or_rejected_by': instance.handoverApprovedOrRejectedBy,
  'branch_name': instance.branchName,
  'branch_id': instance.branchId,
};

const _$MyShiftStatusTypeEnumMap = {
  MyShiftStatusType.pending: 'not_started',
  MyShiftStatusType.reassigned: 'Reassigned',
  MyShiftStatusType.inProgress: 'In Progress',
  MyShiftStatusType.completed: 'Completed',
};

CashierHandoverApprovedOrRejectedByModel
_$CashierHandoverApprovedOrRejectedByModelFromJson(Map<String, dynamic> json) =>
    CashierHandoverApprovedOrRejectedByModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] as String?) ?? 'N/A',
      userType: UserType.fromJson((json['user_type'] ?? json['type'])?.toString()),
      action: (json['action'] as String?) ?? 'pending',
    );

Map<String, dynamic> _$CashierHandoverApprovedOrRejectedByModelToJson(
  CashierHandoverApprovedOrRejectedByModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'user_type': _$UserTypeEnumMap[instance.userType]!,
  'action': instance.action,
};

const _$UserTypeEnumMap = {
  UserType.cashier: 'cashier',
  UserType.manager: 'manager',
};
