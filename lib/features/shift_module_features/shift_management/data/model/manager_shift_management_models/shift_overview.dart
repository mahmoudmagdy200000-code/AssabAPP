import '../../../../../../core/enums/shift_status/shift_status_type.dart';

class ShiftOverview {
  final String title;
  final String description;
  final ShiftStatusType status;
  final String startTime;
  final String endTime;
  final int elapsedHours;
  final int progressPercentage;
  final bool canStart;
  final bool canEnd;

  ShiftOverview({
    required this.title,
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.elapsedHours,
    required this.progressPercentage,
    required this.canStart,
    required this.canEnd,
  });

  factory ShiftOverview.fromJson(Map<String, dynamic> json) => ShiftOverview(
    title: json['title'] as String,
    description: json['description'] as String,
    status: ShiftStatusType.fromString(json['status'] as String),
    startTime: json['start_time'] as String,
    endTime: json['end_time'] as String,
    elapsedHours: (json['elapsed_hours'] as num).toInt(),
    progressPercentage: (json['progress_percentage'] as num).toInt(),
    canStart: json['can_start'] as bool,
    canEnd: json['can_end'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'status': status.value,
    'start_time': startTime,
    'end_time': endTime,
    'elapsed_hours': elapsedHours,
    'progress_percentage': progressPercentage,
    'can_start': canStart,
    'can_end': canEnd,
  };
}
