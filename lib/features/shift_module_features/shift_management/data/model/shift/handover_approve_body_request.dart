import 'package:json_annotation/json_annotation.dart';

part 'handover_approve_body_request.g.dart';

@JsonSerializable(includeIfNull: false)
class HandoverApproveAndRejectBodyRequest {
  @JsonKey(name: 'confirmed_amount')
  final String? confirmedAmount;

  @JsonKey(name: 'manager_comment')
  final String? managerComment;

  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  @JsonKey(name: 'correction_reason')
  final String? correctionReason;

  @JsonKey(name: 'transfer_attempt_id')
  final String? transferAttemptId;

  @JsonKey(name: 'receiving_shift_id')
  final String? receivingShiftId;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'decision')
  final String? decision;

  const HandoverApproveAndRejectBodyRequest({
    this.confirmedAmount,
    this.managerComment,
    this.rejectionReason,
    this.correctionReason,
    this.transferAttemptId,
    this.receivingShiftId,
    this.comment,
    this.decision,
  });

  factory HandoverApproveAndRejectBodyRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$HandoverApproveAndRejectBodyRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HandoverApproveAndRejectBodyRequestToJson(this);
}