import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/cashier_breakdown_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/manager_end_shift_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/update_manager_handover_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/daily_totals_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/final_handover_end_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_update_data_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';

class _Remote implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Repo extends ShiftManagementRepositoryImp {
  _Repo() : super(_Remote());
  final pending = <Completer<ApiResult<FinalDailyCloseData>>>[];
  final queries = <({String? id, String? relative})>[];
  final endRequests = <EndManagerShiftRequestModel>[];
  final keys = <String?>[];
  final updates = <UpdateManagerHandoverRequestModel>[];
  Completer<ApiResult<ManagerShiftEndDataEntity>>? holdEnd;

  @override
  FutureApiResult<FinalDailyCloseData> getDailyClose({
    String? managerWorkdayId,
    String? workday,
  }) {
    queries.add((id: managerWorkdayId, relative: workday));
    final c = Completer<ApiResult<FinalDailyCloseData>>();
    pending.add(c);
    return c.future;
  }

  @override
  FutureApiResult<ManagerShiftEndDataEntity> endManagerShift({
    required EndManagerShiftRequestModel request,
    String? idempotencyKey,
  }) async {
    endRequests.add(request);
    keys.add(idempotencyKey);
    if (holdEnd != null) return holdEnd!.future;
    return ApiResult.success(_endData);
  }

  @override
  FutureApiResult<ManagerShiftUpdateDataEntity> updateManagerHandoverShift({
    required UpdateManagerHandoverRequestModel request,
    String? idempotencyKey,
  }) async {
    updates.add(request);
    keys.add(idempotencyKey);
    return ApiResult.success(
      const ManagerShiftUpdateDataEntity(
        shift: ManagerHandoverShiftEntity(finalHandover: _handover),
        dailyTotals: _totals,
      ),
    );
  }
}

const _handover = FinalHandoverEndShiftEntity(
  handoverAmount: 40,
  status: 'pending',
  handoverFrom: 'manager',
  handoverTo: 'accountant',
  handoverDate: '2026-10-29',
  handoverTime: '00:27:00',
);
const _totals = DailyTotalsEntity(
  totalCashCollected: 40,
  totalCardPayments: 50,
  totalDeliveryApps: 25,
  totalVariance: 0,
  totalSales: 115,
  shiftDate: '2026-10-29',
);
const _endData = ManagerShiftEndDataEntity(
  finalHandover: _handover,
  dailyTotals: _totals,
);

FinalDailyCloseData _data(
  String id, {
  String date = '2026-10-29',
  bool twoShifts = false,
  bool apps = false,
}) {
  final rows = ['shift-a', if (twoShifts) 'shift-b']
      .map(
        (shift) => CashierBreakdownModel(
          cashierId: 'same-cashier',
          cashierShiftId: shift,
          expectedRevision: 3,
          cashierName: 'Cashier',
          cashCollected: 40,
          cardPayments: 50,
          deliveryAppPayments: 25,
          variance: -7,
          sales: 115,
        ),
      )
      .toList();
  return FinalDailyCloseData(
    managerWorkdayId: id,
    businessDate: date,
    serverTime: '2026-10-30T00:27:00+03:00',
    timezone: 'Asia/Riyadh',
    workdayDates: {'today': '2026-10-30', 'yesterday': '2026-10-29'},
    cashierBreakdown: rows,
    totals: Totals(
      totalCashCollected: 40,
      totalCardPayments: 50,
      totalDeliveryApps: 25,
      totalVariance: -7,
      totalSales: 115,
    ),
    aggregators: apps
        ? ['app-a', 'app-b']
              .map(
                (app) => AggregatorFinalDailyCloseModel(
                  id: app,
                  name: app,
                  total: app == 'app-a' ? 10 : 15,
                  cashierBreakdown: rows
                      .map(
                        (r) => CashierBreakdownFinalDailyCloseModel(
                          cashierId: r.cashierId,
                          cashierShiftId: r.cashierShiftId,
                          cashierName: r.cashierName,
                          amount: app == 'app-a' ? 10 : 15,
                          notes: null,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList()
        : [],
  );
}

Future<void> _load(
  FinalDailyCloseCubit c,
  _Repo repo,
  FinalDailyCloseData data,
) async {
  final future = c.getDailyClose();
  repo.pending.last.complete(ApiResult.success(data));
  await future;
}

void main() {
  test(
    'response preserves canonical workday, server date, timezone and per-shift app IDs',
    () {
      final data = _data('day-29', apps: true);
      final parsed = FinalDailyCloseData.fromJson(data.toJson());
      expect(parsed.managerWorkdayId, 'day-29');
      expect(parsed.businessDate, '2026-10-29');
      expect(parsed.timezone, 'Asia/Riyadh');
      expect(
        parsed.aggregators!.first.cashierBreakdown!.first.cashierShiftId,
        'shift-a',
      );
    },
  );

  test(
    'new workday selection clears rows and totals and ignores older responses',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      final today = cubit.getDailyClose(workday: 'today');
      final yesterday = cubit.selectWorkday('yesterday');
      expect(cubit.canSubmit, false);
      expect(cubit.cashiersBreakdown, isEmpty);
      expect(cubit.totals.totalSales, 0);
      repo.pending[1].complete(ApiResult.success(_data('day-29')));
      await yesterday;
      repo.pending[0].complete(
        ApiResult.success(_data('day-30', date: '2026-10-30')),
      );
      await today;
      expect(
        (cubit.state as FinalDailyCloseLoadedOrUpdated).managerWorkdayId,
        'day-29',
      );
      expect(cubit.canSubmit, true);
      await cubit.close();
    },
  );

  test(
    'refresh pins the returned ID across midnight and never uses a device date',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      final first = cubit.getDailyClose(workday: 'yesterday');
      repo.pending.last.complete(ApiResult.success(_data('day-29')));
      await first;
      final refresh = cubit.getDailyClose();
      expect(repo.queries.last.id, 'day-29');
      expect(repo.queries.last.relative, isNull);
      repo.pending.last.complete(ApiResult.success(_data('day-29')));
      await refresh;
      final command = EndAndUpdateManagerShiftCubit(repo);
      await command.endManagerShift(
        workday: cubit.state as FinalDailyCloseLoadedOrUpdated,
      );
      expect(repo.endRequests.single.toJson()['manager_workday_id'], 'day-29');
      expect(repo.endRequests.single.totalSales, 115);
      expect(repo.endRequests.single.cashierBreakdown!.single.sales, 115);
      expect(
        repo.endRequests.single.cashierBreakdown!.single.toJson(),
        isNot(contains('variance')),
      );
      await cubit.close();
      await command.close();
    },
  );

  test(
    'mismatching response ID is refused without stale editable data',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      final future = cubit.getDailyClose(managerWorkdayId: 'day-29');
      repo.pending.last.complete(ApiResult.success(_data('day-30')));
      await future;
      expect(cubit.state, isA<FinalDailyCloseFetchFailure>());
      expect(cubit.canSubmit, false);
      expect(cubit.cashiersBreakdown, isEmpty);
      await cubit.close();
    },
  );

  test(
    'same-cashier edits and correction reasons affect only the exact cashier shift',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      await _load(cubit, repo, _data('day-29', twoShifts: true));
      cubit.updateCashierField(
        cashierShiftId: 'shift-a',
        field: CashierField.cardPayments,
        value: 55,
      );
      expect(cubit.cashiersBreakdown[0].cardPayments, 55);
      expect(cubit.cashiersBreakdown[1].cardPayments, 50);
      expect(cubit.canSubmit, false);
      cubit.updateReason(
        cashierShiftId: 'shift-a',
        reason: 'POS card reconciliation',
      );
      expect(cubit.canSubmit, true);
      cubit.updateCashierField(
        cashierShiftId: 'shift-a',
        field: CashierField.variance,
        value: 900,
      );
      expect(cubit.cashiersBreakdown[0].variance, -7);
      final command = EndAndUpdateManagerShiftCubit(repo);
      await command.updateManagerHandoverShift(
        workday: cubit.state as FinalDailyCloseLoadedOrUpdated,
      );
      expect(repo.updates.single.managerWorkdayId, 'day-29');
      expect(
        repo.updates.single.cashierBreakdown[0].reason,
        'POS card reconciliation',
      );
      expect(repo.updates.single.cashierBreakdown[0].expectedRevision, 3);
      expect(repo.updates.single.cashierBreakdown[1].expectedRevision, isNull);
      await cubit.close();
      await command.close();
    },
  );

  test(
    'multi-app no-op omits correction metadata and preserves authoritative gross',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      await _load(cubit, repo, _data('day-29', apps: true));
      final command = EndAndUpdateManagerShiftCubit(repo);
      await command.updateManagerHandoverShift(
        workday: cubit.state as FinalDailyCloseLoadedOrUpdated,
      );
      final row = repo.updates.single.cashierBreakdown.single.toJson();
      expect(row['sales'], 115);
      expect(row['delivery_app_payments'], 25);
      expect(row.containsKey('aggregators'), false);
      expect(row.containsKey('expected_revision'), false);
      expect(row.containsKey('reason'), false);
      await cubit.close();
      await command.close();
    },
  );

  test(
    'same-total per-app reallocation remains a real per-shift correction',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      await _load(cubit, repo, _data('day-29', apps: true, twoShifts: true));
      cubit.updateCashierField(
        cashierShiftId: 'shift-a',
        field: CashierField.deliveryAppPayments,
        value: 500,
      );
      expect(
        cubit.cashiersBreakdown.first.deliveryAppPayments,
        25,
        reason: 'Scalar changes must not invent a multi-app allocation',
      );
      cubit.updateAggregatorAmount(
        cashierShiftId: 'shift-a',
        aggregatorId: 'app-a',
        newValue: 15,
      );
      cubit.updateAggregatorAmount(
        cashierShiftId: 'shift-a',
        aggregatorId: 'app-b',
        newValue: 10,
      );
      cubit.updateReason(
        cashierShiftId: 'shift-a',
        reason: 'Correct app attribution',
      );
      expect(cubit.cashiersBreakdown.first.deliveryAppPayments, 25);
      expect(cubit.cashiersBreakdown.first.isModified, true);
      expect(cubit.cashiersBreakdown.last.isModified, false);
      final command = EndAndUpdateManagerShiftCubit(repo);
      await command.updateManagerHandoverShift(
        workday: cubit.state as FinalDailyCloseLoadedOrUpdated,
      );
      expect(
        repo.updates.single.cashierBreakdown.first.aggregators!.map(
          (r) => r['amount'],
        ),
        [15, 10],
      );
      expect(repo.updates.single.cashierBreakdown.last.aggregators, isNull);
      await cubit.close();
      await command.close();
    },
  );

  test(
    'submission without authoritative loaded identity or correction revision is prevented',
    () async {
      final repo = _Repo();
      final command = EndAndUpdateManagerShiftCubit(repo);
      await command.endManagerShift(
        workday: FinalDailyCloseLoadedOrUpdated(
          cashiers: const [],
          totals: TotalsEntity.fromCashiers([]),
        ),
      );
      expect(repo.endRequests, isEmpty);
      expect(command.state, isA<EndManagerShiftFailure>());
      await command.close();
    },
  );

  test(
    'double click is dropped and identical retry retains the same durable key',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      await _load(cubit, repo, _data('day-29'));
      final snapshot = cubit.state as FinalDailyCloseLoadedOrUpdated;
      final command = EndAndUpdateManagerShiftCubit(repo);
      repo.holdEnd = Completer<ApiResult<ManagerShiftEndDataEntity>>();
      final first = command.endManagerShift(workday: snapshot);
      await command.endManagerShift(workday: snapshot);
      expect(repo.endRequests, hasLength(1));
      repo.holdEnd!.complete(ApiResult.success(_endData));
      await first;
      repo.holdEnd = null;
      await command.endManagerShift(workday: snapshot);
      expect(repo.keys[0], repo.keys[1]);
      expect(repo.keys[0], isNotNull);
      await cubit.close();
      await command.close();
    },
  );

  test(
    'undo from a different workday cannot restore stale rows or totals',
    () async {
      final repo = _Repo();
      final cubit = FinalDailyCloseCubit(repo);
      await _load(cubit, repo, _data('day-29'));
      cubit.undoChanges(
        managerWorkdayId: 'day-28',
        draftCashiers: [],
        draftTotals: TotalsEntity.fromCashiers([]),
        draftAggregators: [],
      );
      expect(cubit.cashiersBreakdown, hasLength(1));
      expect(cubit.totals.totalSales, 115);
      await cubit.close();
    },
  );
}
