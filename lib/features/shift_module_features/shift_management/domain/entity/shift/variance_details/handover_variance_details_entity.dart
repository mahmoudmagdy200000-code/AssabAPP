import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/variance_details.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/variance_details/variance_other_cashier_entity.dart';

class HandoverVarianceDetailsEntity {
  final String responsibilityType;

  final double currentCashierAmount;

  final List<VarianceOtherCashierEntity> otherCashiers;
  final String? reason;

  final List<String> supportingFiles;

  final double totalVarianceAmount;

  final VarianceType varianceType;

  HandoverVarianceDetailsEntity({
    required this.responsibilityType,
    required this.currentCashierAmount,
    required this.otherCashiers,
    required this.reason,
    required this.supportingFiles,
    required this.totalVarianceAmount,
    required this.varianceType,
  });
}
