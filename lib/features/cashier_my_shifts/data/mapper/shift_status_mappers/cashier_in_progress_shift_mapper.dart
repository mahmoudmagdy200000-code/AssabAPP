import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/in_progress/cashier_in_progress_shift_model.dart';

import '../../../domain/entities/cashier_my_shift_entity.dart';

extension CashierInProgressShiftMapper on CashierInProgressShiftModel {
  CashierShiftEntity toEntity() {
    return CashierShiftEntity(
      id: id,
      date: DateTime.parse(date),
      status: status,
      startTime: startTime,
      endTime: endTime,
      closingBalance: closingBalance ?? 0,
      openingBalance: openingBalance ?? 0,
      nextCashier: nextCashier,
      isNextShift: false,
    );
  }
}
