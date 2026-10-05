import 'package:assab/features/shift_module_features/shift_management/data/mapper/manager_shift/timestamps_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/manager_shift_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';

import 'final_handover_mapper.dart';
import 'manager_shift_details_mapper.dart';

extension ShiftMapper on ManagerShiftModel {
  ManagerShiftEntity toEntity() => ManagerShiftEntity(
    id: id,
    shiftDate: shiftDate,
    status: status,
    shiftDetails: shiftDetails.toEntity(),
    finalHandover: finalHandover.toEntity(),
    timestamps: timestamps.toEntity(),
  );
}
