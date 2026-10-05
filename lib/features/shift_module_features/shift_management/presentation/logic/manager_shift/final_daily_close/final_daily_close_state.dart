part of 'final_daily_close_cubit.dart';

@immutable
sealed class FinalDailyCloseState {}

final class FinalDailyCloseInitial extends FinalDailyCloseState {}

final class FinalDailyCloseFetchLoading extends FinalDailyCloseState {}

class FinalDailyCloseLoadedOrUpdated extends FinalDailyCloseState {
  final List<CashierBreakdownEntity> cashiers;
  final TotalsEntity totals;
  final List<AggregatorFinalDailyCloseEntity>? aggregators;
  final bool isSubmitted;
  final bool isExpanded; // NEW

  FinalDailyCloseLoadedOrUpdated({
    required this.cashiers,
    required this.totals,
    this.aggregators,
    this.isSubmitted = false,
    this.isExpanded = false, // default false
  });

  FinalDailyCloseLoadedOrUpdated copyWith({
    List<CashierBreakdownEntity>? cashiers,
    TotalsEntity? totals,
    List<AggregatorFinalDailyCloseEntity>? aggregators,
    bool? isSubmitted,
    bool? isExpanded,
  }) {
    return FinalDailyCloseLoadedOrUpdated(
      cashiers: cashiers ?? this.cashiers,
      totals: totals ?? this.totals,
      aggregators: aggregators ?? this.aggregators,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

final class FinalDailyCloseFetchFailure extends FinalDailyCloseState {
  final ApiFailure failure;

  FinalDailyCloseFetchFailure({required this.failure});
}
