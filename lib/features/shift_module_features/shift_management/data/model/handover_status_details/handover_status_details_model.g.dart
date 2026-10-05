// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_status_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverStatusDetailsModel _$HandoverStatusDetailsModelFromJson(
  Map<String, dynamic> json,
) => HandoverStatusDetailsModel(
  status: $enumDecode(_$HandoverStatusEnumMap, json['status']),
  handoverTime: json['handover_time'] as String,
  handedOverAt: json['handed_over_at'] as String,
  rejectionReviewedBy: json['reviewed_by'] as String?,
  rejectionDetails: json['rejection_details'] == null
      ? null
      : RejectionDetailsModel.fromJson(
          json['rejection_details'] as Map<String, dynamic>,
        ),
  managerComment: json['manager_comment'] as String?,
  wasEditedAfterRejection: json['was_edited_after_rejection'] as bool,
  editedAt: json['edited_at'] as String?,
  correctionDetails: json['correction_details'] == null
      ? null
      : CorrectionDetailsModel.fromJson(
          json['correction_details'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$HandoverStatusDetailsModelToJson(
  HandoverStatusDetailsModel instance,
) => <String, dynamic>{
  'status': _$HandoverStatusEnumMap[instance.status]!,
  'handover_time': instance.handoverTime,
  'handed_over_at': instance.handedOverAt,
  'reviewed_by': instance.rejectionReviewedBy,
  'rejection_details': instance.rejectionDetails,
  'manager_comment': instance.managerComment,
  'was_edited_after_rejection': instance.wasEditedAfterRejection,
  'edited_at': instance.editedAt,
  'correction_details': instance.correctionDetails,
};

const _$HandoverStatusEnumMap = {
  HandoverStatus.pending: 'pending',
  HandoverStatus.accepted: 'accepted',
  HandoverStatus.rejected: 'rejected',
  HandoverStatus.notSubmitted: 'notSubmitted',
};
