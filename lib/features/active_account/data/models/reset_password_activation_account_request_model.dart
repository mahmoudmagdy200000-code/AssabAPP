import 'package:json_annotation/json_annotation.dart';

part 'reset_password_activation_account_request_model.g.dart';

@JsonSerializable()
class ResetPasswordActivationAccountRequestModel {
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  ResetPasswordActivationAccountRequestModel({
    required this.password,
    required this.passwordConfirmation,
  });
  factory ResetPasswordActivationAccountRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ResetPasswordActivationAccountRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ResetPasswordActivationAccountRequestModelToJson(this);
}
