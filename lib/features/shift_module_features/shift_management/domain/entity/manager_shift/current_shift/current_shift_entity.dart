import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';

import 'handover_details_entity.dart';
import 'progress_entity.dart';

class CurrentShiftEntity {
  final ManagerShiftEntity shift;
  final ProgressEntity progress;
  final List<HandoverDetailsEntity> handover;

  CurrentShiftEntity({
    required this.shift,
    required this.progress,
    required this.handover,
  });
}
