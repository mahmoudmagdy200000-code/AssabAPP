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
  token: json['token'] as String,
);

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  image: json['image'] as String?,
  createdAt: json['created_at'] as String,
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
