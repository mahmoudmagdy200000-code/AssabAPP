import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'variance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Variance {
  @JsonKey(name: 'responsibility_type')
  final String responsibilityType;

  @JsonKey(name: 'current_cashier_amount')
  final double? currentCashierAmount;

  final String reason;

  @JsonKey(name: 'other_cashiers')
  final List<OtherCashier> otherCashiers;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  ) // File cannot be serialized
  final List<File?> supportingFiles;

  Variance({
    required this.responsibilityType,
    required this.currentCashierAmount,
    required this.reason,
    required this.otherCashiers,
    this.supportingFiles = const [],
  });

  factory Variance.fromJson(Map<String, dynamic> json) =>
      _$VarianceFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceToJson(this);
}

@JsonSerializable()
class OtherCashier {
  @JsonKey(name: 'cashier_id')
  final String cashierId;
  final double amount;

  OtherCashier({required this.cashierId, required this.amount});

  factory OtherCashier.fromJson(Map<String, dynamic> json) =>
      _$OtherCashierFromJson(json);

  Map<String, dynamic> toJson() => _$OtherCashierToJson(this);
}
