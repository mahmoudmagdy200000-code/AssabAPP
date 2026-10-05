import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/reassignment_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/sales_breakdown_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/handover_status_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/handover_to_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_cashier_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_info_details_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/shift_details_model.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/shift/shift_entity.dart';
import '../../../domain/entity/shift/shift_time_details_entity.dart';
import '../../model/shift/shift_model.dart';

extension ShiftModelMapper on ShiftModel {
  ShiftEntity toEntity() {
    return ShiftEntity(
      id: id,
      shiftDate: shiftDate,
      shiftDateFormatted: formattedDate(shiftDate),
      shiftInfoDetails: shift.toEntity(),
      shiftTimeDetails: ShiftTimeDetailsEntity(
        startTime: shift.startTime,
        endTime: shift.endTime,
      ),
      openingBalance: openingBalance ?? 0,
      closingBalance: closingBalance ?? 0,
      vatAmount: vatAmount ?? 0,
      cashCollected: cashCollected ?? 0,
      totalSales: totalSales ?? 0,
      cardPayment: cardPayments ?? 0,
      variance: variance,
      status: status,
      cashier: cashier.toEntity(),
      handedOverAt: handedOverAt,
      nextCashier: nextCashier?.toEntity(),
      reassignment: reassignment?.toEntity(),
      handoverAmount: 0,
    );
  }
}

extension ShiftDetailsModelMapper on ShiftDetailsModel {
  ShiftEntity toEntity() {
    return ShiftEntity(
      id: id,
      shiftDate: shiftDate,
      shiftDateFormatted: formattedDate(shiftDate),
      shiftTimeDetails: ShiftTimeDetailsEntity(
        startTime: shiftInfoDetails.startTime,
        endTime: shiftInfoDetails.endTime,
      ),
      shiftInfoDetails: shiftInfoDetails.toEntity(),
      openingBalance: openingBalance?.toDouble() ?? 0,
      closingBalance: closingBalance?.toDouble() ?? 0,
      vatAmount: vatAmount?.toDouble() ?? 0,
      cashCollected: cashCollected?.toDouble() ?? 0,
      handoverStatus: handoverStatus?.toEntity(),
      handoverTo: handoverTo?.toEntity(),
      status: status,
      totalSales: totalSales?.toDouble() ?? 0,
      netSales: netSales?.toDouble() ?? 0,
      cashier: cashier.toEntity(),
      nextCashier: nextCashier?.toEntity(),
      reassignment: reassignment?.toEntity(),
      variance: variance,
      handedOverAt: handedOverAt,
      actualEndTime: actualEndTime,
      actualStartTime: actualStartTime,
      handoverNotes: handoverNotes,
      handoverAmount: handoverAmount?.toDouble() ?? 0,
      canBeAccepted: canBeAccepted,
      isShiftReassignedToMe: isShiftReassignedToMe,
      previousCashier: previousCashier,
      reassignedBy: reassignment?.reassignedBy?.name,
      reassignedTo: reassignment?.reassignedTo?.name,
      reassignedFrom: reassignment?.reassignedFrom?.name,
      expectedBalance: expectedBalance?.toDouble() ?? 0,
      reassignReason: reassignReason,
      varianceReason: varianceReason,
      cashGiven: cashGiven?.toDouble() ?? 0,
      isMidReassign: isMidReassign,
      cardPayment: cardPayments?.toDouble() ?? 0,
      deliveryApps:
          aggregators
              ?.map((e) => e.toEntity())
              .fold(0.0, (sum, item) => (sum ?? 0) + item.amount) ??
          0,
    );
  }
}

String formattedDate(String shiftDate, [String locale = 'en']) {
  final parsedDate = DateTime.tryParse(shiftDate);
  if (parsedDate == null) return shiftDate;
  final formatter = DateFormat('d MMM, yyyy', locale);
  return formatter.format(parsedDate);
}
