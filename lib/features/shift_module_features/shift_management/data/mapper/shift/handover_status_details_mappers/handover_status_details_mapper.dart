import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/handover_status_details_mappers/rejection_details_mapper.dart';

import '../../../../domain/entity/shift/handover_status_details_entities/handover_status_details_entity.dart';
import '../../../model/handover_status_details/handover_status_details_model.dart';
import '../../manager_shift/correction_details_mapper.dart';

extension HandoverStatusDetailsMapper on HandoverStatusDetailsModel {
  HandoverStatusDetailsEntity toEntity() {
    return HandoverStatusDetailsEntity(
      status: status,
      handoverTime: handoverTime,
      handedOverAt: handedOverAt,
      rejectionDetails: rejectionDetails?.toEntity(),
      managerComment: managerComment,
      rejectionReviewedBy: rejectionReviewedBy,
      wasEditedAfterRejection: wasEditedAfterRejection,
      editedAt: editedAt,
      correctionDetails: correctionDetails?.toEntity(),
    );
  }
}
