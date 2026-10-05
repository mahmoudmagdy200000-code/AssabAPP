import 'package:json_annotation/json_annotation.dart';

part 'working_shift_model.g.dart';

@JsonSerializable()
class WorkingShiftModel {
  final String id;
  final String name;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  WorkingShiftModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory WorkingShiftModel.fromJson(Map<String, dynamic> json) =>
      _$WorkingShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingShiftModelToJson(this);
}
