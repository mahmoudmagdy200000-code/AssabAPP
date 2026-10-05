import 'package:json_annotation/json_annotation.dart';

part 'check_email_response_model.g.dart';

@JsonSerializable()
class CheckEmailResponseModel {
  final bool success;
  final String message;
  final CheckEmailDataModel data;

  const CheckEmailResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CheckEmailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckEmailResponseModelToJson(this);
}

@JsonSerializable()
class CheckEmailDataModel {
  final String email;
  final bool registered;
  final String message;

  const CheckEmailDataModel({
    required this.email,
    required this.registered,
    required this.message,
  });

  factory CheckEmailDataModel.fromJson(Map<String, dynamic> json) =>
      _$CheckEmailDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckEmailDataModelToJson(this);
}
