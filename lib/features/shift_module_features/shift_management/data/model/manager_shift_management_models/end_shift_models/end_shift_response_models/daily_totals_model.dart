import 'package:json_annotation/json_annotation.dart';

part 'daily_totals_model.g.dart';

@JsonSerializable()
class DailyTotalsModel {
  @JsonKey(name: 'total_cash_collected')
  final double? totalCashCollected;

  @JsonKey(name: 'total_card_payments')
  final double? totalCardPayments;

  @JsonKey(name: 'total_delivery_apps')
  final double? totalDeliveryApps;

  @JsonKey(name: 'total_variance')
  final double? totalVariance;

  @JsonKey(name: 'total_sales')
  final double? totalSales;

  @JsonKey(name: 'shift_date')
  final String? shiftDate;

  const DailyTotalsModel({
    this.totalCashCollected,
    this.totalCardPayments,
    this.totalDeliveryApps,
    this.totalVariance,
    this.totalSales,
    this.shiftDate,
  });

  factory DailyTotalsModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTotalsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyTotalsModelToJson(this);
}
