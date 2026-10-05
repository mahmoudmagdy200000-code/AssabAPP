import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/cashier_handover_models/correction_details_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/cashier_handover_details_entity/correction_details_entity.dart';

extension CorrectionDetailsMapper on CorrectionDetailsModel {
  CorrectionDetailsEntity toEntity() => CorrectionDetailsEntity(
    canCashierEdit: canCashierEdit,
    managerComment: managerComment,
    requestedAt: requestedAt,
    requestedById: requestedById,
    requestedBy: requestedBy,
    requestedByType: requestedByType,
  );
}
