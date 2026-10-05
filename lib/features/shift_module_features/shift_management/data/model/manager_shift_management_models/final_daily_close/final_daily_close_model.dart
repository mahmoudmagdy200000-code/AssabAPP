import 'package:json_annotation/json_annotation.dart';

import 'cashier_breakdown_model.dart';

part 'final_daily_close_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FinalDailyCloseResponse {
  final bool success;
  final String message;
  final FinalDailyCloseData data;

  FinalDailyCloseResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FinalDailyCloseResponse.fromJson(Map<String, dynamic> json) =>
      _$FinalDailyCloseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FinalDailyCloseResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FinalDailyCloseData {
  @JsonKey(name: 'cashier_breakdown')
  final List<CashierBreakdownModel> cashierBreakdown;
  final Totals totals;
  final List<AggregatorFinalDailyCloseModel>? aggregators;

  FinalDailyCloseData({
    required this.cashierBreakdown,
    required this.totals,
    required this.aggregators,
  });

  factory FinalDailyCloseData.fromJson(Map<String, dynamic> json) =>
      _$FinalDailyCloseDataFromJson(json);
  Map<String, dynamic> toJson() => _$FinalDailyCloseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AggregatorFinalDailyCloseModel {
  final String id;
  final String name;
  final String? logo;
  final double total;
  @JsonKey(name: 'cashier_breakdown')
  final List<CashierBreakdownFinalDailyCloseModel>? cashierBreakdown;

  AggregatorFinalDailyCloseModel({
    required this.id,
    required this.name,
    this.logo,
    required this.total,
    required this.cashierBreakdown,
  });

  factory AggregatorFinalDailyCloseModel.fromJson(Map<String, dynamic> json) =>
      _$AggregatorFinalDailyCloseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AggregatorFinalDailyCloseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CashierBreakdownFinalDailyCloseModel {
  @JsonKey(name: 'cashier_id')
  final String cashierId;
  @JsonKey(name: 'cashier_name')
  final String cashierName;
  final double amount;

  CashierBreakdownFinalDailyCloseModel({
    required this.cashierId,
    required this.cashierName,
    required this.amount,
  });

  factory CashierBreakdownFinalDailyCloseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierBreakdownFinalDailyCloseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierBreakdownFinalDailyCloseModelToJson(this);

  CashierBreakdownFinalDailyCloseModel copyWith({
    String? cashierId,
    String? cashierName,
    double? amount,
  }) {
    return CashierBreakdownFinalDailyCloseModel(
      cashierId: cashierId ?? this.cashierId,
      cashierName: cashierName ?? this.cashierName,
      amount: amount ?? this.amount,
    );
  }
}

@JsonSerializable()
class Totals {
  final double? totalCashCollected;
  final double? totalCardPayments;
  final double? totalDeliveryApps;
  final double? totalVariance;
  final double? totalSales;

  Totals({
    required this.totalCashCollected,
    required this.totalCardPayments,
    required this.totalDeliveryApps,
    required this.totalVariance,
    required this.totalSales,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);
  Map<String, dynamic> toJson() => _$TotalsToJson(this);
}
