import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';

class AggregatorFinalDailyCloseEntity {
  final String id;
  final String name;
  final String? logo;
  final double total;
  final List<CashierBreakdownFinalDailyCloseModel>? cashierBreakdown;

  AggregatorFinalDailyCloseEntity({
    required this.id,
    required this.name,
    this.logo,
    required this.total,
    required this.cashierBreakdown,
  });

  AggregatorFinalDailyCloseEntity copyWith({
    String? id,
    String? name,
    String? logo,
    double? total,
    List<CashierBreakdownFinalDailyCloseModel>? cashierBreakdown,
  }) {
    return AggregatorFinalDailyCloseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      total: total ?? this.total,
      cashierBreakdown: cashierBreakdown ?? this.cashierBreakdown,
    );
  }
}
