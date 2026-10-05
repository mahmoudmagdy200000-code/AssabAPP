import 'package:json_annotation/json_annotation.dart';

part 'manager_shift_end_response_model.g.dart';

@JsonSerializable()
class ManagerShiftEndResponseModel {
  final String? id;

  @JsonKey(name: 'shift_date')
  final String? shiftDate;

  final String? status;

  @JsonKey(name: 'status_label')
  final String? statusLabel;

  const ManagerShiftEndResponseModel({
    this.id,
    this.shiftDate,
    this.status,
    this.statusLabel,
  });

  factory ManagerShiftEndResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerShiftEndResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerShiftEndResponseModelToJson(this);
}
