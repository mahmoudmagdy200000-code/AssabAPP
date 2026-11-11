import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockShiftManagementRepository extends ShiftManagementRepositoryImp {
  MockShiftManagementRepository() : super(FakeRemoteDataSource());

  FutureApiResult<Map<String, dynamic>> Function({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  })? onPreview;

  FutureApiResult<void> Function({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  })? onEndShift;

  FutureApiResult<List<ShortageAllocationCandidate>> Function({
    required String shiftId,
  })? onCandidates;

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  }) async {
    if (onPreview != null) {
      return onPreview!(
        shiftId: shiftId,
        totalSales: totalSales,
        countedCash: countedCash,
        cardPayments: cardPayments,
        pendingIncomingCash: pendingIncomingCash,
        aggregators: aggregators,
      );
    }
    return ApiResult.success({
      'data': {
        'cash_reconciliation': {
          'expected_cash': 100.0,
          'counted_cash': countedCash,
          'cash_variance': countedCash - 100.0,
          'cash_variance_type': countedCash < 100.0 ? 'shortage' : 'balanced',
        },
        'shortage_to_allocate': countedCash < 100.0 ? 100.0 - countedCash : 0.0,
        'allocation_required': countedCash < 100.0,
      },
    });
  }

  @override
  FutureApiResult<List<ShortageAllocationCandidate>> getShortageAllocationCandidates({
    required String shiftId,
  }) async {
    if (onCandidates != null) {
      return onCandidates!(shiftId: shiftId);
    }
    return ApiResult.success([
      const ShortageAllocationCandidate(
        id: '10',
        name: 'Ali Cashier',
        type: 'cashier',
        role: 'كاشير',
      ),
    ]);
  }

  @override
  FutureApiResult<void> endShift({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  }) async {
    if (onEndShift != null) {
      return onEndShift!(
        shiftId: shiftId,
        endShiftRequest: endShiftRequest,
      );
    }
    return ApiResult.success(null);
  }
}

void main() {
  group('MT-28: Idempotency, Fresh Preview & Correction/Objection Contract Tests', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift_mt28', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('stale or missing preview rejects submission and enforces fresh preview', () async {
      cubit.setCountedCash(80.0);
      // Notice: preview was NOT called yet -> previewStale is true
      expect(cubit.previewStale, isTrue);

      await cubit.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 20.0,
          reason: '',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );

      expect(cubit.state, isA<EndShiftFailure>());
      final failure = (cubit.state as EndShiftFailure).failure;
      expect(
        failure.error.message,
        contains('Stale or missing preview'),
      );
    });

    test('modifying total sales invalidates preview and requires fresh reconciliation', () async {
      cubit.setCountedCash(80.0);
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.previewStale, isFalse);

      // User changes sales or counted cash after preview
      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 200.0,
        cashCollected: 80.0,
        cardPayments: 0.0,
        aggregators: [],
      );

      // previewStale must be true
      expect(cubit.previewStale, isTrue);

      // Submitting now fails due to stale preview guard
      await cubit.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 20.0,
          reason: '',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );
      expect(cubit.state, isA<EndShiftFailure>());
      expect(
        (cubit.state as EndShiftFailure).failure.error.message,
        contains('Stale or missing preview'),
      );
    });

    test('shortage allocation with objection/reason does not block handover submission', () async {
      cubit.setCountedCash(80.0); // shortage = 20.0
      await cubit.fetchCashReconciliationPreview();
      await cubit.fetchShortageCandidates();

      // Allocate the 20 SAR shortage to candidate 10 with objection reason
      cubit.updateShortageAllocations(
        [
          const CashShortageAllocation(
            responsibleType: 'cashier',
            responsibleId: '10',
            amount: 20.0,
            name: 'Ali Cashier',
          ),
        ],
        'Employee objects to cash shortage calculation due to aggregator delay',
      );

      bool endShiftCalled = false;
      EndShiftRequest? capturedRequest;
      repository.onEndShift = ({
        required String shiftId,
        required EndShiftRequest endShiftRequest,
      }) async {
        endShiftCalled = true;
        capturedRequest = endShiftRequest;
        return ApiResult.success(null);
      };

      await cubit.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 20.0,
          reason: 'Shortage allocated',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );

      expect(endShiftCalled, isTrue);
      expect(cubit.state, isA<EndShiftSuccess>());
      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.shortageAllocations, isNotNull);
      expect(capturedRequest!.shortageAllocations!.length, 1);
      expect(capturedRequest!.shortageAllocations!.first.responsibleId, '10');
      expect(capturedRequest!.shortageAllocations!.first.amount, 20.0);
      expect(
        capturedRequest!.allocationReason,
        'Employee objects to cash shortage calculation due to aggregator delay',
      );
    });

    test('IdempotencyInterceptor generates distinct key for mutating request and preserves header', () async {
      IdempotencyScopeManager.resetAll();
      final interceptor = IdempotencyInterceptor();
      final options1 = RequestOptions(
        path: 'shifts/shift_mt28/end',
        method: 'POST',
      );

      final handler1 = RequestInterceptorHandler();
      interceptor.onRequest(options1, handler1);

      final key1 = options1.headers['Idempotency-Key'];
      expect(key1, isNotNull);
      expect(key1.toString().isNotEmpty, isTrue);

      final options2 = RequestOptions(
        path: 'shifts/shift_mt28/end',
        method: 'POST',
        extra: {'force_new_intent': true},
      );

      final handler2 = RequestInterceptorHandler();
      interceptor.onRequest(options2, handler2);

      final key2 = options2.headers['Idempotency-Key'];
      expect(key2, isNotNull);
      expect(key2, isNot(equals(key1)));

      // GET request should not receive idempotency key
      final getOptions = RequestOptions(
        path: 'shifts/shift_mt28',
        method: 'GET',
      );
      final getHandler = RequestInterceptorHandler();
      interceptor.onRequest(getOptions, getHandler);
      expect(getOptions.headers['Idempotency-Key'], isNull);
    });

    test('repeated refusal or return for correction (2nd cycle) permits fresh correction submission without blocking', () async {
      int submissionCount = 0;
      final List<EndShiftRequest> capturedRequests = [];
      repository.onEndShift = ({
        required String shiftId,
        required EndShiftRequest endShiftRequest,
      }) async {
        submissionCount++;
        capturedRequests.add(endShiftRequest);
        return ApiResult.success(null);
      };

      // Cycle 1: initial submission
      cubit.setCountedCash(70.0);
      await cubit.fetchCashReconciliationPreview();
      await cubit.fetchShortageCandidates();
      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '10',
          amount: 30.0,
          name: 'Ali Cashier',
        ),
      ], 'Initial submission note');
      expect(cubit.canProceedToEndShift, isTrue);

      await cubit.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 30.0,
          reason: 'Cycle 1 initial submission',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );
      expect(cubit.state, isA<EndShiftSuccess>());
      expect(submissionCount, 1);

      // Cycle 1 Handover Rejected / Returned for correction by manager:
      // Manager requests correction with note: "Recheck card payments"
      // Cashier opens shift for correction Cycle 2:
      // Update figures & fetch fresh preview
      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 70.0,
        cardPayments: 0.0,
        aggregators: [],
      );
      cubit.setCountedCash(70.0);
      expect(cubit.previewStale, isTrue);
      // Fetch fresh preview for Cycle 2
      final cycle2PreviewSuccess = await cubit.fetchCashReconciliationPreview();
      expect(cycle2PreviewSuccess, isTrue);
      expect(cubit.previewStale, isFalse);

      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '10',
          amount: 30.0,
          name: 'Ali Cashier',
        ),
      ], 'Cycle 2 correction after first return');
      expect(cubit.canProceedToEndShift, isTrue);

      await cubit.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 30.0,
          reason: 'Cycle 2 correction attempt',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );
      expect(cubit.state, isA<EndShiftSuccess>());
      expect(submissionCount, 2);

      // Cycle 2 Second rejection / return for correction:
      // Manager rejects a second time with note: "Check shortage allocation"
      // Cashier initiates fresh correction Cycle 3:
      // Fresh preview + fresh shortage allocation
      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 70.0,
        cardPayments: 0.0,
        aggregators: [],
      );
      cubit.setCountedCash(70.0);
      expect(cubit.previewStale, isTrue);

      final cycle3PreviewSuccess = await cubit.fetchCashReconciliationPreview();
      expect(cycle3PreviewSuccess, isTrue);
      expect(cubit.previewStale, isFalse);

      await cubit.fetchShortageCandidates();
      cubit.updateShortageAllocations(
        [
          const CashShortageAllocation(
            responsibleType: 'cashier',
            responsibleId: '10',
            amount: 30.0,
            name: 'Ali Cashier',
          ),
        ],
        'Correction cycle 3 after second manager return',
      );
      expect(cubit.canProceedToEndShift, isTrue);

      // Submit Cycle 3 correction
      await cubit.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 30.0,
          reason: 'Cycle 3 correction after 2nd rejection',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );

      // Verify Cycle 3 succeeded without blocking
      expect(cubit.state, isA<EndShiftSuccess>());
      expect(submissionCount, 3);
      expect(capturedRequests.length, 3);
      expect(capturedRequests[2].allocationReason, 'Correction cycle 3 after second manager return');
      expect(capturedRequests[2].shortageAllocations?.first.amount, 30.0);

      // Also verify distinct idempotency keys across cycles
      final keyCycle1 = IdempotencyScopeManager.getOrCreateKey('shifts/shift_mt28/end_c1');
      final keyCycle2 = IdempotencyScopeManager.getOrCreateKey('shifts/shift_mt28/end_c2');
      final keyCycle3 = IdempotencyScopeManager.getOrCreateKey('shifts/shift_mt28/end_c3');
      expect({keyCycle1, keyCycle2, keyCycle3}.length, 3, reason: 'Each correction cycle must have a unique idempotency key');
    });
  });
}
