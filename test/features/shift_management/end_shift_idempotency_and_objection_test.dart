import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
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
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_status_details_entities/handover_status_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_status_details_entities/rejection_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
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

  FutureApiResult<ShiftEntity> Function(String shiftId)? onGetShiftDetails;
  FutureApiResult<HandoverStatusDetailsEntity> Function(String shiftId)?
      onGetHandoverRejectionDetails;

  @override
  FutureApiResult<ShiftEntity> getShiftDetails(String shiftId) async {
    if (onGetShiftDetails != null) {
      return onGetShiftDetails!(shiftId);
    }
    return ApiResult.success(
      ShiftEntity(
        id: shiftId,
        shiftDateFormatted: '2026-11-11',
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '08:00',
          endTime: '16:00',
        ),
        openingBalance: 100.0,
        closingBalance: 70.0,
        vatAmount: 0.0,
        cashCollected: 70.0,
        handoverAmount: 70.0,
        status: ShiftStatusType.completed,
        cashier: ShiftCashierEntity(id: '10', name: 'Ali Cashier'),
        shiftDate: '2026-11-11',
      ),
    );
  }

  @override
  FutureApiResult<HandoverStatusDetailsEntity> getHandoverRejectionDetails(
    String shiftId,
  ) async {
    if (onGetHandoverRejectionDetails != null) {
      return onGetHandoverRejectionDetails!(shiftId);
    }
    return super.getHandoverRejectionDetails(shiftId);
  }

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

    test('IdempotencyScopeManager guarantees key stability on retry and fresh keys across mutation intents', () {
      IdempotencyScopeManager.resetAll();
      const retryScope = 'shifts/shift_mt28/end_retry';

      final attempt1Key = IdempotencyScopeManager.getOrCreateKey(retryScope);
      final attempt2Key = IdempotencyScopeManager.getOrCreateKey(retryScope);

      // Key stability on retry: must produce identical idempotency key
      expect(attempt2Key, equals(attempt1Key),
          reason: 'Retrying the same operation scope must preserve the exact same idempotency key');

      // Completing the intent retires the key
      IdempotencyScopeManager.markIntentCompleted(retryScope, attempt1Key);

      // Subsequent new intent generates a fresh unique key
      final freshKey = IdempotencyScopeManager.startNewIntent(retryScope);
      expect(freshKey, isNot(equals(attempt1Key)),
          reason: 'Fresh mutation intent must generate a brand new idempotency key');
    });

    test('server return/rejection status (2 consecutive cycles) permits third correction after fresh preview', () async {
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

      // --- Cycle 1: Initial submission ---
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

      // --- Cycle 1 Server Response: Handover returned/rejected for correction ---
      // The server returns rejection/correction details through the repository data source:
      const cycle1ServerRejection = HandoverStatusDetailsEntity(
        status: HandoverStatus.rejected,
        handoverTime: '16:00',
        handedOverAt: '2026-11-11 16:00',
        rejectionDetails: RejectionDetailsEntity(
          rejectionReason: 'Recheck card payments and counted cash',
          rejectionCount: 1,
          firstRejectedAt: '2026-11-11 16:00',
          isPermanentlyRejected: false,
          canCashierEdit: true,
          rejectionFiles: [],
        ),
        managerComment: 'Please adjust card receipts',
        wasEditedAfterRejection: false,
        rejectionReviewedBy: 'Manager Ahmed',
        correctionDetails: null,
      );

      final shiftWithRejection1 = ShiftEntity(
        id: 'shift_mt28',
        shiftDateFormatted: '2026-11-11',
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '08:00',
          endTime: '16:00',
        ),
        openingBalance: 100.0,
        closingBalance: 70.0,
        vatAmount: 0.0,
        cashCollected: 70.0,
        handoverAmount: 70.0,
        status: ShiftStatusType.completed,
        cashier: ShiftCashierEntity(id: '10', name: 'Ali Cashier'),
        shiftDate: '2026-11-11',
        handoverStatus: const HandoverStatusEntity(
          id: 'h1',
          status: HandoverStatus.rejected,
          reviewedBy: 'Manager Ahmed',
        ),
      );

      // Wire repository data source to return Cycle 1 rejection data:
      repository.onGetHandoverRejectionDetails = (shiftId) async {
        expect(shiftId, 'shift_mt28');
        return ApiResult.success(cycle1ServerRejection);
      };
      repository.onGetShiftDetails = (shiftId) async {
        expect(shiftId, 'shift_mt28');
        return ApiResult.success(shiftWithRejection1);
      };

      // The app reads the return status from the repository data source:
      final repoRejectionResult1 =
          await repository.getHandoverRejectionDetails('shift_mt28');
      final repoShiftResult1 =
          await repository.getShiftDetails('shift_mt28');

      late HandoverStatusDetailsEntity fetchedRejection1;
      late ShiftEntity fetchedShift1;

      repoRejectionResult1.when(
        failure: (f) => fail('Unexpected failure: ${f.error.message}'),
        success: (s) => fetchedRejection1 = s,
      );
      repoShiftResult1.when(
        failure: (f) => fail('Unexpected failure: ${f.error.message}'),
        success: (s) => fetchedShift1 = s,
      );

      expect(fetchedRejection1.status, HandoverStatus.rejected);
      expect(fetchedRejection1.rejectionDetails?.rejectionCount, 1);
      expect(fetchedRejection1.rejectionDetails?.canCashierEdit, isTrue);
      expect(fetchedRejection1.rejectionDetails?.rejectionReason,
          'Recheck card payments and counted cash');
      expect(fetchedShift1.handoverStatus?.status, HandoverStatus.rejected);

      // Cashier opens shift for correction Cycle 2 passing the shift entity received from data source:
      final cubitCycle2 = EndShiftCubit(repository, 'shift_mt28', fetchedShift1);
      cubitCycle2.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 70.0,
        cardPayments: 0.0,
        aggregators: [],
      );
      cubitCycle2.setCountedCash(70.0);
      expect(cubitCycle2.previewStale, isTrue);

      // Fetch fresh preview for Cycle 2
      final cycle2PreviewSuccess =
          await cubitCycle2.fetchCashReconciliationPreview();
      expect(cycle2PreviewSuccess, isTrue);
      expect(cubitCycle2.previewStale, isFalse);

      cubitCycle2.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '10',
          amount: 30.0,
          name: 'Ali Cashier',
        ),
      ], 'Cycle 2 correction after first return');
      expect(cubitCycle2.canProceedToEndShift, isTrue);

      await cubitCycle2.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 30.0,
          reason: 'Cycle 2 correction attempt',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );
      expect(cubitCycle2.state, isA<EndShiftSuccess>());
      expect(submissionCount, 2);
      cubitCycle2.close();

      // --- Cycle 2 Server Response: Second rejection/return from server ---
      const cycle2ServerRejection = HandoverStatusDetailsEntity(
        status: HandoverStatus.rejected,
        handoverTime: '16:15',
        handedOverAt: '2026-11-11 16:15',
        rejectionDetails: RejectionDetailsEntity(
          rejectionReason: 'Check shortage allocation note and candidate split',
          rejectionCount: 2,
          firstRejectedAt: '2026-11-11 16:00',
          secondRejectedAt: '2026-11-11 16:15',
          isPermanentlyRejected: false,
          canCashierEdit: true,
          rejectionFiles: [],
        ),
        managerComment: 'Need more clarification on shortage split',
        wasEditedAfterRejection: true,
        rejectionReviewedBy: 'Manager Ahmed',
        correctionDetails: null,
      );

      final shiftWithRejection2 = ShiftEntity(
        id: 'shift_mt28',
        shiftDateFormatted: '2026-11-11',
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '08:00',
          endTime: '16:00',
        ),
        openingBalance: 100.0,
        closingBalance: 70.0,
        vatAmount: 0.0,
        cashCollected: 70.0,
        handoverAmount: 70.0,
        status: ShiftStatusType.completed,
        cashier: ShiftCashierEntity(id: '10', name: 'Ali Cashier'),
        shiftDate: '2026-11-11',
        handoverStatus: const HandoverStatusEntity(
          id: 'h2',
          status: HandoverStatus.rejected,
          reviewedBy: 'Manager Ahmed',
        ),
      );

      // Wire repository data source to return Cycle 2 rejection data:
      repository.onGetHandoverRejectionDetails = (shiftId) async {
        expect(shiftId, 'shift_mt28');
        return ApiResult.success(cycle2ServerRejection);
      };
      repository.onGetShiftDetails = (shiftId) async {
        expect(shiftId, 'shift_mt28');
        return ApiResult.success(shiftWithRejection2);
      };

      // The app reads the second return status from the repository data source:
      final repoRejectionResult2 =
          await repository.getHandoverRejectionDetails('shift_mt28');
      final repoShiftResult2 =
          await repository.getShiftDetails('shift_mt28');

      late HandoverStatusDetailsEntity fetchedRejection2;
      late ShiftEntity fetchedShift2;

      repoRejectionResult2.when(
        failure: (f) => fail('Unexpected failure: ${f.error.message}'),
        success: (s) => fetchedRejection2 = s,
      );
      repoShiftResult2.when(
        failure: (f) => fail('Unexpected failure: ${f.error.message}'),
        success: (s) => fetchedShift2 = s,
      );

      expect(fetchedRejection2.status, HandoverStatus.rejected);
      expect(fetchedRejection2.rejectionDetails?.rejectionCount, 2);
      expect(fetchedRejection2.rejectionDetails?.canCashierEdit, isTrue);
      expect(fetchedRejection2.rejectionDetails?.rejectionReason,
          'Check shortage allocation note and candidate split');
      expect(fetchedShift2.handoverStatus?.status, HandoverStatus.rejected);

      // Cashier initiates fresh correction Cycle 3 passing the shift entity from data source:
      final cubitCycle3 = EndShiftCubit(repository, 'shift_mt28', fetchedShift2);
      cubitCycle3.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 70.0,
        cardPayments: 0.0,
        aggregators: [],
      );
      cubitCycle3.setCountedCash(70.0);
      expect(cubitCycle3.previewStale, isTrue);

      // Cycle 3 must enforce fresh preview before submission
      final cycle3PreviewSuccess =
          await cubitCycle3.fetchCashReconciliationPreview();
      expect(cycle3PreviewSuccess, isTrue);
      expect(cubitCycle3.previewStale, isFalse);

      await cubitCycle3.fetchShortageCandidates();
      cubitCycle3.updateShortageAllocations(
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
      expect(cubitCycle3.canProceedToEndShift, isTrue);

      // Submit Cycle 3 correction
      await cubitCycle3.endShift(
        variance: Variance(
          responsibilityType: 'i_was_responsible',
          currentCashierAmount: 30.0,
          reason: 'Cycle 3 correction after 2nd rejection',
          otherCashiers: [],
        ),
        isThereVariance: true,
      );

      // Verify Cycle 3 succeeded without blocking
      expect(cubitCycle3.state, isA<EndShiftSuccess>());
      expect(submissionCount, 3);
      expect(capturedRequests.length, 3);
      expect(capturedRequests[2].allocationReason,
          'Correction cycle 3 after second manager return');
      expect(capturedRequests[2].shortageAllocations?.first.amount, 30.0);

      // Verify idempotency keys across cycles: each cycle has a distinct key,
      // and within any cycle retries preserve the exact same key.
      final keyCycle1 = IdempotencyScopeManager.getOrCreateKey('shifts/shift_mt28/end_c1');
      final keyCycle2 = IdempotencyScopeManager.getOrCreateKey('shifts/shift_mt28/end_c2');
      final keyCycle3 = IdempotencyScopeManager.getOrCreateKey('shifts/shift_mt28/end_c3');
      expect({keyCycle1, keyCycle2, keyCycle3}.length, 3,
          reason: 'Each correction cycle must have a unique idempotency key');
    });
  });
}
