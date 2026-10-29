import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/routing/app_router.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/cashier_breakdown_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/manager_end_shift_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/update_manager_handover_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/cashier_breakdown_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/daily_totals_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/final_handover_end_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_update_data_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';

class _FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockShiftManagementRepo extends ShiftManagementRepositoryImp {
  _MockShiftManagementRepo() : super(_FakeRemoteDataSource());

  int endManagerShiftCallCount = 0;
  int updateManagerHandoverCallCount = 0;
  EndManagerShiftRequestModel? lastEndRequest;
  UpdateManagerHandoverRequestModel? lastUpdateRequest;
  String? lastEndIdempotencyKey;
  String? lastUpdateIdempotencyKey;

  static const _dummyEndData = ManagerShiftEndDataEntity(
    finalHandover: FinalHandoverEndShiftEntity(
      handoverAmount: 500.0,
      status: 'pending',
      handoverFrom: 'mgr-1',
      handoverTo: 'acct-1',
      handoverDate: '2026-10-29',
      handoverTime: '22:00:00',
    ),
    dailyTotals: DailyTotalsEntity(
      totalCashCollected: 500.0,
      totalCardPayments: 500.0,
      totalDeliveryApps: 0.0,
      totalVariance: 0.0,
      totalSales: 1000.0,
      shiftDate: '2026-10-29',
    ),
  );

  static const _dummyUpdateData = ManagerShiftUpdateDataEntity(
    shift: ManagerHandoverShiftEntity(
      finalHandover: FinalHandoverEndShiftEntity(
        handoverAmount: 500.0,
        status: 'pending',
        handoverFrom: 'mgr-1',
        handoverTo: 'acct-1',
        handoverDate: '2026-10-29',
        handoverTime: '22:00:00',
      ),
    ),
    dailyTotals: DailyTotalsEntity(
      totalCashCollected: 500.0,
      totalCardPayments: 500.0,
      totalDeliveryApps: 0.0,
      totalVariance: 0.0,
      totalSales: 1000.0,
      shiftDate: '2026-10-29',
    ),
  );

  @override
  FutureApiResult<ManagerShiftEndDataEntity> endManagerShift({
    required EndManagerShiftRequestModel request,
    String? idempotencyKey,
  }) async {
    endManagerShiftCallCount++;
    lastEndRequest = request;
    lastEndIdempotencyKey = idempotencyKey;
    return ApiResult.success(_dummyEndData);
  }

  @override
  FutureApiResult<ManagerShiftUpdateDataEntity> updateManagerHandoverShift({
    required UpdateManagerHandoverRequestModel request,
    String? idempotencyKey,
  }) async {
    updateManagerHandoverCallCount++;
    lastUpdateRequest = request;
    lastUpdateIdempotencyKey = idempotencyKey;
    return ApiResult.success(_dummyUpdateData);
  }
}

void main() {
  group('Manager Daily Close - Variance Gating & Serialization Tests', () {
    test('CashierBreakdownRequestModel serializes correctly and omits variance completely', () {
      const model = CashierBreakdownRequestModel(
        cashierId: 'c-001',
        cashCollected: 150.0,
        cardPayments: 200.0,
        deliveryAppPayments: 50.0,
        sales: 400.0,
      );

      final json = model.toJson();

      expect(json.containsKey('variance'), isFalse,
          reason: 'Backend bulkUpdateCashierShifts explicitly throws 422 if variance key exists');
      expect(json['cashier_id'], equals('c-001'));
      expect(json['cash_collected'], equals(150.0));
      expect(json['card_payments'], equals(200.0));
      expect(json['delivery_app_payments'], equals(50.0));
      expect(json['sales'], equals(400.0));
    });

    test('EndManagerShiftRequestModel cashier_breakdown entries NEVER contain variance', () {
      const request = EndManagerShiftRequestModel(
        handoverTiming: HandoverTiming.today,
        totalSales: 1000.0,
        cashCollected: 400.0,
        cardPayments: 500.0,
        aggregatorPayments: 100.0,
        cashierBreakdown: [
          CashierBreakdownRequestModel(
            cashierId: 'c-001',
            cashCollected: 200.0,
            cardPayments: 250.0,
            deliveryAppPayments: 50.0,
            sales: 500.0,
          ),
          CashierBreakdownRequestModel(
            cashierId: 'c-002',
            cashCollected: 200.0,
            cardPayments: 250.0,
            deliveryAppPayments: 50.0,
            sales: 500.0,
          ),
        ],
      );

      final json = request.toJson();
      final breakdownList = json['cashier_breakdown'] as List<dynamic>;

      expect(breakdownList.length, equals(2));
      for (final item in breakdownList) {
        final itemMap = item as Map<String, dynamic>;
        expect(itemMap.containsKey('variance'), isFalse,
            reason: 'variance is derived and must not be present in payload');
      }
    });

    test('UpdateManagerHandoverRequestModel cashier_breakdown entries NEVER contain variance', () {
      const request = UpdateManagerHandoverRequestModel(
        cashierBreakdown: [
          CashierBreakdownRequestModel(
            cashierId: 'c-001',
            cashCollected: 300.0,
            cardPayments: 100.0,
            deliveryAppPayments: 0.0,
            sales: 400.0,
          ),
        ],
      );

      final json = request.toJson();
      final breakdownList = json['cashier_breakdown'] as List<dynamic>;
      final first = breakdownList.first as Map<String, dynamic>;

      expect(first.containsKey('variance'), isFalse);
    });

    test('CashierBreakdownModel deserializes server variance but omits it during toJson', () {
      final serverJson = {
        'cashier_id': 'c-001',
        'cashier_shift_id': 'cs-001',
        'expected_revision': 1,
        'cashier_name': 'Test Cashier',
        'cash_collected': 100.0,
        'card_payments': 200.0,
        'delivery_app_payments': 50.0,
        'variance': -15.5,
        'sales': 350.0,
      };

      final model = CashierBreakdownModel.fromJson(serverJson);
      expect(model.variance, equals(-15.5), reason: 'Server response variance must be readable for display');
      expect(model.cashierShiftId, equals('cs-001'));
      expect(model.expectedRevision, equals(1));

      final serialized = model.toJson();
      expect(serialized.containsKey('variance'), isFalse,
          reason: 'includeToJson: false must ensure variance is omitted when model is serialized');
      expect(serialized['cashier_shift_id'], equals('cs-001'));
      expect(serialized['expected_revision'], equals(1));
    });
  });

  group('EndAndUpdateManagerShiftCubit - Payload Construction & In-Flight Guards', () {
    test('endManagerShift constructs payload without variance and emits proper states', () async {
      final mockRepo = _MockShiftManagementRepo();
      final cubit = EndAndUpdateManagerShiftCubit(mockRepo);
      cubit.handoverTiming = HandoverTiming.today;

      final cashiers = [
        CashierBreakdownEntity(
          cashierId: 'c-1',
          cashierName: 'Cashier 1',
          cashCollected: 100.0,
          cardPayments: 150.0,
          deliveryAppPayments: 50.0,
          variance: 10.0,
          totalSales: 300.0,
        ),
      ];

      await cubit.endManagerShift(
        totalSales: 300.0,
        cashCollected: 100.0,
        cardPayments: 150.0,
        aggregatorPayments: 50.0,
        cashierBreakdown: cashiers,
      );

      expect(mockRepo.endManagerShiftCallCount, equals(1));
      expect(mockRepo.lastEndRequest, isNotNull);

      final lastBreakdown = mockRepo.lastEndRequest!.cashierBreakdown!;
      expect(lastBreakdown.length, equals(1));
      final serializedRow = lastBreakdown.first.toJson();
      expect(serializedRow.containsKey('variance'), isFalse);
      expect(cubit.state, isA<EndManagerShiftSuccess>());
    });

    test('In-flight guard prevents duplicate submission when state is loading', () async {
      final mockRepo = _MockShiftManagementRepo();
      final cubit = EndAndUpdateManagerShiftCubit(mockRepo);

      // Simulate loading state
      cubit.emit(EndManagerShiftButtonLoading());

      final cashiers = [
        CashierBreakdownEntity(
          cashierId: 'c-1',
          cashierName: 'Cashier 1',
          cashCollected: 100.0,
          cardPayments: 150.0,
          deliveryAppPayments: 50.0,
          variance: 0.0,
          totalSales: 300.0,
        ),
      ];

      // Attempt second call while in-flight
      await cubit.endManagerShift(
        totalSales: 300.0,
        cashCollected: 100.0,
        cardPayments: 150.0,
        aggregatorPayments: 50.0,
        cashierBreakdown: cashiers,
      );

      expect(mockRepo.endManagerShiftCallCount, equals(0),
          reason: 'In-flight double submission must be dropped');
    });

    test('5. Shift WITH variance != 0 asserts serialized sales EQUALS server total_sales (115), NOT variance-reduced value (85)', () async {
      final mockRepo = _MockShiftManagementRepo();
      final cubit = EndAndUpdateManagerShiftCubit(mockRepo);
      cubit.handoverTiming = HandoverTiming.today;

      // Server provided shift with gross total_sales = 115.0, cards = 50.0, apps = 25.0, cash = 40.0, variance = 30.0
      // Previous defect computed cashierTotal = (40 + 50 + 25) - 30 = 85.0 and sent sales: 85.0!
      final cashier = CashierBreakdownEntity(
        cashierId: 'cashier-101',
        cashierShiftId: 'shift-uuid-101',
        expectedRevision: 2,
        cashierName: 'Ahmad Cashier',
        cashCollected: 40.0,
        cardPayments: 50.0,
        deliveryAppPayments: 25.0,
        variance: 30.0,
        totalSales: 115.0,
      );

      await cubit.endManagerShift(
        totalSales: 115.0,
        cashCollected: 40.0,
        cardPayments: 50.0,
        aggregatorPayments: 25.0,
        cashierBreakdown: [cashier],
      );

      expect(mockRepo.endManagerShiftCallCount, equals(1));
      final serializedRow = mockRepo.lastEndRequest!.cashierBreakdown!.first.toJson();

      // Assert sales EQUALS server-provided total_sales (115.0), NOT variance-reduced value (85.0)
      expect(serializedRow['sales'], equals(115.0),
          reason: 'Gross sales must remain authoritative (115.0) and never reduced by variance');
      expect(serializedRow.containsKey('variance'), isFalse,
          reason: 'Payload must never contain variance key');
    });

    test('6. Pure review with NO manager edits is a NO-OP: carries no expected_revision/reason/idempotency-key', () async {
      final mockRepo = _MockShiftManagementRepo();
      final cubit = EndAndUpdateManagerShiftCubit(mockRepo);

      // Server provided cashier shift in daily close summary
      final serverCashier = CashierBreakdownEntity(
        cashierId: 'cashier-201',
        cashierShiftId: 'shift-uuid-201',
        expectedRevision: 5,
        cashierName: 'Fatima Cashier',
        cashCollected: 200.0,
        cardPayments: 200.0,
        deliveryAppPayments: 100.0,
        variance: 0.0,
        totalSales: 500.0,
      );

      // Manager reviews without making ANY edits: isModified must be false
      expect(serverCashier.isModified, isFalse);

      await cubit.updateManagerHandoverShift(
        cashierBreakdown: [serverCashier],
      );

      expect(mockRepo.updateManagerHandoverCallCount, equals(1));
      expect(mockRepo.lastUpdateIdempotencyKey, isNull,
          reason: 'Pure NO-OP review must omit Idempotency-Key header');

      final serializedRow = mockRepo.lastUpdateRequest!.cashierBreakdown.first.toJson();
      expect(serializedRow['cashier_id'], equals('cashier-201'));
      expect(serializedRow['cashier_shift_id'], equals('shift-uuid-201'));
      expect(serializedRow['sales'], equals(500.0));
      expect(serializedRow['cash_collected'], equals(200.0));
      expect(serializedRow['card_payments'], equals(200.0));
      expect(serializedRow['delivery_app_payments'], equals(100.0));

      // Assert NO expected_revision or reason sent on NO-OP
      expect(serializedRow.containsKey('expected_revision'), isFalse,
          reason: 'NO-OP report review must omit expected_revision');
      expect(serializedRow.containsKey('reason'), isFalse,
          reason: 'NO-OP report review must omit reason');
      expect(serializedRow.containsKey('variance'), isFalse);

      // Now verify that if manager DOES edit a field, expected_revision, reason, and idempotency key are attached
      final editedCashier = serverCashier.copyWith(cashCollected: 250.0);
      expect(editedCashier.isModified, isTrue);

      await cubit.updateManagerHandoverShift(
        cashierBreakdown: [editedCashier],
      );

      expect(mockRepo.updateManagerHandoverCallCount, equals(2));
      expect(mockRepo.lastUpdateIdempotencyKey, isNotNull,
          reason: 'Mutation requires Idempotency-Key');
      final editedRow = mockRepo.lastUpdateRequest!.cashierBreakdown.first.toJson();
      expect(editedRow['expected_revision'], equals(5));
      expect(editedRow['reason'], equals('Manager daily close correction'));
      expect(editedRow['cash_collected'], equals(250.0));
      expect(editedRow['sales'], equals(500.0), reason: 'Sales remains server gross sales even on cash edit');
    });

    test('7. Shortage, surplus, and multi-aggregator cases all preserve gross sales without variance contamination', () async {
      final mockRepo = _MockShiftManagementRepo();
      final cubit = EndAndUpdateManagerShiftCubit(mockRepo);

      // Case 7a: Shortage (variance > 0: sales 250.0, counted 220.0, shortage 30.0)
      final shortageCashier = CashierBreakdownEntity(
        cashierId: 'c-short',
        cashierShiftId: 'shift-short',
        cashierName: 'Short Cashier',
        cashCollected: 100.0,
        cardPayments: 80.0,
        deliveryAppPayments: 40.0,
        variance: 30.0,
        totalSales: 250.0,
      );

      // Case 7b: Surplus (variance < 0: sales 200.0, counted 220.0, surplus -20.0)
      final surplusCashier = CashierBreakdownEntity(
        cashierId: 'c-surplus',
        cashierShiftId: 'shift-surplus',
        cashierName: 'Surplus Cashier',
        cashCollected: 150.0,
        cardPayments: 50.0,
        deliveryAppPayments: 20.0,
        variance: -20.0,
        totalSales: 200.0,
      );

      // Case 7c: Multi-aggregator breakdown (multiple delivery apps: Jahez 50 + HungerStation 70 + Toyo 30 = 150.0)
      final multiAggCashier = CashierBreakdownEntity(
        cashierId: 'c-multiagg',
        cashierShiftId: 'shift-multiagg',
        cashierName: 'MultiAgg Cashier',
        cashCollected: 100.0,
        cardPayments: 100.0,
        deliveryAppPayments: 150.0,
        variance: 0.0,
        totalSales: 350.0,
      );

      // TotalsEntity must compute totalSales as sum of authoritative totalSales (250 + 200 + 350 = 800.0)
      final totals = TotalsEntity.fromCashiers([shortageCashier, surplusCashier, multiAggCashier]);
      expect(totals.totalSales, equals(800.0),
          reason: 'TotalsEntity totalSales must be sum of authoritative cashier totalSales, NOT variance-reduced cashierTotal');
      expect(totals.totalDeliveryApps, equals(210.0));
      expect(totals.totalVariance, equals(50.0));

      await cubit.updateManagerHandoverShift(
        cashierBreakdown: [shortageCashier, surplusCashier, multiAggCashier],
      );

      final breakdown = mockRepo.lastUpdateRequest!.cashierBreakdown;
      expect(breakdown[0].sales, equals(250.0), reason: 'Shortage case preserves gross sales (250.0)');
      expect(breakdown[0].toJson().containsKey('variance'), isFalse);

      expect(breakdown[1].sales, equals(200.0), reason: 'Surplus case preserves gross sales (200.0)');
      expect(breakdown[1].toJson().containsKey('variance'), isFalse);

      expect(breakdown[2].sales, equals(350.0), reason: 'Multi-aggregator case preserves gross sales (350.0)');
      expect(breakdown[2].deliveryAppPayments, equals(150.0));
      expect(breakdown[2].toJson().containsKey('variance'), isFalse);
    });
  });

  group('FinalDailyCloseCubit - Variance Immutability', () {
    test('CashierField.variance cannot be mutated; cashCollected can be updated', () {
      final mockRepo = _MockShiftManagementRepo();
      final cubit = FinalDailyCloseCubit(mockRepo);

      final initialCashiers = [
        CashierBreakdownEntity(
          cashierId: 'c-1',
          cashierName: 'Cashier 1',
          cashCollected: 100.0,
          cardPayments: 200.0,
          deliveryAppPayments: 50.0,
          variance: -25.0,
          totalSales: 350.0,
        ),
      ];

      cubit.cashierBreakDownAndTotalsData(
        cashiersBreakdown: initialCashiers,
        totals: TotalsEntity.fromCashiers(initialCashiers),
      );

      // Attempt to mutate variance
      cubit.updateCashierField(
        cashierId: 'c-1',
        field: CashierField.variance,
        value: 999.0,
      );

      final stateAfterVarianceAttempt = cubit.state as FinalDailyCloseLoadedOrUpdated;
      expect(stateAfterVarianceAttempt.cashiers.first.variance, equals(-25.0),
          reason: 'Variance must remain unchanged as it is server-derived');

      // Mutate cashCollected
      cubit.updateCashierField(
        cashierId: 'c-1',
        field: CashierField.cashCollected,
        value: 120.0,
      );

      final stateAfterCash = cubit.state as FinalDailyCloseLoadedOrUpdated;
      expect(stateAfterCash.cashiers.first.cashCollected, equals(120.0));
      expect(stateAfterCash.totals.totalCashCollected, equals(120.0));
    });
  });

  group('Account Statement Routing', () {
    test('AppRouter resolves AppRouteName.accountStatementScreen to a route building SeeAllPersonalCustodyActivities', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRouteName.accountStatementScreen),
      );

      expect(route, isA<MaterialPageRoute>());
      final materialRoute = route as MaterialPageRoute;

      final widget = materialRoute.builder(_FakeBuildContext());
      expect(widget.runtimeType.toString(), contains('MultiBlocProvider'));
    });
  });
}

class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
