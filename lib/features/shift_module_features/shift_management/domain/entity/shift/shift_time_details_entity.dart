import 'package:intl/intl.dart';

class ShiftTimeDetailsEntity {
  final String startTime;
  final String endTime;

  ShiftTimeDetailsEntity({required this.startTime, required this.endTime});
}

extension ShiftTimeFormatter on ShiftTimeDetailsEntity {
  String get formattedStartTime => _formatTime(startTime);
  String get formattedEndTime => _formatTime(endTime);

  static String _formatTime(String time) {
    try {
      final date = DateFormat('HH:mm').parse(time);
      return DateFormat('hh:mm a').format(date);
    } catch (_) {
      return time;
    }
  }
}
