import 'package:json_annotation/json_annotation.dart';

import '../../../../../shift_module_features/shift_management/domain/enums/user_type.dart';

part 'cashier_reassign_user_model.g.dart';

@JsonSerializable()
class CashierReassignUserModel {
  final String id;
  final String name;

  @JsonKey(name: 'user_type', fromJson: UserType.fromJson)
  final UserType? userType;

  const CashierReassignUserModel({
    required this.id,
    required this.name,
    this.userType,
  });

  factory CashierReassignUserModel.fromJson(Map<String, dynamic> json) =>
      _$CashierReassignUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierReassignUserModelToJson(this);
}
