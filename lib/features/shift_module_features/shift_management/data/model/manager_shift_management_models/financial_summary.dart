import 'package:json_annotation/json_annotation.dart';

part 'financial_summary.g.dart';

@JsonSerializable()
class FinancialSummary {
  @JsonKey(name: 'total_sales')
  final num totalSales;

  @JsonKey(name: 'net_sales')
  final num netSales;

  @JsonKey(name: 'vat_amount')
  final num vatAmount;

  @JsonKey(name: 'cash_collected')
  final num cashCollected;

  @JsonKey(name: 'card_payments')
  final num cardPayments;

  @JsonKey(name: 'aggregator_payments')
  final num aggregatorPayments;

  @JsonKey(name: 'total_variance')
  final num totalVariance;

  FinancialSummary({
    required this.totalSales,
    required this.netSales,
    required this.vatAmount,
    required this.cashCollected,
    required this.cardPayments,
    required this.aggregatorPayments,
    required this.totalVariance,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) =>
      _$FinancialSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialSummaryToJson(this);
}
