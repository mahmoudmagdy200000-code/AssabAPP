import 'package:assab/features/branch_manager_requests/data/models/responsibility_details_data_model.dart';

import '../entities/responsibility_entity.dart';

extension ResponsibilityMapper on ResponsibilityDetailsDataModel {
  ResponsibilityDetailsEntity toEntity() {
    return ResponsibilityDetailsEntity(
      shiftId: shiftId,
      cashierName: cashierName,
      branchName: branchName,
      varianceAmount: varianceAmount,
      varianceType: varianceType,
      shiftDate: DateTime.parse(shiftDate),
      responsibilityStatus: responsibilityStatus,
      reviewedAt: reviewedAt != null ? DateTime.parse(reviewedAt!) : null,
    );
  }
}
