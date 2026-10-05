// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_completed_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierCompletedShiftModel _$CashierCompletedShiftModelFromJson(
  Map<String, dynamic> json,
) => CashierCompletedShiftModel(
  id: json['id'] as String,
  shiftDate: json['shift_date'] as String,
  shiftName: json['shift_name'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  status: $enumDecode(_$MyShiftStatusTypeEnumMap, json['status']),
  closingBalance: (json['closing_balance'] as num).toInt(),
  totalSales: (json['total_sales'] as num).toInt(),
  variance: (json['variance'] as num).toInt(),
  varianceType: json['variance_type'] as String,
  nextCashier: json['next_cashier'] == null
      ? null
      : CashierShiftUserModel.fromJson(
          json['next_cashier'] as Map<String, dynamic>,
        ),
  assignedTo: json['assigned_to'] == null
      ? null
      : CashierShiftUserModel.fromJson(
          json['assigned_to'] as Map<String, dynamic>,
        ),
  handoverStatus: json['handover_status'] == null
      ? null
      : CashierHandoverStatusModel.fromJson(
          json['handover_status'] as Map<String, dynamic>,
        ),
  handoverTo: json['handover_to'] == null
      ? null
      : CashierShiftUserModel.fromJson(
          json['handover_to'] as Map<String, dynamic>,
        ),
  handoverApprovedOrRejectedBy: json['handover_approved_or_rejected_by'] == null
      ? null
      : CashierHandoverApprovedOrRejectedByModel.fromJson(
          json['handover_approved_or_rejected_by'] as Map<String, dynamic>,
        ),
  branchName: json['branch_name'] as String,
  branchId: json['branch_id'] as String,
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
      id: json['id'] as String,
      name: json['name'] as String,
      userType: UserType.fromJson(json['user_type'] as String?),
      action: json['action'] as String,
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
