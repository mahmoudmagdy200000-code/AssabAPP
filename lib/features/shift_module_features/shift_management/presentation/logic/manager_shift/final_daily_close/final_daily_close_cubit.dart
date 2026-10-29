import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/mapper/manager_shift/final_daily_close_mappers/aggregator_final_daily_close_mapper.dart';
import '../../../../data/mapper/manager_shift/final_daily_close_mappers/cashier_breakdown_mapper.dart';
import '../../../../domain/entity/manager_shift/current_shift/final_daily_close/AggregatorFinalDailyCloseEntity.dart';
import '../../../../domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';

part 'final_daily_close_state.dart';

@injectable
class FinalDailyCloseCubit extends SafeCubit<FinalDailyCloseState> {
  final ShiftManagementRepositoryImp _repo;
  FinalDailyCloseCubit(this._repo) : super(FinalDailyCloseInitial());

  List<CashierBreakdownEntity> cashiersBreakdown = [];
  late TotalsEntity totals;
  List<AggregatorFinalDailyCloseEntity>? aggregators;

  Future<void> getDailyClose() async {
    emit(FinalDailyCloseFetchLoading());

    final result = await _repo.getDailyClose();

    handle(
      result,
      failure: (failure) => emit(FinalDailyCloseFetchFailure(failure: failure)),
      success: (success) {
        cashiersBreakdown = success.cashierBreakdown
            .map((e) => e.toEntity())
            .toList();
        totals = TotalsEntity.fromCashiers(cashiersBreakdown);

        aggregators = success.aggregators?.map((e) => e.toEntity()).toList();
        emit(
          FinalDailyCloseLoadedOrUpdated(
            cashiers: cashiersBreakdown,
            totals: totals,
            aggregators: aggregators ?? [],
          ),
        );
      },
    );
  }

  void updateCashierField({
    required String cashierId,
    required CashierField field,
    required double value,
  }) {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;

    final updatedCashiers = current.cashiers.map((c) {
      if (c.cashierId != cashierId) return c;

      switch (field) {
        case CashierField.cashCollected:
          return c.copyWith(cashCollected: value);
        case CashierField.cardPayments:
          return c.copyWith(cardPayments: value);
        case CashierField.deliveryAppPayments:
          return c.copyWith(deliveryAppPayments: value);
        case CashierField.variance:
          // Variance is server-derived and strictly read-only; mutations are ignored
          return c;
        case CashierField.totalSales:
          return c.copyWith(totalSales: value);
      }
    }).toList();

    cashiersBreakdown = updatedCashiers;
    totals = TotalsEntity.fromCashiers(updatedCashiers);

    emit(
      FinalDailyCloseLoadedOrUpdated(
        cashiers: cashiersBreakdown,
        totals: totals,
        isSubmitted: current.isSubmitted, // keep current submission state
      ),
    );
  }

  void cashierBreakDownAndTotalsData({
    required List<CashierBreakdownEntity> cashiersBreakdown,
    required TotalsEntity totals,
  }) {
    this.cashiersBreakdown = cashiersBreakdown;
    this.totals = totals;

    emit(
      FinalDailyCloseLoadedOrUpdated(
        cashiers: this.cashiersBreakdown,
        totals: this.totals,
      ),
    );
  }

  void toggleSubmitted() {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;

    emit(current.copyWith(isSubmitted: !current.isSubmitted));
  }

  void toggleExpansion() {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;

    emit(current.copyWith(isExpanded: !current.isExpanded));
  }

  void updateAggregatorAmount({
    required String cashierId,
    required String aggregatorId,
    required double newValue,
  }) {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;

    // 1. Update Aggregators List
    final updatedAggregators = current.aggregators?.map((agg) {
      if (agg.id != aggregatorId) return agg;

      final updatedBreakdown = agg.cashierBreakdown?.map((breakdown) {
        if (breakdown.cashierId != cashierId) return breakdown;
        return breakdown.copyWith(amount: newValue);
      }).toList();

      final newTotal =
          updatedBreakdown?.fold<double>(0, (sum, item) => sum + item.amount) ??
          0;

      return agg.copyWith(cashierBreakdown: updatedBreakdown, total: newTotal);
    }).toList();

    // 2. Update Cashiers Breakdown (Sync Delivery Apps Total)
    final updatedCashiers = current.cashiers.map((cashier) {
      if (cashier.cashierId != cashierId) return cashier;

      // Sum all aggregator amounts for this cashier from the updatedAggregators list
      double totalDeliveryAppsForCashier = 0;
      if (updatedAggregators != null) {
        for (var agg in updatedAggregators) {
          final breakdownRow = agg.cashierBreakdown?.firstWhere(
            (b) => b.cashierId == cashierId,
          );
          totalDeliveryAppsForCashier += breakdownRow?.amount ?? 0;
        }
      }

      return cashier.copyWith(deliveryAppPayments: totalDeliveryAppsForCashier);
    }).toList();

    // 3. Update Totals
    final updatedTotals = TotalsEntity.fromCashiers(updatedCashiers);

    // 4. Emit
    cashiersBreakdown = updatedCashiers;
    totals = updatedTotals;
    aggregators = updatedAggregators;

    emit(
      current.copyWith(
        cashiers: updatedCashiers,
        aggregators: updatedAggregators,
        totals: updatedTotals,
      ),
    );
  }

  void undoChanges({
    required List<CashierBreakdownEntity> draftCashiers,
    required TotalsEntity draftTotals,
    required List<AggregatorFinalDailyCloseEntity> draftAggregators,
  }) {
    emit(
      FinalDailyCloseLoadedOrUpdated(
        cashiers: draftCashiers,
        totals: draftTotals,
        aggregators: draftAggregators,
        isSubmitted: false,
      ),
    );
  }
}

enum CashierField {
  cashCollected,
  cardPayments,
  deliveryAppPayments,
  variance,
  totalSales,
}
