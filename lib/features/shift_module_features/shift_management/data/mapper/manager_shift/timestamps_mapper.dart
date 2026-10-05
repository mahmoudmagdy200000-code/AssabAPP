import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/shift_time_stamps.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/timestamps_entity.dart';

extension TimestampsMapper on ShiftTimestamps {
  TimestampsEntity toEntity() =>
      TimestampsEntity(actualEnd: actualEndTime, actualStart: actualStartTime);
}
