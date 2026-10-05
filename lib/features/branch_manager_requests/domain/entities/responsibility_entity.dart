import '../../../shift_module_features/shift_management/data/model/manager_shift_management_models/variance_details.dart';
import '../enums/responsibility_status.dart';

class ResponsibilityDetailsEntity {
  final String shiftId;
  final String cashierName;
  final String branchName;
  final double varianceAmount;
  final VarianceType varianceType;
  final DateTime shiftDate;
  final ResponsibilityStatus responsibilityStatus;
  final DateTime? reviewedAt;

  ResponsibilityDetailsEntity({
    required this.shiftId,
    required this.cashierName,
    required this.branchName,
    required this.varianceAmount,
    required this.varianceType,
    required this.shiftDate,
    required this.responsibilityStatus,
    required this.reviewedAt,
  });
}
