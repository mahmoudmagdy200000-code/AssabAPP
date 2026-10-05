import 'package:json_annotation/json_annotation.dart';

part 'shift_actions_model.g.dart';

@JsonSerializable()
class ShiftActionsModel {
  @JsonKey(name: 'view_details')
  final bool viewDetails;
  @JsonKey(name: 'start_shift')
  final bool startShift;

  ShiftActionsModel({required this.viewDetails, required this.startShift});

  factory ShiftActionsModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftActionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftActionsModelToJson(this);
}
