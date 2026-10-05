import '../../../domain/entity/manager_shift/current_shift/shift_details_entity.dart';
import '../../model/manager_shift_management_models/manager_shift_details.dart';

extension ManagerShiftDetailsMapper on ManagerShiftDetails {
  ManagerShiftDetailsEntity toEntity() => ManagerShiftDetailsEntity(
    assignedTo: assignedTo,
    assignedBy: assignedBy,
    storeBranch: storeBranch,
    branchId: branchId,
    startTime: startTime,
    endTime: endTime,
    finalApprovalBy: finalApprovalBy,
    managerName: managerName,
  );
}
