import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_status_details_entities/rejection_details_entity.dart';

import '../../manager_shift/cashier_handover_details_entity/correction_details_entity.dart';

class HandoverStatusDetailsEntity {
  final HandoverStatus status;
  final String handoverTime;
  final String handedOverAt;
  final RejectionDetailsEntity? rejectionDetails;
  final String? rejectionReviewedBy;
  final String? managerComment;
  final bool wasEditedAfterRejection;
  final String? editedAt;
  final CorrectionDetailsEntity? correctionDetails;

  const HandoverStatusDetailsEntity({
    required this.status,
    required this.handoverTime,
    required this.handedOverAt,
    required this.rejectionDetails,
    required this.managerComment,
    required this.wasEditedAfterRejection,
    required this.rejectionReviewedBy,
    this.editedAt,
    required this.correctionDetails,
  });
}
