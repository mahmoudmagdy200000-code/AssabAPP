import 'package:assab/features/cashier_my_shifts/data/mapper/cashier_handover_status_mapper.dart';

import '../../../domain/entities/cashier_my_shift_entity.dart';
import '../../model/shifts_models/completed/cashier_completed_shift_model.dart';
import '../handover_to_mapper.dart';

extension CashierCompletedShiftMapper on CashierCompletedShiftModel {
  CashierShiftEntity toEntity() {
    return CashierShiftEntity(
      id: id,
      date: DateTime.parse(shiftDate),
      status: status,
      startTime: startTime,
      endTime: endTime,
      variance: variance,
      handoverTo: handoverTo?.toEntity(),
      approvedOrRejectedBy: handoverApprovedOrRejectedBy?.name ?? '-',
      closingBalance: closingBalance,
      nextCashier: nextCashier?.name,
      handoverStatus: handoverStatus?.toEntity(),
      assignedTo: assignedTo?.toEntity(),
    );
  }
}
