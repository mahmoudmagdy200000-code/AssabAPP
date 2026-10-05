import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

@JsonSerializable()
class WorkShift {
  final String name;
  final String timeFrom;
  final String timeTo;
  final bool isEnabled;

  WorkShift({
    required this.name,
    required this.timeFrom,
    required this.timeTo,
    this.isEnabled = true,
  });

  factory WorkShift.fromJson(Map<String, dynamic> json) =>
      _$WorkShiftFromJson(json);

  Map<String, dynamic> toJson() => _$WorkShiftToJson(this);
}

@JsonSerializable()
class DayShifts {
  final String day;
  final List<WorkShift> shifts;

  DayShifts({required this.day, required this.shifts});

  factory DayShifts.fromJson(Map<String, dynamic> json) =>
      _$DayShiftsFromJson(json);

  Map<String, dynamic> toJson() => _$DayShiftsToJson(this);
}
