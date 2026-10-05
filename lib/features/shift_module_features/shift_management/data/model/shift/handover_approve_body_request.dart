import 'package:json_annotation/json_annotation.dart';

part 'handover_approve_body_request.g.dart';

@JsonSerializable()
class HandoverApproveAndRejectBodyRequest {
  @JsonKey(name: 'manager_comment')
  final String? managerComment;

  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  @JsonKey(name: 'decision')
  final String? decision;

  const HandoverApproveAndRejectBodyRequest({
    this.managerComment,
    this.rejectionReason,
    this.decision,
  });

  Map<String, dynamic> toJson() =>
      _$HandoverApproveAndRejectBodyRequestToJson(this);
}
