import 'package:assab/core/utils/shift_time_formatter.dart';

class ShiftTimeDetailsEntity {
  final String startTime;
  final String endTime;

  ShiftTimeDetailsEntity({required this.startTime, required this.endTime});
}

extension ShiftTimeDetailsFormatter on ShiftTimeDetailsEntity {
  String get formattedStartTime => _formatTime(startTime);
  String get formattedEndTime => _formatTime(endTime);

  static String _formatTime(String time) => ShiftTimeFormatter.format(time, fallback: time);
}
