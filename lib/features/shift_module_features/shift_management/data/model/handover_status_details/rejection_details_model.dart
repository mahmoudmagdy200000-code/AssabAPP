import 'package:json_annotation/json_annotation.dart';

part 'rejection_details_model.g.dart';

@JsonSerializable()
class RejectionDetailsModel {
  @JsonKey(name: 'rejection_reason')
  final String rejectionReason;

  @JsonKey(name: 'rejection_count')
  final int rejectionCount;

  @JsonKey(name: 'first_rejected_at')
  final String firstRejectedAt;

  @JsonKey(name: 'second_rejected_at')
  final String? secondRejectedAt;

  @JsonKey(name: 'is_permanently_rejected')
  final bool isPermanentlyRejected;

  @JsonKey(name: 'can_cashier_edit')
  final bool canCashierEdit;

  @JsonKey(name: 'rejection_files')
  final List<String> rejectionFiles;

  RejectionDetailsModel({
    required this.rejectionReason,
    required this.rejectionCount,
    required this.firstRejectedAt,
    this.secondRejectedAt,
    required this.isPermanentlyRejected,
    required this.canCashierEdit,
    required this.rejectionFiles,
  });

  factory RejectionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RejectionDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RejectionDetailsModelToJson(this);
}
