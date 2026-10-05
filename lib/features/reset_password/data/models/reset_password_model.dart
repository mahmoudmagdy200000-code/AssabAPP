import 'package:json_annotation/json_annotation.dart';

part 'reset_password_model.g.dart';

@JsonSerializable()
class ResetPasswordModel {
  final String identifier;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  ResetPasswordModel({
    required this.identifier,
    required this.password,
    required this.passwordConfirmation,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordModelToJson(this);
}
