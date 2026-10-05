import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/variance_details/variance_other_cashier_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/variance/variance_data_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/variance_details/handover_variance_details_entity.dart';

extension HandoverVarianceDetailsMapper on VarianceModel {
  HandoverVarianceDetailsEntity toEntity() => HandoverVarianceDetailsEntity(
    currentCashierAmount: currentCashierAmount,
    totalVarianceAmount: totalVarianceAmount,
    reason: reason,
    otherCashiers: otherCashiers.map((e) => e.toEntity()).toList(),
    supportingFiles: supportingFiles,
    responsibilityType: responsibilityType,
    varianceType: varianceType,
  );
}
