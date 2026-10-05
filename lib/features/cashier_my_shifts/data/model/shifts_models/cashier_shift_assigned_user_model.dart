import 'package:json_annotation/json_annotation.dart';

part 'cashier_shift_assigned_user_model.g.dart';

@JsonSerializable()
class CashierShiftAssignedUserModel {
  final String id;
  final String name;

  const CashierShiftAssignedUserModel({required this.id, required this.name});

  factory CashierShiftAssignedUserModel.fromJson(Map<String, dynamic> json) =>
      _$CashierShiftAssignedUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierShiftAssignedUserModelToJson(this);
}
