import '../../../../domain/entity/manager_shift/cashier_handover_details_entity/correction_details_entity.dart';
import '../../../model/handover_status_details/correction_details_model.dart';

extension CorrectionDetailsMapper on CorrectionDetailsModel {
  CorrectionDetailsEntity toEntity() {
    return CorrectionDetailsEntity(
      requestedBy: requestedBy,
      requestedById: requestedById,
      requestedByType: requestedByType,
      managerComment: managerComment,
      requestedAt: requestedAt,
      canCashierEdit: canCashierEdit,
    );
  }
}
