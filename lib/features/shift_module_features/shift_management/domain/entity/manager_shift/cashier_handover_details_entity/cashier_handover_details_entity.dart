import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/cashier_handover_details_entity/correction_details_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';

class CashierHandoverDetailsEntity {
  final double totalSales;
  final double cashCollected;
  final double cardPayments;
  final double deliveryAppPayments;
  final double varianceAmount;
  final double handoverAmount;
  final String handoverFrom;
  final String handoverTo;
  final String handoverDate;
  final String handoverTime;
  final String? approvedAt;
  final HandoverStatus handoverStatus;
  final CorrectionDetailsEntity? correctionDetails;

  CashierHandoverDetailsEntity({
    required this.totalSales,
    required this.cashCollected,
    required this.cardPayments,
    required this.deliveryAppPayments,
    required this.varianceAmount,
    required this.handoverAmount,
    required this.handoverFrom,
    required this.handoverTo,
    required this.handoverDate,
    required this.handoverTime,
    required this.correctionDetails,
    required this.handoverStatus,
    required this.approvedAt,
  });

  String get formattedHandoverDateTime {
    if (approvedAt == null) return '-';

    try {
      final dateTime = DateTime.parse(approvedAt!);
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
