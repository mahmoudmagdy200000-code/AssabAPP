import '../../../../domain/entity/shift/handover_status_details_entities/rejection_details_entity.dart';
import '../../../model/handover_status_details/rejection_details_model.dart';

extension RejectionDetailsMapper on RejectionDetailsModel {
  RejectionDetailsEntity toEntity() {
    return RejectionDetailsEntity(
      rejectionReason: rejectionReason,
      rejectionCount: rejectionCount,
      firstRejectedAt: firstRejectedAt,
      secondRejectedAt: secondRejectedAt,
      isPermanentlyRejected: isPermanentlyRejected,
      canCashierEdit: canCashierEdit,
      rejectionFiles: rejectionFiles,
    );
  }
}
