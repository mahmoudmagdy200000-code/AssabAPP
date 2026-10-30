import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart' show Icons;
import '../../../../../../../core/errors/api_error_model.dart';

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
  TotalsEntity totals = TotalsEntity.fromCashiers([]);
  List<AggregatorFinalDailyCloseEntity>? aggregators;
  String selectedWorkday = 'today';
  String? _targetWorkdayId;
  int _fetchGeneration = 0;
  Map<String, String> workdayDates = {};

  bool get canSubmit =>
      state is FinalDailyCloseLoadedOrUpdated &&
      (state as FinalDailyCloseLoadedOrUpdated).canSubmit;

  Future<void> selectWorkday(String workday) async {
    if (!['today', 'yesterday'].contains(workday)) return;
    if (selectedWorkday == workday && state is FinalDailyCloseLoadedOrUpdated) {
      return;
    }
    await getDailyClose(workday: workday);
  }

  Future<void> getDailyClose({
    String? managerWorkdayId,
    String? workday,
  }) async {
    final generation = ++_fetchGeneration;
    if (workday != null) {
      selectedWorkday = workday;
      _targetWorkdayId = null;
    }
    if (managerWorkdayId != null) _targetWorkdayId = managerWorkdayId;
    final requestedId = _targetWorkdayId;
    // Clear the previous day's editable state before starting a new request.
    cashiersBreakdown = [];
    totals = TotalsEntity.fromCashiers([]);
    aggregators = [];
    emit(FinalDailyCloseFetchLoading());
    final result = await _repo.getDailyClose(
      managerWorkdayId: requestedId,
      workday: requestedId == null ? selectedWorkday : null,
    );
    if (generation != _fetchGeneration || isClosed) return;
    handle(
      result,
      failure: (failure) => emit(FinalDailyCloseFetchFailure(failure: failure)),
      success: (success) {
        if (success.managerWorkdayId?.isNotEmpty != true ||
            success.businessDate?.isNotEmpty != true ||
            (requestedId != null && success.managerWorkdayId != requestedId)) {
          emit(
            FinalDailyCloseFetchFailure(
              failure: ValidationFailure(
                error: LocalErrorModel(
                  message:
                      'The selected workday could not be verified. Reload its summary.',
                ),
                icon: Icons.error_outline,
                statusCode: 409,
                stackTrace: StackTrace.current,
              ),
            ),
          );
          return;
        }
        _targetWorkdayId = success.managerWorkdayId;
        workdayDates = success.workdayDates;
        selectedWorkday =
            workdayDates.entries
                .where((e) => e.value == success.businessDate)
                .map((e) => e.key)
                .firstOrNull ??
            '';
        aggregators =
            success.aggregators?.map((e) => e.toEntity()).toList() ?? [];
        cashiersBreakdown = success.cashierBreakdown.map((row) {
          final entity = row.toEntity();
          final apps = _appsForShift(entity.cashierShiftId, aggregators!);
          return CashierBreakdownEntity(
            cashierId: entity.cashierId,
            cashierShiftId: entity.cashierShiftId,
            expectedRevision: entity.expectedRevision,
            cashierName: entity.cashierName,
            cashCollected: entity.cashCollected,
            cardPayments: entity.cardPayments,
            deliveryAppPayments: entity.deliveryAppPayments,
            variance: entity.variance,
            totalSales: entity.totalSales,
            aggregators: apps,
          );
        }).toList();
        totals = TotalsEntity.fromCashiers(cashiersBreakdown);
        emit(
          FinalDailyCloseLoadedOrUpdated(
            managerWorkdayId: success.managerWorkdayId,
            businessDate: success.businessDate,
            serverTime: success.serverTime,
            timezone: success.timezone,
            workdayDates: workdayDates,
            cashiers: cashiersBreakdown,
            totals: totals,
            aggregators: aggregators,
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _appsForShift(
    String? shiftId,
    List<AggregatorFinalDailyCloseEntity> apps,
  ) {
    final result = <Map<String, dynamic>>[];
    if (shiftId == null) return result;
    for (final app in apps) {
      for (final row in app.cashierBreakdown ?? []) {
        if (row.cashierShiftId == shiftId && row.present) {
          result.add({
            'aggregator_id': app.id,
            'amount': row.amount,
            'notes': row.notes,
          });
        }
      }
    }
    result.sort(
      (a, b) => (a['aggregator_id'] as String).compareTo(
        b['aggregator_id'] as String,
      ),
    );
    return result;
  }

  void updateReason({required String cashierShiftId, required String reason}) {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;
    cashiersBreakdown = current.cashiers
        .map(
          (c) => c.cashierShiftId == cashierShiftId
              ? c.copyWith(reason: reason)
              : c,
        )
        .toList();
    emit(current.copyWith(cashiers: cashiersBreakdown));
  }

  void updateCashierField({
    required String cashierShiftId,
    required CashierField field,
    required double value,
  }) {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;

    final updatedCashiers = current.cashiers.map((c) {
      if (c.cashierShiftId != cashierShiftId) return c;

      switch (field) {
        case CashierField.cashCollected:
          return c.copyWith(cashCollected: value);
        case CashierField.cardPayments:
          return c.copyWith(cardPayments: value);
        case CashierField.deliveryAppPayments:
          if ((c.aggregators?.length ?? 0) > 1) return c;
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

    emit(current.copyWith(cashiers: cashiersBreakdown, totals: totals));
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
    required String cashierShiftId,
    required String aggregatorId,
    required double newValue,
  }) {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated) return;

    // 1. Update Aggregators List
    final updatedAggregators = current.aggregators?.map((agg) {
      if (agg.id != aggregatorId) return agg;

      final updatedBreakdown = agg.cashierBreakdown?.map((breakdown) {
        if (breakdown.cashierShiftId != cashierShiftId) return breakdown;
        return breakdown.copyWith(amount: newValue, present: true);
      }).toList();

      final newTotal =
          updatedBreakdown?.fold<double>(0, (sum, item) => sum + item.amount) ??
          0;

      return agg.copyWith(cashierBreakdown: updatedBreakdown, total: newTotal);
    }).toList();

    // 2. Update Cashiers Breakdown (Sync Delivery Apps Total)
    final updatedCashiers = current.cashiers.map((cashier) {
      if (cashier.cashierShiftId != cashierShiftId) return cashier;

      final apps = _appsForShift(cashierShiftId, updatedAggregators ?? []);
      final total = apps.fold<double>(
        0,
        (sum, row) => sum + (row['amount'] as num).toDouble(),
      );
      return cashier.copyWith(deliveryAppPayments: total, aggregators: apps);
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
    required String managerWorkdayId,
    required List<CashierBreakdownEntity> draftCashiers,
    required TotalsEntity draftTotals,
    required List<AggregatorFinalDailyCloseEntity> draftAggregators,
  }) {
    final current = state;
    if (current is! FinalDailyCloseLoadedOrUpdated ||
        current.managerWorkdayId != managerWorkdayId) {
      return;
    }
    cashiersBreakdown = draftCashiers;
    totals = draftTotals;
    aggregators = draftAggregators;
    emit(
      current.copyWith(
        cashiers: draftCashiers,
        totals: draftTotals,
        aggregators: draftAggregators,
        isSubmitted: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _fetchGeneration++;
    return super.close();
  }
}

enum CashierField {
  cashCollected,
  cardPayments,
  deliveryAppPayments,
  variance,
  totalSales,
}
