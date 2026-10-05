import 'package:json_annotation/json_annotation.dart';

part 'reassign_shift_request_model.g.dart';

@JsonSerializable()
class ReassignShiftRequestModel {
  @JsonKey(name: 'new_cashier_id')
  final String newCashierId;

  final String? reason;

  const ReassignShiftRequestModel({required this.newCashierId, this.reason});

  Map<String, dynamic> toJson() => _$ReassignShiftRequestModelToJson(this);

  factory ReassignShiftRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ReassignShiftRequestModelFromJson(json);
}
