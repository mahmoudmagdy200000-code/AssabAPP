import 'package:json_annotation/json_annotation.dart';

part 'hand_over_request.g.dart';

@JsonSerializable()
class HandOverRequest {
  @JsonKey(name: 'handover_to_type')
  final String handoverType;

  @JsonKey(name: 'next_cashier_id')
  final String? nextCashierId;

  @JsonKey(name: 'branch_manager_id')
  final String? branchManagerId;

  @JsonKey(name: 'handover_amount')
  final double handOverAmount;

  @JsonKey(name: 'handover_notes')
  final String? handoverNotes;

  HandOverRequest({
    required this.handoverType,
    required this.handOverAmount,
    this.nextCashierId,
    this.branchManagerId,
    this.handoverNotes,
  });

  // JSON serialization
  factory HandOverRequest.fromJson(Map<String, dynamic> json) =>
      _$HandOverRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HandOverRequestToJson(this);
}
