// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_shift_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftEndResponseModel _$ShiftEndResponseModelFromJson(
  Map<String, dynamic> json,
) => ShiftEndResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ManagerShiftEndDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShiftEndResponseModelToJson(
  ShiftEndResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
