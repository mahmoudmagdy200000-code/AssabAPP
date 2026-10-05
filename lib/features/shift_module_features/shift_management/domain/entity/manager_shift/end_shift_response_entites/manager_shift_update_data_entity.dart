import 'daily_totals_entity.dart';
import 'final_handover_end_shift_entity.dart';

class ManagerShiftUpdateDataEntity {
  final ManagerHandoverShiftEntity shift;
  final DailyTotalsEntity dailyTotals;

  const ManagerShiftUpdateDataEntity({
    required this.shift,
    required this.dailyTotals,
  });
}

class ManagerHandoverShiftEntity {
  final FinalHandoverEndShiftEntity finalHandover;

  const ManagerHandoverShiftEntity({required this.finalHandover});
}
