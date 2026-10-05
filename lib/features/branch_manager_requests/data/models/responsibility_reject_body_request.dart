import 'package:json_annotation/json_annotation.dart';

part 'responsibility_reject_body_request.g.dart';

@JsonSerializable()
class ResponsibilityRejectBodyRequest {
  final String reason;

  const ResponsibilityRejectBodyRequest({required this.reason});

  factory ResponsibilityRejectBodyRequest.fromJson(Map<String, dynamic> json) =>
      _$ResponsibilityRejectBodyRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResponsibilityRejectBodyRequestToJson(this);
}
