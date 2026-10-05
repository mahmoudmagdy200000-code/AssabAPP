import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/variance_details.dart';
import 'package:intl/intl.dart';

class HandoverDetailsEntity {
  final String handoverId;
  final String cashierShiftId;
  final String cashierName;
  final double handoverAmount;
  final String handoverDate;
  final String handoverTime;
  final String approvedAt;
  final String handoverFrom;
  final String handoverTo;
  final double varianceAmount;
  final double totalSales;
  final String? handoverNotes;
  final HandoverStatus handoverStatus;
  final VarianceType? varianceType;
  final String? varianceReason;

  HandoverDetailsEntity({
    required this.handoverId,
    required this.cashierShiftId,
    required this.cashierName,
    required this.handoverAmount,
    required this.handoverDate,
    required this.approvedAt,
    required this.handoverTime,
    required this.handoverFrom,
    required this.handoverTo,
    required this.varianceAmount,
    required this.totalSales,
    required this.handoverNotes,
    this.varianceType,
    this.varianceReason,
    required this.handoverStatus,
  });

  String get formattedHandoverDateTime {
    try {
      final dateTime = DateTime.parse(approvedAt);
      final datePart = DateFormat('MMMM d').format(dateTime);
      final suffix = _daySuffix(dateTime.day);
      final yearTime = DateFormat('yyyy - h:mm a').format(dateTime);
      return '$datePart$suffix, $yearTime';
    } catch (_) {
      return '-';
    }
  }

  String get formattedHandoverDate {
    try {
      final dateTime = DateTime.parse(handoverDate);
      return DateFormat('MMMM d, yyyy').format(dateTime);
    } catch (_) {
      return '-';
    }
  }

  String get formattedHandoverTime {
    try {
      final combined = '$handoverDate $handoverTime';
      final dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(combined);

      return DateFormat('h:mm a').format(dateTime); // 12-hour format with AM/PM
    } catch (e) {
      print('Error parsing time: $e');
      return '-';
    }
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
