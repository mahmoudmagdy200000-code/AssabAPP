import 'package:json_annotation/json_annotation.dart';

part 'cashier_my_shift_actions_model.g.dart';

@JsonSerializable()
class CashierPendingShiftActionsModel {
  @JsonKey(name: 'view_details')
  final bool viewDetails;

  @JsonKey(name: 'reassign_shift')
  final bool reassignShift;

  const CashierPendingShiftActionsModel({
    required this.viewDetails,
    required this.reassignShift,
  });

  factory CashierPendingShiftActionsModel.fromJson(Map<String, dynamic> json) =>
      _$CashierPendingShiftActionsModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierPendingShiftActionsModelToJson(this);
}
