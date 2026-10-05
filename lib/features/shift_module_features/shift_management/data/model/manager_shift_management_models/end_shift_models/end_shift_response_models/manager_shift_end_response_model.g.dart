// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_end_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerShiftEndResponseModel _$ManagerShiftEndResponseModelFromJson(
  Map<String, dynamic> json,
) => ManagerShiftEndResponseModel(
  id: json['id'] as String?,
  shiftDate: json['shift_date'] as String?,
  status: json['status'] as String?,
  statusLabel: json['status_label'] as String?,
);

Map<String, dynamic> _$ManagerShiftEndResponseModelToJson(
  ManagerShiftEndResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'shift_date': instance.shiftDate,
  'status': instance.status,
  'status_label': instance.statusLabel,
};
