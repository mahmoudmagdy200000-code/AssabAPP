// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_activation_account_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordActivationAccountRequestModel
_$ResetPasswordActivationAccountRequestModelFromJson(
  Map<String, dynamic> json,
) => ResetPasswordActivationAccountRequestModel(
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
);

Map<String, dynamic> _$ResetPasswordActivationAccountRequestModelToJson(
  ResetPasswordActivationAccountRequestModel instance,
) => <String, dynamic>{
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
};
