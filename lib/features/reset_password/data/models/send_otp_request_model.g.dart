// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequestModel _$SendOtpRequestModelFromJson(Map<String, dynamic> json) =>
    SendOtpRequestModel(
      identifier: json['identifier'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$SendOtpRequestModelToJson(
  SendOtpRequestModel instance,
) => <String, dynamic>{
  'identifier': instance.identifier,
  'type': instance.type,
};
