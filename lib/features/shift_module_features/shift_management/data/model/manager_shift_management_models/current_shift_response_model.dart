import 'package:json_annotation/json_annotation.dart';

import 'current_shift_data_model.dart';

part 'current_shift_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CurrentShiftResponse {
  final bool success;
  final String message;
  final CurrentShiftDataModel data;

  CurrentShiftResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CurrentShiftResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentShiftResponseToJson(this);
}
