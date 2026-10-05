import 'package:json_annotation/json_annotation.dart';

part 'available_actions.g.dart';

@JsonSerializable()
class AvailableActions {
  @JsonKey(name: 'can_start')
  final bool canStart;

  @JsonKey(name: 'can_end')
  final bool canEnd;

  @JsonKey(name: 'can_submit_daily_report')
  final bool canSubmitDailyReport;

  @JsonKey(name: 'can_reopen')
  final bool canReopen;

  @JsonKey(name: 'can_approve_handovers')
  final bool canApproveHandovers;

  @JsonKey(name: 'can_reject_handovers')
  final bool canRejectHandovers;

  AvailableActions({
    required this.canStart,
    required this.canEnd,
    required this.canSubmitDailyReport,
    required this.canReopen,
    required this.canApproveHandovers,
    required this.canRejectHandovers,
  });

  factory AvailableActions.fromJson(Map<String, dynamic> json) =>
      _$AvailableActionsFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableActionsToJson(this);
}
