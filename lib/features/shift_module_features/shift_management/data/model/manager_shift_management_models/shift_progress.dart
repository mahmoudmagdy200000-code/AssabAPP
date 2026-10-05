import 'package:json_annotation/json_annotation.dart';

part 'shift_progress.g.dart';

@JsonSerializable()
class ShiftProgress {
  final String title;
  final String description;
  final String status;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'number_of_hours')
  final int numberOfHours;

  @JsonKey(name: 'progress_percentage')
  final int progressPercentage;

  ShiftProgress({
    required this.title,
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.numberOfHours,
    required this.progressPercentage,
  });

  factory ShiftProgress.fromJson(Map<String, dynamic> json) =>
      _$ShiftProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftProgressToJson(this);
}
