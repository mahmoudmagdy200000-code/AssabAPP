// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_close.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyClose _$DailyCloseFromJson(Map<String, dynamic> json) => DailyClose(
  isSubmitted: json['is_submitted'] as bool,
  submittedAt: json['submitted_at'] as String?,
  notes: json['notes'] as String?,
  canReopen: json['can_reopen'] as bool,
  reopenedAt: json['reopened_at'] as String?,
  reopenReason: json['reopen_reason'] as String?,
  isArchived: json['is_archived'] as bool,
  archivedAt: json['archived_at'] as String?,
  approvedBy: json['approved_by'] as String?,
  approvedAt: json['approved_at'] as String?,
);

Map<String, dynamic> _$DailyCloseToJson(DailyClose instance) =>
    <String, dynamic>{
      'is_submitted': instance.isSubmitted,
      'submitted_at': instance.submittedAt,
      'notes': instance.notes,
      'can_reopen': instance.canReopen,
      'reopened_at': instance.reopenedAt,
      'reopen_reason': instance.reopenReason,
      'is_archived': instance.isArchived,
      'archived_at': instance.archivedAt,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt,
    };
