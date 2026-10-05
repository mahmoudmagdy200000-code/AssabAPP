import 'package:flutter/material.dart';

import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../widgets/cashier_my_shifts_cards/in_progress_cards/cashier_my_in_progress_shifts_default_card.dart';
import '../cashier_my_shifts_cards_strategy.dart';

class CashierMyInProgressShiftsStrategy
    implements CashierMyShiftsCardsStrategy {
  @override
  Widget buildCard(CashierShiftEntity shift) {
    return CashierMyInProgressShiftsDefaultCard(shift: shift);
  }
}
