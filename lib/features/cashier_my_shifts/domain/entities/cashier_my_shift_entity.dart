import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_handover_status_entity.dart';
import 'package:intl/intl.dart';

import '../enums/my_shifts_status.dart';
import 'cashier_reassign_user_type_entity.dart';

class CashierShiftEntity {
  final String id;
  final DateTime date;
  final MyShiftStatusType status;
  final String startTime;
  final String endTime;
  final int? openingBalance;
  final int? closingBalance;
  final String? nextCashier;
  final CashierUserObjectEntity? assignedTo;
  final bool? isNextShift;
  final int? variance;
  final int? cashGiven;
  final bool canBeAccepted;
  final String? approvedOrRejectedBy;
  final CashierUserObjectEntity? handoverTo;
  final CashierUserObjectEntity? cashFrom;
  final CashierUserObjectEntity? reassignedTo;
  final CashierUserObjectEntity? reassignedFrom;
  final CashierUserObjectEntity? reassignedBy;
  final bool? isMidReassign;
  final CashierHandoverStatusEntity? handoverStatus;

  const CashierShiftEntity({
    required this.id,
    required this.date,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.canBeAccepted = false,
    this.handoverStatus,
    this.approvedOrRejectedBy,
    this.isMidReassign,
    this.reassignedTo,
    this.reassignedFrom,
    this.reassignedBy,
    this.openingBalance,
    this.isNextShift,
    this.closingBalance,
    this.cashFrom,
    this.handoverTo,
    this.nextCashier,
    this.variance,
    this.cashGiven,
    this.assignedTo,
  });

  bool get hasEnded {
    if (endTime.isEmpty) return false;

    try {
      final now = DateTime.now();
      final shiftDateObj = DateFormat('yyyy-MM-dd').parse(date.toString());

      // If shift is in the past, it has ended
      if (shiftDateObj.isBefore(now)) return true;

      // If shift is in the future, it hasn't ended
      if (shiftDateObj.isAfter(now)) return false;

      // If shift is today, check end time
      final end = DateFormat('HH:mm').parse(endTime);
      final endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        end.hour,
        end.minute,
      );
      return now.isAfter(endDateTime);
    } catch (_) {
      return false;
    }
  }
}
