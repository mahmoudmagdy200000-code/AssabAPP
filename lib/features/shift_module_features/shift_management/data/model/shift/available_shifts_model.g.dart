// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_shifts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableShiftResponseModel _$AvailableShiftResponseModelFromJson(
  Map<String, dynamic> json,
) => AvailableShiftResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  shifts: (json['data'] as List<dynamic>)
      .map((e) => ShiftInfoDetailsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AvailableShiftResponseModelToJson(
  AvailableShiftResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.shifts.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
