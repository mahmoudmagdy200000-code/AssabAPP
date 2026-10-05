// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_approve_body_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverApproveAndRejectBodyRequest
_$HandoverApproveAndRejectBodyRequestFromJson(Map<String, dynamic> json) =>
    HandoverApproveAndRejectBodyRequest(
      managerComment: json['manager_comment'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      decision: json['decision'] as String?,
    );

Map<String, dynamic> _$HandoverApproveAndRejectBodyRequestToJson(
  HandoverApproveAndRejectBodyRequest instance,
) => <String, dynamic>{
  'manager_comment': instance.managerComment,
  'rejection_reason': instance.rejectionReason,
  'decision': instance.decision,
};
