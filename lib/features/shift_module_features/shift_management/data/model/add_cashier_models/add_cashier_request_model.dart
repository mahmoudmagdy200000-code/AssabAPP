import 'package:json_annotation/json_annotation.dart';

part 'add_cashier_request_model.g.dart';

@JsonSerializable()
class AddCashierRequestModel {
  final String name;
  final String email;
  final String phone;

  @JsonKey(name: 'store_branch_id')
  final String branchId;

  /// List of shift IDs the cashier is assigned to.
  @JsonKey(name: 'shift_ids')
  final List<String> shiftIds;

  AddCashierRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.branchId,
    required this.shiftIds,
  });

  factory AddCashierRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddCashierRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddCashierRequestModelToJson(this);
}
