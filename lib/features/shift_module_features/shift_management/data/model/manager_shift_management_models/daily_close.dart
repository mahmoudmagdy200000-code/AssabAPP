import 'package:json_annotation/json_annotation.dart';

part 'daily_close.g.dart';

@JsonSerializable()
class DailyClose {
  @JsonKey(name: 'is_submitted')
  final bool isSubmitted;

  @JsonKey(name: 'submitted_at')
  final String? submittedAt;

  final String? notes;

  @JsonKey(name: 'can_reopen')
  final bool canReopen;

  @JsonKey(name: 'reopened_at')
  final String? reopenedAt;

  @JsonKey(name: 'reopen_reason')
  final String? reopenReason;

  @JsonKey(name: 'is_archived')
  final bool isArchived;

  @JsonKey(name: 'archived_at')
  final String? archivedAt;

  @JsonKey(name: 'approved_by')
  final String? approvedBy;

  @JsonKey(name: 'approved_at')
  final String? approvedAt;

  DailyClose({
    required this.isSubmitted,
    this.submittedAt,
    this.notes,
    required this.canReopen,
    this.reopenedAt,
    this.reopenReason,
    required this.isArchived,
    this.archivedAt,
    this.approvedBy,
    this.approvedAt,
  });

  factory DailyClose.fromJson(Map<String, dynamic> json) =>
      _$DailyCloseFromJson(json);

  Map<String, dynamic> toJson() => _$DailyCloseToJson(this);
}
