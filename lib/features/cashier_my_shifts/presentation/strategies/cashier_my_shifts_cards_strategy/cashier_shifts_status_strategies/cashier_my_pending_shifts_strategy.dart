import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_default_card.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_with_handover_card.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_with_opening_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart';
import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_has_to_start_card.dart';
import '../cashier_my_shifts_cards_strategy.dart';

class CashierMyPendingShiftsStrategy implements CashierMyShiftsCardsStrategy {
  @override
  Widget buildCard(CashierShiftEntity shift) {
    if (shift.isNextShift ?? false) {
      return BlocProvider(
        create: (context) => getIt<StartCashierShiftCubit>(),
        child: CashierMyPendingShiftsHasToStartCard(shift: shift),
      );
    } else if (shift.openingBalance != 0) {
      return CashierMyPendingShiftsWithOpeningBalanceCard(shift: shift);
    } else if (shift.handoverTo?.id != null) {
      return CashierMyPendingShiftsWithHandoverCard(shift: shift);
    }

    return CashierMyPendingShiftsDefaultCard(shift: shift);
  }
}
