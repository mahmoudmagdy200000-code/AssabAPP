import '../../../../domain/entity/shift/handover_to_entity.dart';
import '../../../model/shift/shift_details/shift_details_model.dart';

extension HandoverToMapper on HandoverToModel {
  HandoverToEntity toEntity() {
    return HandoverToEntity(id: id, name: name, type: type, email: email);
  }
}
