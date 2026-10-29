import 'package:json_annotation/json_annotation.dart';

part 'cashier_breakdown_model.g.dart';

@JsonSerializable()
class CashierBreakdownModel {
  @JsonKey(name: 'cashier_id')
  final String cashierId;

  @JsonKey(name: 'cashier_name')
  final String cashierName;

  @JsonKey(name: 'cash_collected')
  final double? cashCollected;

  @JsonKey(name: 'card_payments')
  final double? cardPayments;

  @JsonKey(name: 'delivery_app_payments')
  final double? deliveryAppPayments;

  /// Server-derived financial balance indicator. Strictly read-only; never serialized to write payloads.
  @JsonKey(name: 'variance', includeToJson: false)
  final double? variance;

  @JsonKey(name: 'sales')
  final double? sales;

  const CashierBreakdownModel({
    required this.cashierId,
    required this.cashierName,
    this.cashCollected,
    this.cardPayments,
    this.deliveryAppPayments,
    this.variance,
    this.sales,
  });

  factory CashierBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$CashierBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierBreakdownModelToJson(this);
}