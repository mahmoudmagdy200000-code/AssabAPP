// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{'data': instance.data};

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  token: (json['token'] ?? '').toString(),
  requiresPasswordReset: json['requires_password_reset'] as bool?,
);

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
  if (instance.requiresPasswordReset != null)
    'requires_password_reset': instance.requiresPasswordReset,
};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: (json['id'] ?? '').toString(),
  name: (json['name'] ?? '').toString(),
  email: (json['email'] ?? '').toString(),
  phone: json['phone']?.toString(),
  image: json['image']?.toString(),
  createdAt: (json['created_at'] ?? '').toString(),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'image': instance.image,
      'created_at': instance.createdAt,
    };
