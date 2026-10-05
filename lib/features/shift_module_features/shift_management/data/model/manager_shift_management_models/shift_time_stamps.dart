import 'package:json_annotation/json_annotation.dart';

part 'shift_time_stamps.g.dart';

@JsonSerializable()
class ShiftTimestamps {
  @JsonKey(name: 'actual_start_time')
  final String? actualStartTime;

  @JsonKey(name: 'actual_end_time')
  final String? actualEndTime;

  @JsonKey(name: 'daily_report_submitted_at')
  final String? dailyReportSubmittedAt;

  @JsonKey(name: 'reopened_at')
  final String? reopenedAt;

  @JsonKey(name: 'approved_at')
  final String? approvedAt;

  @JsonKey(name: 'archived_at')
  final String? archivedAt;

  ShiftTimestamps({
    this.actualStartTime,
    this.actualEndTime,
    this.dailyReportSubmittedAt,
    this.reopenedAt,
    this.approvedAt,
    this.archivedAt,
  });

  factory ShiftTimestamps.fromJson(Map<String, dynamic> json) =>
      _$ShiftTimestampsFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftTimestampsToJson(this);
}
