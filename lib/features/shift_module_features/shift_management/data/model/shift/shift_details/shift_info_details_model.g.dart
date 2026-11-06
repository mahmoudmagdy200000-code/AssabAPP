// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_info_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftInfoDetailsModel _$ShiftInfoDetailsModelFromJson(
  Map<String, dynamic> json,
) => ShiftInfoDetailsModel(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] as String?) ?? 'N/A',
  branchId: (json['branch_id'] ?? '').toString(),
  branchName: json['branch_name'] as String?,
  isActive: json['is_active'] as bool?,
  startTime: (json['start_time'] as String?) ?? '00:00',
  endTime: (json['end_time'] as String?) ?? '00:00',
  assignedBy: AssignedByModel.tryFromJson(json['assigned_by']),
);

Map<String, dynamic> _$ShiftInfoDetailsModelToJson(
  ShiftInfoDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'branch_id': instance.branchId,
  'branch_name': instance.branchName,
  'is_active': instance.isActive,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'assigned_by': instance.assignedBy?.toJson(),
};
