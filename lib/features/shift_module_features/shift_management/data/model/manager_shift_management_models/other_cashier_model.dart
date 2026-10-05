import 'package:json_annotation/json_annotation.dart';

part 'other_cashier_model.g.dart';

@JsonSerializable()
class OtherCashierModel {
  @JsonKey(name: 'cashier_id')
  final String? cashierId;

  @JsonKey(name: 'cashier_name')
  final String? cashierName;

  final double amount;
  final String? notes;

  const OtherCashierModel({
    required this.cashierId,
    required this.cashierName,
    required this.amount,
    this.notes,
  });

  factory OtherCashierModel.fromJson(Map<String, dynamic> json) =>
      _$OtherCashierModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtherCashierModelToJson(this);
}
