import 'package:json_annotation/json_annotation.dart';

part 'correction_details_model.g.dart';

@JsonSerializable()
class CorrectionDetailsModel {
  @JsonKey(name: 'requested_by')
  final String requestedBy;

  @JsonKey(name: 'requested_by_id')
  final String requestedById;

  @JsonKey(name: 'requested_by_type')
  final String requestedByType;

  @JsonKey(name: 'manager_comment')
  final String managerComment;

  @JsonKey(name: 'requested_at')
  final String requestedAt;

  @JsonKey(name: 'can_cashier_edit')
  final bool canCashierEdit;

  CorrectionDetailsModel({
    required this.requestedBy,
    required this.requestedById,
    required this.requestedByType,
    required this.managerComment,
    required this.requestedAt,
    required this.canCashierEdit,
  });

  factory CorrectionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CorrectionDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CorrectionDetailsModelToJson(this);
}
