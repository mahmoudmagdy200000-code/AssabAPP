import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';

class FinalDailyCloseEntity {
  final TotalsEntity totals;
  final List<CashierBreakdownEntity> cashierBreakDowns;

  FinalDailyCloseEntity({
    required this.cashierBreakDowns,
    required this.totals,
  });
}
