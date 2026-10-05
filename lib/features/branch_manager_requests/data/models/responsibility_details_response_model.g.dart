// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsibility_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsibilityDetailsResponseModel _$ResponsibilityDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => ResponsibilityDetailsResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ResponsibilityDetailsDataModel.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ResponsibilityDetailsResponseModelToJson(
  ResponsibilityDetailsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
