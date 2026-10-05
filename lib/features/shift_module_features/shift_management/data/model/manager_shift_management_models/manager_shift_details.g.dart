// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerShiftDetails _$ManagerShiftDetailsFromJson(Map<String, dynamic> json) =>
    ManagerShiftDetails(
      assignedTo: json['assigned_to'] as String,
      assignedBy: json['assigned_by'] as String,
      storeBranch: json['store_branch'] as String,
      branchId: json['branch_id'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      finalApprovalBy: json['final_approval_by'] as String,
      managerName: json['manager_name'] as String,
      managerId: json['manager_id'] as String,
    );

Map<String, dynamic> _$ManagerShiftDetailsToJson(
  ManagerShiftDetails instance,
) => <String, dynamic>{
  'assigned_to': instance.assignedTo,
  'assigned_by': instance.assignedBy,
  'store_branch': instance.storeBranch,
  'branch_id': instance.branchId,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'final_approval_by': instance.finalApprovalBy,
  'manager_name': instance.managerName,
  'manager_id': instance.managerId,
};
