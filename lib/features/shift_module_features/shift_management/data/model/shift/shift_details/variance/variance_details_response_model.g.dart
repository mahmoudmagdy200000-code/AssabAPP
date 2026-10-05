// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variance_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VarianceResponseModel _$VarianceResponseModelFromJson(
  Map<String, dynamic> json,
) => VarianceResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: VarianceDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VarianceResponseModelToJson(
  VarianceResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
