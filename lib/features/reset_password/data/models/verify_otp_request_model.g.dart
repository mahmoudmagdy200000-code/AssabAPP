// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpRequestModel _$VerifyOtpRequestModelFromJson(
  Map<String, dynamic> json,
) => VerifyOtpRequestModel(
  identifier: json['identifier'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$VerifyOtpRequestModelToJson(
  VerifyOtpRequestModel instance,
) => <String, dynamic>{'identifier': instance.identifier, 'otp': instance.otp};
