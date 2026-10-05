// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_time_stamps.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftTimestamps _$ShiftTimestampsFromJson(Map<String, dynamic> json) =>
    ShiftTimestamps(
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      dailyReportSubmittedAt: json['daily_report_submitted_at'] as String?,
      reopenedAt: json['reopened_at'] as String?,
      approvedAt: json['approved_at'] as String?,
      archivedAt: json['archived_at'] as String?,
    );

Map<String, dynamic> _$ShiftTimestampsToJson(ShiftTimestamps instance) =>
    <String, dynamic>{
      'actual_start_time': instance.actualStartTime,
      'actual_end_time': instance.actualEndTime,
      'daily_report_submitted_at': instance.dailyReportSubmittedAt,
      'reopened_at': instance.reopenedAt,
      'approved_at': instance.approvedAt,
      'archived_at': instance.archivedAt,
    };
