import 'package:json_annotation/json_annotation.dart';

part 'manager_shift_details.g.dart';

@JsonSerializable()
class ManagerShiftDetails {
  @JsonKey(name: 'assigned_to')
  final String assignedTo;

  @JsonKey(name: 'assigned_by')
  final String assignedBy;

  @JsonKey(name: 'store_branch')
  final String storeBranch;

  @JsonKey(name: 'branch_id')
  final String branchId;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'final_approval_by')
  final String finalApprovalBy;

  @JsonKey(name: 'manager_name')
  final String managerName;

  @JsonKey(name: 'manager_id')
  final String managerId;

  ManagerShiftDetails({
    required this.assignedTo,
    required this.assignedBy,
    required this.storeBranch,
    required this.branchId,
    required this.startTime,
    required this.endTime,
    required this.finalApprovalBy,
    required this.managerName,
    required this.managerId,
  });

  factory ManagerShiftDetails.fromJson(Map<String, dynamic> json) =>
      _$ManagerShiftDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerShiftDetailsToJson(this);
}
