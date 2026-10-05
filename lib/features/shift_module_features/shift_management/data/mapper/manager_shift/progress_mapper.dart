import '../../../domain/entity/manager_shift/current_shift/progress_entity.dart';
import '../../model/manager_shift_management_models/shift_progress.dart';

extension ProgressMapper on ShiftProgress {
  ProgressEntity toEntity() => ProgressEntity(
    title: title,
    description: description,
    status: status,
    startTime: startTime,
    endTime: endTime,
    progressPercentage: progressPercentage,
  );
}
