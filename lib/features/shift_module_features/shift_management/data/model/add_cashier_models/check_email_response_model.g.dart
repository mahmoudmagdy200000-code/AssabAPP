// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_email_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckEmailResponseModel _$CheckEmailResponseModelFromJson(
  Map<String, dynamic> json,
) => CheckEmailResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: CheckEmailDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CheckEmailResponseModelToJson(
  CheckEmailResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

CheckEmailDataModel _$CheckEmailDataModelFromJson(Map<String, dynamic> json) =>
    CheckEmailDataModel(
      email: json['email'] as String,
      registered: json['registered'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$CheckEmailDataModelToJson(
  CheckEmailDataModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'registered': instance.registered,
  'message': instance.message,
};
