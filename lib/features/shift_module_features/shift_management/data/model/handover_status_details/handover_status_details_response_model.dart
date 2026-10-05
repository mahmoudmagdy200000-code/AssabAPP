import 'package:json_annotation/json_annotation.dart';

import 'handover_status_details_model.dart';

part 'handover_status_details_response_model.g.dart';

@JsonSerializable()
class HandoverStatusDetailsResponseModel {
  final bool success;
  final String message;
  final HandoverStatusDetailsModel data;

  HandoverStatusDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HandoverStatusDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$HandoverStatusDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HandoverStatusDetailsResponseModelToJson(this);
}
