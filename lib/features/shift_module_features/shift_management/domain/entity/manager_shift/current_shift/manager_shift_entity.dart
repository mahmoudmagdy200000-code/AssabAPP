import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/shift_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/timestamps_entity.dart';

import '../../../../../../../core/enums/shift_status/shift_status_type.dart';

class ManagerShiftEntity {
  final String id;
  final String shiftDate;
  final ShiftStatusType status;
  final ManagerShiftDetailsEntity shiftDetails;
  final FinalHandoverEntity finalHandover;
  final TimestampsEntity timestamps;

  ManagerShiftEntity({
    required this.id,
    required this.shiftDate,
    required this.status,
    required this.shiftDetails,
    required this.finalHandover,
    required this.timestamps,
  });
}
