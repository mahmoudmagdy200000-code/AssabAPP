import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/aggregator_entites.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
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
  })?
  onPreview;

  FutureApiResult<void> Function({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  })?
  onEndShift;

  FutureApiResult<List<ShortageAllocationCandidate>> Function({
    required String shiftId,
  })?
  onCandidates;

  @override
  FutureApiResult<List<ShortageAllocationCandidate>>
  getShortageAllocationCandidates({required String shiftId}) async {
    if (onCandidates != null) {
      return onCandidates!(shiftId: shiftId);
    }
    return ApiResult.success(const [
      ShortageAllocationCandidate(
        id: '1',
        name: 'Ahmed',
        type: 'cashier',
        role: 'cashier',
      ),
      ShortageAllocationCandidate(
        id: '2',
        name: 'Manager',
        type: 'branch_manager',
        role: 'branch_manager',
      ),
      ShortageAllocationCandidate(
        id: 'cand-1',
        name: 'Candidate 1',
        type: 'cashier',
        role: 'cashier',
      ),
    ]);
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
    return onPreview?.call(
          shiftId: shiftId,
          totalSales: totalSales,
          countedCash: countedCash,
          cardPayments: cardPayments,
          pendingIncomingCash: pendingIncomingCash,
          aggregators: aggregators,
        ) ??
        ApiResult.success({});
  }

  @override
  FutureApiResult<void> endShift({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  }) async {
    if (onEndShift != null) {
      return onEndShift!(shiftId: shiftId, endShiftRequest: endShiftRequest);
    }
    return ApiResult.success(null);
  }
}

void main() {
  group('EndShiftCubit Preview and Reconciliation Tests', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    final emptyVariance = Variance(
      responsibilityType: 'none',
      currentCashierAmount: 0.0,
      reason: '',
      otherCashiers: [],
      supportingFiles: [],
    );

    const deliveryApp = AggregatorEntity(
      id: 'delivery-1',
      name: 'Delivery',
      code: 'delivery',
      logo: '',
      description: '',
      commissionRate: 0,
      commissionPercentage: '',
      status: AggregatorStatusEntity(value: true, label: '', color: ''),
      integrationType: '',
      hasIntegration: false,
      branchesCount: 1,
      enabledBranchesCount: 1,
      createdAt: '',
      totalAmount: 0.20,
    );

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift-100', null);
    });

    tearDown(() {
      cubit.close();
    });

    test(
      'Empty / unentered counted cash is distinguished from legitimate 0.00',
      () async {
        expect(cubit.countedCash, isNull);

        // Attempt preview without entering counted cash -> failure
        await cubit.fetchCashReconciliationPreview();
        expect(cubit.state, isA<EndShiftPreviewFailure>());

        // Enter legitimate zero 0.00
        cubit.setCountedCash(0.0);
        expect(cubit.countedCash, equals(0.0));
        expect(cubit.previewStale, isTrue);
      },
    );

    test('Input changes invalidate previous preview and clear allocations', () {
      cubit.setCountedCash(500.0);
      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '1',
          amount: 50.0,
        ),
      ]);
      expect(cubit.shortageAllocations.length, equals(1));

      // Changing sales values triggers invalidation
      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 1500.0,
        cashCollected: 600.0,
        cardPayments: 900.0,
        aggregators: [],
      );

      expect(cubit.previewStale, isTrue);
      expect(cubit.previewData, isNull);
      expect(cubit.shortageAllocations, isEmpty);

      // Updating counted cash also directly emits EndShiftPreviewInvalidated
      cubit.setCountedCash(800.0);
      expect(cubit.state, isA<EndShiftPreviewInvalidated>());
    });

    test(
      'One cash input derives sales cash and still requires allocation of the drawer shortage',
      () async {
        repository.onPreview =
            ({
              required String shiftId,
              required double totalSales,
              required double countedCash,
              double? cardPayments,
              double? pendingIncomingCash,
              List<EndShiftAggregatorModel>? aggregators,
            }) async {
              expect(totalSales, 110.30);
              expect(countedCash, 30);
              expect(cardPayments, 70.10);
              expect(aggregators!.single.amount, 0.20);
              return ApiResult.success({
                'success': true,
                'data': {
                  'cash_reconciliation': {
                    'counted_cash': 30.0,
                    'expected_cash': 40.0,
                    'cash_variance': -10.0,
                    'cash_variance_type': 'shortage',
                    'pending_incoming_cash': 0.0,
                    'confirmed_opening_cash': 0.0,
                  },
                  'shortage_to_allocate': 10.0,
                  'allocation_required': true,
                },
              });
            };

        expect(
          await cubit.previewFromSalesInputs(
            totalSales: '١١٠٫٣٠',
            countedCash: '٣٠',
            cardPayments: '٧٠٫١٠',
            aggregators: [deliveryApp],
            isArabic: true,
          ),
          isTrue,
        );
        expect(cubit.cashCollected, 40);
        expect(cubit.varianceAmount, 0);

        expect(
          cubit.state,
          anyOf(
            isA<EndShiftPreviewSuccess>(),
            isA<EndShiftCandidatesSuccess>(),
          ),
        );
        expect(cubit.previewData, isNotNull);
        final previewMap = (cubit.previewData!['data'] is Map<String, dynamic>)
            ? cubit.previewData!['data'] as Map<String, dynamic>
            : cubit.previewData!;
        expect(previewMap['allocation_required'], isTrue);
        expect(previewMap['shortage_to_allocate'], equals(10.0));
        expect(previewMap['cash_reconciliation']['counted_cash'], equals(30.0));
        expect(
          previewMap['cash_reconciliation']['cash_variance'],
          equals(-10.0),
        );
        expect(cubit.previewStale, isFalse);

        // Attempting endShift without allocations fails
        await cubit.endShift(variance: emptyVariance, isThereVariance: false);
        expect(cubit.state, isA<EndShiftFailure>());

        // Providing allocations that do NOT sum to 10.0 fails
        cubit.updateShortageAllocations([
          const CashShortageAllocation(
            responsibleType: 'cashier',
            responsibleId: '1',
            amount: 6.0,
          ),
        ]);
        await cubit.endShift(variance: emptyVariance, isThereVariance: false);
        expect(cubit.state, isA<EndShiftFailure>());

        // Providing allocations that sum to 10.0 succeeds
        cubit.updateShortageAllocations([
          const CashShortageAllocation(
            responsibleType: 'cashier',
            responsibleId: '1',
            amount: 6.0,
          ),
          const CashShortageAllocation(
            responsibleType: 'branch_manager',
            responsibleId: '2',
            amount: 4.0,
          ),
        ]);
        repository.onEndShift =
            ({required shiftId, required endShiftRequest}) async {
              final fields = Map.fromEntries(
                (await endShiftRequest.toFormData()).fields,
              );
              expect(fields['cash_collected'], '40.0');
              expect(fields['counted_cash'], '30.00');
              expect(endShiftRequest.shortageAllocations, hasLength(2));
              return ApiResult.success(null);
            };
        await cubit.endShift(variance: emptyVariance, isThereVariance: false);
        expect(cubit.state, isA<EndShiftSuccess>());
      },
    );

    test(
      'Payment details at halala precision can match sales with zero cash',
      () async {
        expect(
          await cubit.previewFromSalesInputs(
            totalSales: '0.30',
            countedCash: '0',
            cardPayments: '0.10',
            aggregators: [deliveryApp],
            isArabic: false,
          ),
          isTrue,
        );
        expect(cubit.countedCash, 0);
        expect(cubit.cashCollected, 0);
        expect(cubit.varianceAmount, 0);
      },
    );

    test(
      'Payment details exceeding sales are rejected before preview',
      () async {
        repository.onPreview =
            ({
              required shiftId,
              required totalSales,
              required countedCash,
              cardPayments,
              pendingIncomingCash,
              aggregators,
            }) async => fail('Invalid payment details reached the API');

        expect(
          await cubit.previewFromSalesInputs(
            totalSales: '0.29',
            countedCash: '0',
            cardPayments: '0.10',
            aggregators: [deliveryApp],
            isArabic: false,
          ),
          isFalse,
        );
        expect(cubit.state, isA<EndShiftPreviewFailure>());
        expect(cubit.previewStale, isTrue);
      },
    );

    test('Surplus and Balanced previews set allocationRequired: false', () async {
      // 1. Surplus scenario
      repository.onPreview =
          ({
            required String shiftId,
            required double totalSales,
            required double countedCash,
            double? cardPayments,
            double? pendingIncomingCash,
            List<EndShiftAggregatorModel>? aggregators,
          }) async {
            return ApiResult.success({
              'success': true,
              'data': {
                'cash_reconciliation': {
                  'counted_cash': 520.0,
                  'expected_cash': 500.0,
                  'cash_variance': 20.0,
                  'cash_variance_type': 'surplus',
                  'pending_incoming_cash': 0.0,
                  'confirmed_opening_cash': 0.0,
                },
                'shortage_to_allocate': 0.0,
                'allocation_required': false,
              },
            });
          };

      cubit.setCountedCash(520.0);
      await cubit.fetchCashReconciliationPreview();

      expect(cubit.state, isA<EndShiftPreviewSuccess>());
      final surplusState = cubit.state as EndShiftPreviewSuccess;
      expect(surplusState.allocationRequired, isFalse);
      expect(surplusState.shortageToAllocate, equals(0.0));
      expect(surplusState.cashVarianceType, equals('surplus'));
      expect(
        surplusState.previewData['cash_reconciliation']['counted_cash'],
        equals(520.0),
      );
      expect(
        surplusState.previewData['cash_reconciliation']['cash_variance'],
        equals(20.0),
      );

      // 2. Balanced scenario
      repository.onPreview =
          ({
            required String shiftId,
            required double totalSales,
            required double countedCash,
            double? cardPayments,
            double? pendingIncomingCash,
            List<EndShiftAggregatorModel>? aggregators,
          }) async {
            return ApiResult.success({
              'success': true,
              'data': {
                'cash_reconciliation': {
                  'counted_cash': 500.0,
                  'expected_cash': 500.0,
                  'cash_variance': 0.0,
                  'cash_variance_type': 'balanced',
                  'pending_incoming_cash': 0.0,
                  'confirmed_opening_cash': 0.0,
                },
                'shortage_to_allocate': 0.0,
                'allocation_required': false,
              },
            });
          };

      cubit.setCountedCash(500.0);
      await cubit.fetchCashReconciliationPreview();

      final balancedState = cubit.state as EndShiftPreviewSuccess;
      expect(balancedState.allocationRequired, isFalse);
      expect(balancedState.shortageToAllocate, equals(0.0));
      expect(balancedState.cashVarianceType, equals('balanced'));
      expect(
        balancedState.previewData['cash_reconciliation']['counted_cash'],
        equals(500.0),
      );
      expect(
        balancedState.previewData['cash_reconciliation']['cash_variance'],
        equals(0.0),
      );

      // If allocations are mistakenly provided for balanced/surplus, submission fails closed
      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '1',
          amount: 10.0,
        ),
      ]);
      await cubit.endShift(variance: emptyVariance, isThereVariance: false);
      expect(cubit.state, isA<EndShiftFailure>());

      // With empty allocations, submission succeeds
      cubit.updateShortageAllocations([]);
      await cubit.endShift(variance: emptyVariance, isThereVariance: false);
      expect(cubit.state, isA<EndShiftSuccess>());
    });

    test('Zero counted cash scenario is supported and reconciled', () async {
      repository.onPreview =
          ({
            required String shiftId,
            required double totalSales,
            required double countedCash,
            double? cardPayments,
            double? pendingIncomingCash,
            List<EndShiftAggregatorModel>? aggregators,
          }) async {
            expect(countedCash, equals(0.0));
            return ApiResult.success({
              'success': true,
              'data': {
                'cash_reconciliation': {
                  'counted_cash': 0.0,
                  'expected_cash': 300.0,
                  'cash_variance': -300.0,
                  'cash_variance_type': 'shortage',
                  'pending_incoming_cash': 0.0,
                  'confirmed_opening_cash': 0.0,
                },
                'shortage_to_allocate': 300.0,
                'allocation_required': true,
              },
            });
          };

      cubit.setCountedCash(0.0);
      await cubit.fetchCashReconciliationPreview();

      expect(
        cubit.state,
        anyOf(isA<EndShiftPreviewSuccess>(), isA<EndShiftCandidatesSuccess>()),
      );
      expect(cubit.previewData, isNotNull);
      final zeroPreview = (cubit.previewData!['data'] is Map<String, dynamic>)
          ? cubit.previewData!['data'] as Map<String, dynamic>
          : cubit.previewData!;
      expect(zeroPreview['shortage_to_allocate'], equals(300.0));
      expect(zeroPreview['allocation_required'], isTrue);
      expect(zeroPreview['cash_reconciliation']['counted_cash'], equals(0.0));
      expect(
        zeroPreview['cash_reconciliation']['cash_variance'],
        equals(-300.0),
      );
    });
  });
}
