import 'package:json_annotation/json_annotation.dart';

import 'manager_shift_end_data_model.dart';

part 'end_shift_response_model.g.dart';

@JsonSerializable()
class ShiftEndResponseModel {
  final bool success;
  final String message;
  final ManagerShiftEndDataModel data;

  ShiftEndResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ShiftEndResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftEndResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftEndResponseModelToJson(this);
}
