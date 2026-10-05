import 'package:assab/features/cashier_my_shifts/data/mapper/handover_to_mapper.dart';

import '../../../domain/entities/cashier_my_shift_entity.dart';
import '../../model/shifts_models/pending/cashier_pending_shift_model.dart';

extension CashierPendingShiftMapper on CashierPendingShiftModel {
  CashierShiftEntity toEntity() {
    return CashierShiftEntity(
      id: id,
      date: DateTime.parse(date),
      status: status,
      startTime: startTime,
      endTime: endTime,
      openingBalance: openingBalance,
      nextCashier: nextCashier,
      isNextShift: isNextShift,
      handoverTo: handoverTo?.toEntity(),
      variance: variance,
      cashGiven: cashGiven,
      cashFrom: cashFrom?.toEntity(),
    );
  }
}
