// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_status_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverStatusDetailsResponseModel _$HandoverStatusDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => HandoverStatusDetailsResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: HandoverStatusDetailsModel.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$HandoverStatusDetailsResponseModelToJson(
  HandoverStatusDetailsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
