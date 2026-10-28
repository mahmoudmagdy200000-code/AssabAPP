// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_approve_body_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverApproveAndRejectBodyRequest
_$HandoverApproveAndRejectBodyRequestFromJson(Map<String, dynamic> json) =>
    HandoverApproveAndRejectBodyRequest(
      confirmedAmount: json['confirmed_amount'] as String?,
      managerComment: json['manager_comment'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      correctionReason: json['correction_reason'] as String?,
      transferAttemptId: json['transfer_attempt_id'] as String?,
      receivingShiftId: json['receiving_shift_id'] as String?,
      comment: json['comment'] as String?,
      decision: json['decision'] as String?,
    );

Map<String, dynamic> _$HandoverApproveAndRejectBodyRequestToJson(
  HandoverApproveAndRejectBodyRequest instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('confirmed_amount', instance.confirmedAmount);
  writeNotNull('manager_comment', instance.managerComment);
  writeNotNull('rejection_reason', instance.rejectionReason);
  writeNotNull('correction_reason', instance.correctionReason);
  writeNotNull('transfer_attempt_id', instance.transferAttemptId);
  writeNotNull('receiving_shift_id', instance.receivingShiftId);
  writeNotNull('comment', instance.comment);
  writeNotNull('decision', instance.decision);
  return val;
}