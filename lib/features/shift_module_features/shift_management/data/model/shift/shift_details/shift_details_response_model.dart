import 'package:json_annotation/json_annotation.dart';

import 'shift_details_model.dart';

part 'shift_details_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShiftDetailsResponseModel {
  final bool success;
  final String message;
  final ShiftDetailsModel data;

  ShiftDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ShiftDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftDetailsResponseModelToJson(this);
}
