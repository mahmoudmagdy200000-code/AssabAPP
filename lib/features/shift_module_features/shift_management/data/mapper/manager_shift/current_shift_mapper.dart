import '../../../domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import '../../model/manager_shift_management_models/current_shift_data_model.dart';
import 'handover_details_mapper.dart';
import 'manager_shift_mapper.dart';
import 'progress_mapper.dart';

extension CurrentShiftMapper on CurrentShiftDataModel {
  CurrentShiftEntity toEntity() => CurrentShiftEntity(
    shift: shift.toEntity(),
    progress: shiftProgress.toEntity(),
    handover: handoversDetails.toBranchManager
        .map((e) => e.toHandoverDetailsEntity())
        .toList(),
  );
}
