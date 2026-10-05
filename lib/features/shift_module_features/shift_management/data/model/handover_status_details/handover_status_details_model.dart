import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/handover_status_details/rejection_details_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../manager_shift_management_models/cashier_handover_models/correction_details_model.dart';

part 'handover_status_details_model.g.dart';

@JsonSerializable()
class HandoverStatusDetailsModel {
  final HandoverStatus status;

  @JsonKey(name: 'handover_time')
  final String handoverTime;

  @JsonKey(name: 'handed_over_at')
  final String handedOverAt;

  @JsonKey(name: 'reviewed_by')
  final String? rejectionReviewedBy;

  @JsonKey(name: 'rejection_details')
  final RejectionDetailsModel? rejectionDetails;

  @JsonKey(name: 'manager_comment')
  final String? managerComment;

  @JsonKey(name: 'was_edited_after_rejection')
  final bool wasEditedAfterRejection;

  @JsonKey(name: 'edited_at')
  final String? editedAt;

  @JsonKey(name: 'correction_details')
  final CorrectionDetailsModel? correctionDetails;

  HandoverStatusDetailsModel({
    required this.status,
    required this.handoverTime,
    required this.handedOverAt,
    required this.rejectionReviewedBy,
    required this.rejectionDetails,
    required this.managerComment,
    required this.wasEditedAfterRejection,
    this.editedAt,
    required this.correctionDetails,
  });

  factory HandoverStatusDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverStatusDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverStatusDetailsModelToJson(this);
}
