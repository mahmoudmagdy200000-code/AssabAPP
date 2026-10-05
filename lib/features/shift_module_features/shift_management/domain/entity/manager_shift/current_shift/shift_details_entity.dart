class ManagerShiftDetailsEntity {
  final String assignedTo;
  final String assignedBy;
  final String storeBranch;
  final String branchId;
  final String startTime;
  final String endTime;
  final String finalApprovalBy;
  final String managerName;

  ManagerShiftDetailsEntity({
    required this.assignedTo,
    required this.assignedBy,
    required this.storeBranch,
    required this.branchId,
    required this.startTime,
    required this.endTime,
    required this.finalApprovalBy,
    required this.managerName,
  });
}
