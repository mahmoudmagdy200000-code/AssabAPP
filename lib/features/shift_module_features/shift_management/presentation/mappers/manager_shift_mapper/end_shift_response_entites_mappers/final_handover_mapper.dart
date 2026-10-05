import '../../../../data/model/manager_shift_management_models/end_shift_models/end_shift_response_models/final_handover_model.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/final_handover_end_shift_entity.dart';

extension FinalHandoverMapper on EndShiftFinalHandoverModel {
  FinalHandoverEndShiftEntity toEntity() {
    return FinalHandoverEndShiftEntity(
      handoverAmount: handoverAmount ?? 0,
      status: status ?? '',
      handoverFrom: handoverFrom ?? '',
      handoverTo: handoverTo ?? '',
      handoverDate: handoverDate ?? '',
      handoverTime: handoverTime ?? '',
      handoverNotes: handoverNotes,
    );
  }
}
