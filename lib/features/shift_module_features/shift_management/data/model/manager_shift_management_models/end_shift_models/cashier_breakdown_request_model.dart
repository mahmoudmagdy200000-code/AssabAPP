import 'package:json_annotation/json_annotation.dart';

part 'cashier_breakdown_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CashierBreakdownRequestModel {
  @JsonKey(name: 'cashier_id')
  final String cashierId;

  @JsonKey(name: 'cashier_shift_id', includeIfNull: false)
  final String? cashierShiftId;

  @JsonKey(name: 'cash_collected')
  final double? cashCollected;

  @JsonKey(name: 'card_payments')
  final double? cardPayments;

  @JsonKey(name: 'delivery_app_payments')
  final double? deliveryAppPayments;

  @JsonKey(name: 'sales')
  final double? sales;

  @JsonKey(name: 'expected_revision', includeIfNull: false)
  final int? expectedRevision;

  @JsonKey(name: 'reason', includeIfNull: false)
  final String? reason;

  const CashierBreakdownRequestModel({
    required this.cashierId,
    this.cashierShiftId,
    this.cashCollected,
    this.cardPayments,
    this.deliveryAppPayments,
    this.sales,
    this.expectedRevision,
    this.reason,
  });

  factory CashierBreakdownRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CashierBreakdownRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierBreakdownRequestModelToJson(this);
}
