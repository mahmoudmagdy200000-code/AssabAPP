import 'package:json_annotation/json_annotation.dart';

import '../../../../shift_module_features/shift_management/domain/enums/user_type.dart';

part 'cashier_shifts_user_model.g.dart';

@JsonSerializable()
class CashierShiftUserModel {
  final String? id;
  final String name;

  @JsonKey(name: 'user_type', fromJson: UserType.fromJson)
  final UserType? userType;

  @JsonKey(name: 'type', fromJson: UserType.fromJson)
  final UserType? type; // for handover_to response

  const CashierShiftUserModel({
    required this.id,
    required this.name,
    this.userType,
    this.type,
  });

  static CashierShiftUserModel? tryFromJson(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final id = raw['id']?.toString().trim();
    final name = raw['name']?.toString().trim();
    if ((id == null || id.isEmpty) && (name == null || name.isEmpty)) {
      return null;
    }
    return CashierShiftUserModel.fromJson(raw);
  }

  factory CashierShiftUserModel.fromJson(Map<String, dynamic> json) =>
      _$CashierShiftUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierShiftUserModelToJson(this);
}
