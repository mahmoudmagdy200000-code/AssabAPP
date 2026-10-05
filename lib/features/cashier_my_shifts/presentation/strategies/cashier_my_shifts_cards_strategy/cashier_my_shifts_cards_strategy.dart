import 'package:flutter/material.dart';

import '../../../domain/entities/cashier_my_shift_entity.dart';

abstract class CashierMyShiftsCardsStrategy {
  Widget buildCard(CashierShiftEntity shift);
}
