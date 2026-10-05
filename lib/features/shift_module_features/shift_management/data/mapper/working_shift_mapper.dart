import '../../domain/entity/working_shift_entity.dart';
import '../model/working_shift_model.dart';

extension WorkingShiftMapper on WorkingShiftModel {
  WorkingShiftEntity toEntity() {
    return WorkingShiftEntity(
      id: id,
      name: name,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
