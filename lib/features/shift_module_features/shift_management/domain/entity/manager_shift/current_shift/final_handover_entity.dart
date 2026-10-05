import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_handover.dart';
import 'package:intl/intl.dart';

import '../../../enums/manager_shift/end_shift_handover_timing.dart';

class FinalHandoverEntity {
  final int handoverAmount;
  final FinalHandOverStatus status;
  final String handoverFrom;
  final String handoverTo;
  final String handoverDate;
  final String handoverTime;
  final String currentTime;
  final HandoverTiming currentTimeSetting;
  final String? handoverNotes;
  final int openingBalance;
  final int closingBalance;
  final int expectedBalance;
  final int variance;
  final String varianceType;
  final int lastDeposit;
  final int pettyCash;

  FinalHandoverEntity({
    required this.handoverAmount,
    required this.status,
    required this.handoverFrom,
    required this.handoverTo,
    required this.handoverDate,
    required this.handoverTime,
    required this.currentTime,
    required this.currentTimeSetting,
    required this.handoverNotes,
    required this.openingBalance,
    required this.closingBalance,
    required this.expectedBalance,
    required this.variance,
    required this.varianceType,
    required this.lastDeposit,
    required this.pettyCash,
  });

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
