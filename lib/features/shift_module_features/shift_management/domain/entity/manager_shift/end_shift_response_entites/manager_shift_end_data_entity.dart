import 'daily_totals_entity.dart';
import 'final_handover_end_shift_entity.dart';

class ManagerShiftEndDataEntity {
  final FinalHandoverEndShiftEntity finalHandover;
  final DailyTotalsEntity dailyTotals;

  const ManagerShiftEndDataEntity({
    required this.finalHandover,
    required this.dailyTotals,
  });
}
