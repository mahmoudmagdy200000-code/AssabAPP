import 'package:flutter/material.dart';

import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../widgets/cashier_my_shifts_cards/reassigned_cards/cashier_my_reassigned_shifts_default_card.dart';
import '../cashier_my_shifts_cards_strategy.dart';

class CashierMyReassignedShiftsStrategy
    implements CashierMyShiftsCardsStrategy {
  @override
  Widget buildCard(CashierShiftEntity shift) {
    // if(true){
    //
    //   return BlocProvider(create: (context) => getIt<ReassignedShiftActionsCubit>(),
    //   child:  CashierMyReassignedToYouShiftsCard(
    //     shift: shift,
    //     )
    //   );
    //
    // }
    return CashierMyReassignedShiftsDefaultCard(shift: shift);
  }
}
