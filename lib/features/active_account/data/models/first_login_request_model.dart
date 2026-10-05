import 'package:json_annotation/json_annotation.dart';

part 'first_login_request_model.g.dart';

@JsonSerializable()
class FirstLoginRequestModel {
  final String email;
  final String password;

  FirstLoginRequestModel({required this.email, required this.password});

  factory FirstLoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FirstLoginRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$FirstLoginRequestModelToJson(this);
}
