import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_to_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_info_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/vaiance_details_entity.dart';
import 'package:intl/intl.dart';

import 'assigned_by_entity.dart';
import 'handover_entity.dart';
import 'reassignment_entity.dart';

class ShiftEntity {
  final String id;
  final String shiftDateFormatted;
  final String shiftDate;
  final ShiftTimeDetailsEntity shiftTimeDetails;
  final ShiftInfoDetailsEntity? shiftInfoDetails;
  final double? openingBalance;
  final double? closingBalance;
  final double? expectedBalance;
  final double? variance;
  // final double? variance;
  final HandoverToEntity? handoverTo;
  final double? totalSales;
  final double? netSales;
  final double? vatAmount;
  final double? cashCollected;
  final double? cardPayment;
  final double? deliveryApps;
  final double? cashGiven;
  final String? actualStartTime;
  final String? actualEndTime;
  final String? reassignReason;
  final String? varianceReason;
  final bool? isMidReassign;
  final bool? canBeAccepted;
  final bool? isShiftReassignedToMe;
  final String? previousCashier;
  final String? reassignedBy;
  final String? reassignedTo;
  final String? reassignedFrom;
  final String? reassignedAt;
  final String? handedOverAt;
  final String? handoverNotes;
  final double? handoverAmount;
  final HandoverStatusEntity? handoverStatus;
  final ShiftCashierEntity cashier;
  final ShiftCashierEntity? nextCashier;
  final ReassignmentEntity? reassignment;
  final ShiftStatusType status;
  final List<VarianceDetailsEntity>? varianceDetails;
  final AssignedByEntity? assignedBy;

  ShiftEntity({
    required this.id,
    required this.shiftDateFormatted,
    required this.shiftTimeDetails,
    required this.openingBalance,
    required this.closingBalance,
    required this.vatAmount,
    required this.cashCollected,
    required this.status,
    required this.cashier,
    required this.shiftDate,
    this.cashGiven,
    this.reassignReason,
    this.varianceReason,
    this.isMidReassign,
    this.canBeAccepted,
    this.isShiftReassignedToMe,
    this.previousCashier,
    this.reassignedBy,
    this.reassignedTo,
    this.reassignedFrom,
    this.reassignedAt,
    this.shiftInfoDetails,
    this.assignedBy,
    this.handoverTo,
    this.nextCashier,
    this.reassignment,
    this.cardPayment = 0,
    this.deliveryApps = 0,
    this.totalSales = 0,
    required this.handoverAmount,
    this.handoverStatus,
    this.handedOverAt,
    this.handoverNotes,
    this.expectedBalance,
    this.variance,
    this.netSales,
    this.actualStartTime,
    this.actualEndTime,
    this.varianceDetails,
  });

  String get formattedHandedOverDateTime {
    if (handedOverAt == null) return '—';

    final dt = DateTime.tryParse(handedOverAt!.replaceAll(' ', 'T'));
    if (dt == null) return handedOverAt!;

    return DateFormat('MMM d, yyyy – h:mm a').format(dt);
  }

  bool get hasStarted {
    if (shiftTimeDetails.startTime.isEmpty) return false;

    try {
      final now = DateTime.now();
      final shiftDateObj = DateFormat('yyyy-MM-dd').parse(shiftDate);

      // If shift is in the future, hasn't started
      if (shiftDateObj.isAfter(now)) return false;

      // If shift is in the past, it has started
      if (shiftDateObj.isBefore(now)) return true;

      // If shift is today, check start time
      final start = DateFormat('HH:mm').parse(shiftTimeDetails.startTime);
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        start.hour,
        start.minute,
      );
      return now.isAfter(startDateTime);
    } catch (_) {
      return false;
    }
  }

  bool get hasEnded {
    if (shiftTimeDetails.endTime.isEmpty) return false;

    try {
      final now = DateTime.now();
      final shiftDateObj = DateFormat('yyyy-MM-dd').parse(shiftDate);

      // If shift is in the past, it has ended
      if (shiftDateObj.isBefore(now)) return true;

      // If shift is in the future, it hasn't ended
      if (shiftDateObj.isAfter(now)) return false;

      // If shift is today, check end time
      final end = DateFormat('HH:mm').parse(shiftTimeDetails.endTime);
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

  factory ShiftEntity.empty() {
    return ShiftEntity(
      id: ' ',
      shiftDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      shiftDateFormatted: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      shiftTimeDetails: ShiftTimeDetailsEntity(startTime: '', endTime: ''),
      openingBalance: 0.0,
      closingBalance: 0.0,
      vatAmount: 0.0,
      cashCollected: 0.0,
      status: ShiftStatusType.pending,
      cashier: ShiftCashierEntity(id: '', name: ''),
      nextCashier: null,
      reassignment: null,
      cardPayment: 0,
      deliveryApps: 0,
      totalSales: 0,
      handoverStatus: null,
      handoverAmount: 0,
    );
  }
}
