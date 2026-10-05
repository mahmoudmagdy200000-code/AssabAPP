// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordModel _$ResetPasswordModelFromJson(Map<String, dynamic> json) =>
    ResetPasswordModel(
      identifier: json['identifier'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
    );

Map<String, dynamic> _$ResetPasswordModelToJson(ResetPasswordModel instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
    };
