import 'package:assab/features/cashier_my_shifts/presentation/strategies/cashier_my_shifts_cards_strategy/cashier_shifts_status_strategies/cashier_my_completed_shifts_strategy.dart';
import 'package:assab/features/cashier_my_shifts/presentation/strategies/cashier_my_shifts_cards_strategy/cashier_shifts_status_strategies/cashier_my_in_progress_shifts_strategy.dart';
import 'package:assab/features/cashier_my_shifts/presentation/strategies/cashier_my_shifts_cards_strategy/cashier_shifts_status_strategies/cashier_my_reassigned_shifts_strategy.dart';

import '../../../domain/enums/my_shifts_status.dart';
import 'cashier_my_shifts_cards_strategy.dart';
import 'cashier_shifts_status_strategies/cashier_my_pending_shifts_strategy.dart';

class CashierMyShiftsCardStrategyResolver {
  static CashierMyShiftsCardsStrategy resolve(MyShiftStatusType status) {
    switch (status) {
      case MyShiftStatusType.pending:
        return CashierMyPendingShiftsStrategy();

      case MyShiftStatusType.completed:
        return CashierMyCompletedShiftsStrategy();

      case MyShiftStatusType.reassigned:
        return CashierMyReassignedShiftsStrategy();

      case MyShiftStatusType.inProgress:
        return CashierMyInProgressShiftsStrategy();
    }
  }
}
