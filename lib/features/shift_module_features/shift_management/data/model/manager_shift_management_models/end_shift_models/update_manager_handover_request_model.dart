import 'package:json_annotation/json_annotation.dart';

import '../final_daily_close/cashier_breakdown_model.dart';

part 'update_manager_handover_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateManagerHandoverRequestModel {
  @JsonKey(name: 'cashier_breakdown')
  final List<CashierBreakdownModel> cashierBreakdown;

  const UpdateManagerHandoverRequestModel({required this.cashierBreakdown});

  factory UpdateManagerHandoverRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateManagerHandoverRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateManagerHandoverRequestModelToJson(this);
}
