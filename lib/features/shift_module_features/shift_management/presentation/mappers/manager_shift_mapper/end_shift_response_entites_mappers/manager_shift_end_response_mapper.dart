import '../../../../data/model/manager_shift_management_models/end_shift_models/end_shift_response_models/end_shift_response_model.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/end_shift_response_entity.dart';
import 'manager_shift_end_data_mapper.dart';

extension ShiftEndResponseMapper on ShiftEndResponseModel {
  EndShiftResponseEntity toEntity() {
    return EndShiftResponseEntity(
      success: success,
      message: message,
      data: data.toEntity(),
    );
  }
}
