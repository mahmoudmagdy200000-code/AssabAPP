// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_shift_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentShiftResponse _$CurrentShiftResponseFromJson(
  Map<String, dynamic> json,
) => CurrentShiftResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: CurrentShiftDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CurrentShiftResponseToJson(
  CurrentShiftResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};
