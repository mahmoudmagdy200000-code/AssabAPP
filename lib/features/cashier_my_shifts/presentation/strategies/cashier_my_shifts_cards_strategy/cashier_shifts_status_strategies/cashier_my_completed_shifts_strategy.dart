import 'package:flutter/material.dart';

import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../widgets/cashier_my_shifts_cards/completed_cards/cashier_my_completed_shifts_default_card.dart';
import '../../../widgets/cashier_my_shifts_cards/completed_cards/cashier_my_completed_shifts_handover_approved_card.dart';
import '../../../widgets/cashier_my_shifts_cards/completed_cards/cashier_my_completed_shifts_handover_detected_card.dart';
import '../cashier_my_shifts_cards_strategy.dart';

class CashierMyCompletedShiftsStrategy implements CashierMyShiftsCardsStrategy {
  @override
  Widget buildCard(CashierShiftEntity shift) {
    if (shift.handoverTo?.id != null) {
      return CashierMyCompletedShiftsHandoverDetectedCard(shift: shift);
    } else if (true) {
      // shift.handoverStatus?.status == CashierMyShiftsHandoverStatus.accepted
      return CashierMyCompletedShiftsHandoverApprovedCard(shift: shift);
    }
    return CashierMyCompletedShiftsDefaultCard(shift: shift);
  }
}
