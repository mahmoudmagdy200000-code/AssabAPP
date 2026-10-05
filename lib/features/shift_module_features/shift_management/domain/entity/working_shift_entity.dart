import 'package:intl/intl.dart';

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
      DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(startTime));

  String get endTimeAmPm =>
      DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(endTime));
}
