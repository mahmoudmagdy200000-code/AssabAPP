import 'package:intl/intl.dart';

class FinalHandoverEndShiftEntity {
  final double handoverAmount;
  final String status;
  final String handoverFrom;
  final String handoverTo;
  final String handoverDate;
  final String handoverTime;
  final String? handoverNotes;

  const FinalHandoverEndShiftEntity({
    required this.handoverAmount,
    required this.status,
    required this.handoverFrom,
    required this.handoverTo,
    required this.handoverDate,
    required this.handoverTime,
    this.handoverNotes,
  });

  String get formattedHandoverDate {
    try {
      final date = DateTime.parse(handoverDate);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return handoverDate;
    }
  }

  /// Returns only formatted time, e.g., "22:26"
  String get formattedHandoverTime {
    try {
      final parts = handoverTime.split(':'); // ["22","26","37"]
      if (parts.length >= 2) {
        final dateTime = DateTime(
          0,
          1,
          1,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
        return DateFormat('hh:mm a').format(dateTime); // "10:26 PM"
      }
      return handoverTime;
    } catch (_) {
      return handoverTime;
    }
  }
}
