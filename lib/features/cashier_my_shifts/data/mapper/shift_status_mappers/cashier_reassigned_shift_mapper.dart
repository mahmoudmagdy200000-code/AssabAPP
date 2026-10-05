import 'package:assab/features/cashier_my_shifts/data/mapper/cashier_reassign_user_mapper.dart';

import '../../../domain/entities/cashier_my_shift_entity.dart';
import '../../model/shifts_models/reassigned/cashier_reassigned_shift_model.dart';

extension CashierReassignedShiftMapper on CashierReassignedShiftModel {
  CashierShiftEntity toEntity() {
    return CashierShiftEntity(
      id: id,
      date: DateTime.parse(shiftDate),
      status: status,
      reassignedTo: reassignedTo.toEntity(),
      isMidReassign: isMidReassign,
      startTime: startTime,
      endTime: endTime,
      reassignedFrom: reassignedFrom.toEntity(),
      reassignedBy: reassignedBy.toEntity(),
      nextCashier: nextCashier,
      variance: variance,
      cashGiven: cashGiven,
      canBeAccepted: canBeAccepted,
    );
  }
}
