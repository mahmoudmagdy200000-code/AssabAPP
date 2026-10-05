// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableActions _$AvailableActionsFromJson(Map<String, dynamic> json) =>
    AvailableActions(
      canStart: json['can_start'] as bool,
      canEnd: json['can_end'] as bool,
      canSubmitDailyReport: json['can_submit_daily_report'] as bool,
      canReopen: json['can_reopen'] as bool,
      canApproveHandovers: json['can_approve_handovers'] as bool,
      canRejectHandovers: json['can_reject_handovers'] as bool,
    );

Map<String, dynamic> _$AvailableActionsToJson(AvailableActions instance) =>
    <String, dynamic>{
      'can_start': instance.canStart,
      'can_end': instance.canEnd,
      'can_submit_daily_report': instance.canSubmitDailyReport,
      'can_reopen': instance.canReopen,
      'can_approve_handovers': instance.canApproveHandovers,
      'can_reject_handovers': instance.canRejectHandovers,
    };
