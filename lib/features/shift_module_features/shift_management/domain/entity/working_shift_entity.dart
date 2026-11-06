import 'package:assab/core/utils/shift_time_formatter.dart';

class WorkingShiftEntity {
  final String id;
  final String name;
  final String startTime;
  final String endTime;

  const WorkingShiftEntity({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  String get startTimeAmPm =>
      ShiftTimeFormatter.format(startTime, fallback: startTime);

  String get endTimeAmPm =>
      ShiftTimeFormatter.format(endTime, fallback: endTime);
}
