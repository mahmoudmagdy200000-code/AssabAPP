import 'package:intl/intl.dart';

class ProgressEntity {
  final String title;
  final String description;
  final String status;
  final String? startTime;
  final String? endTime;
  final num progressPercentage;

  ProgressEntity({
    required this.title,
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.progressPercentage,
  });

  bool hasEnded({required String shiftDate}) {
    if (endTime?.isNotEmpty != true) return false;

    try {
      final now = DateTime.now();
      final shiftDateObj = DateFormat('yyyy-MM-dd').parse(shiftDate);

      // If shift is in the past, it has ended
      if (shiftDateObj.isBefore(now)) return true;

      // If shift is in the future, it hasn't ended
      if (shiftDateObj.isAfter(now)) return false;

      // If shift is today, check end time
      final end = DateFormat('HH:mm').parse(endTime!);
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

extension ShiftTimeFormatter on ProgressEntity {
  String? get formattedStartTime =>
      startTime != null ? _formatTime(startTime!) : null;
  String? get formattedEndTime =>
      endTime != null ? _formatTime(endTime!) : null;

  static String _formatTime(String time) {
    try {
      final date = DateFormat('HH:mm').parse(time);
      return DateFormat('hh:mm a').format(date);
    } catch (_) {
      return time;
    }
  }
}
