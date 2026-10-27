import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final LoginData data;

  LoginResponseModel({required this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class LoginData {
  final UserResponse user;
  final String token;
  @JsonKey(name: 'requires_password_reset')
  final bool? requiresPasswordReset;

  LoginData({
    required this.user,
    required this.token,
    this.requiresPasswordReset,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class UserResponse {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  @JsonKey(name: 'created_at')
  final String createdAt;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
