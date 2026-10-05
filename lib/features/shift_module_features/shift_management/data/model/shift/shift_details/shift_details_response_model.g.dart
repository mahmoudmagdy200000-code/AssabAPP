// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftDetailsResponseModel _$ShiftDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => ShiftDetailsResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ShiftDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShiftDetailsResponseModelToJson(
  ShiftDetailsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};
