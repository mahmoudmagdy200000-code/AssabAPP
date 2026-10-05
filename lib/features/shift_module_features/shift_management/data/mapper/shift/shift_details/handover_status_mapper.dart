import '../../../../domain/entity/shift/handover_entity.dart';
import '../../../model/shift/shift_details/handover_status_model.dart';

extension HandoverStatusMapper on HandoverStatusModel {
  HandoverStatusEntity toEntity() {
    return HandoverStatusEntity(
      id: id,
      status: status,
      reviewedBy: reviewedBy ?? 'N/A',
    );
  }
}
