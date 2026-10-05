import 'package:json_annotation/json_annotation.dart';

part 'send_otp_request_model.g.dart';

@JsonSerializable()
class SendOtpRequestModel {
  final String identifier;
  final String type;

  SendOtpRequestModel({required this.identifier, required this.type});

  factory SendOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestModelToJson(this);
}
