// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_shift_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentShiftDataModel _$CurrentShiftDataModelFromJson(
  Map<String, dynamic> json,
) => CurrentShiftDataModel(
  shift: ManagerShiftModel.fromJson(json['shift'] as Map<String, dynamic>),
  shiftProgress: ShiftProgress.fromJson(
    json['shift_progress'] as Map<String, dynamic>,
  ),
  handoversSummary: HandoversSummary.fromJson(
    json['handovers_summary'] as Map<String, dynamic>,
  ),
  handoversDetails: HandoversDetailsModel.fromJson(
    json['handovers_details'] as Map<String, dynamic>,
  ),
  canStart: json['can_start'] as bool,
  canEnd: json['can_end'] as bool,
  pendingHandovers: (json['pending_handovers'] as num).toInt(),
);

Map<String, dynamic> _$CurrentShiftDataModelToJson(
  CurrentShiftDataModel instance,
) => <String, dynamic>{
  'shift': instance.shift.toJson(),
  'shift_progress': instance.shiftProgress.toJson(),
  'handovers_summary': instance.handoversSummary.toJson(),
  'handovers_details': instance.handoversDetails.toJson(),
  'can_start': instance.canStart,
  'can_end': instance.canEnd,
  'pending_handovers': instance.pendingHandovers,
};
