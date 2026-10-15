import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
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
    List<EndShiftAggregatorModel>? aggregators,
  })? onPreview;

  FutureApiResult<void> Function({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  })? onEndShift;

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    List<EndShiftAggregatorModel>? aggregators,
  }) async {
    if (onPreview != null) {
      return onPreview!(
        shiftId: shiftId,
        totalSales: totalSales,
        countedCash: countedCash,
        cardPayments: cardPayments,
        aggregators: aggregators,
      );
    }
    return ApiResult.success({});
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

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift-100', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('Empty / unentered counted cash is distinguished from legitimate 0.00', () async {
      expect(cubit.countedCash, isNull);

      // Attempt preview without entering counted cash -> failure
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.state, isA<EndShiftPreviewFailure>());

      // Enter legitimate zero 0.00
      cubit.setCountedCash(0.0);
      expect(cubit.countedCash, equals(0.0));
      expect(cubit.previewStale, isTrue);
    });

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

    test('Shortage preview sets allocationRequired: true with exact shortage', () async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'success': true,
          'data': {
            'cash_reconciliation': {
              'expected_cash': 600.0,
              'actual_cash': 550.0,
              'variance': -50.0,
              'cash_variance_type': 'shortage',
            },
            'shortage_to_allocate': 50.0,
            'allocation_required': true,
          },
        });
      };

      cubit.setCountedCash(550.0);
      await cubit.fetchCashReconciliationPreview();

      expect(cubit.state, isA<EndShiftPreviewSuccess>());
      final success = cubit.state as EndShiftPreviewSuccess;
      expect(success.allocationRequired, isTrue);
      expect(success.shortageToAllocate, equals(50.0));
      expect(success.cashVarianceType, equals('shortage'));
      expect(cubit.previewStale, isFalse);

      // Attempting endShift without allocations fails
      await cubit.endShift(variance: emptyVariance, isThereVariance: false);
      expect(cubit.state, isA<EndShiftFailure>());

      // Providing allocations that do NOT sum to 50.0 fails
      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '1',
          amount: 30.0,
        ),
      ]);
      await cubit.endShift(variance: emptyVariance, isThereVariance: false);
      expect(cubit.state, isA<EndShiftFailure>());

      // Providing allocations that sum to 50.0 succeeds
      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '1',
          amount: 30.0,
        ),
        const CashShortageAllocation(
          responsibleType: 'branch_manager',
          responsibleId: '2',
          amount: 20.0,
        ),
      ]);
      await cubit.endShift(variance: emptyVariance, isThereVariance: false);
      expect(cubit.state, isA<EndShiftSuccess>());
    });

    test('Surplus and Balanced previews set allocationRequired: false', () async {
      // 1. Surplus scenario
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'success': true,
          'data': {
            'cash_reconciliation': {
              'expected_cash': 500.0,
              'actual_cash': 520.0,
              'variance': 20.0,
              'cash_variance_type': 'surplus',
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

      // 2. Balanced scenario
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'success': true,
          'data': {
            'cash_reconciliation': {
              'expected_cash': 500.0,
              'actual_cash': 500.0,
              'variance': 0.0,
              'cash_variance_type': 'balanced',
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
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        expect(countedCash, equals(0.0));
        return ApiResult.success({
          'success': true,
          'data': {
            'cash_reconciliation': {
              'expected_cash': 300.0,
              'actual_cash': 0.0,
              'variance': -300.0,
              'cash_variance_type': 'shortage',
            },
            'shortage_to_allocate': 300.0,
            'allocation_required': true,
          },
        });
      };

      cubit.setCountedCash(0.0);
      await cubit.fetchCashReconciliationPreview();

      expect(cubit.state, isA<EndShiftPreviewSuccess>());
      final zeroState = cubit.state as EndShiftPreviewSuccess;
      expect(zeroState.shortageToAllocate, equals(300.0));
      expect(zeroState.allocationRequired, isTrue);
    });
  });
}
