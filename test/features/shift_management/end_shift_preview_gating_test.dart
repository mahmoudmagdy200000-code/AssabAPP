import 'dart:async';

import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/aggregator_entites.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_summary_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_with_handover_summary_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assab/generated/l10n.dart';

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

  FutureApiResult<void> Function(
    String shiftId,
    EndShiftRequestWithHandOver request,
  )? onEndShiftWithHandOver;

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
    return ApiResult.success({
      'data': {
        'cash_reconciliation': {
          'expected_cash': 40.0,
          'counted_cash': countedCash,
          'cash_variance': countedCash - 40.0,
          'cash_variance_type': countedCash == 40.0 ? 'balanced' : (countedCash < 40.0 ? 'shortage' : 'surplus'),
          'confirmed_opening_cash': 100.0,
          'pending_incoming_cash': 0.0,
        },
        'shortage_to_allocate': (countedCash < 40.0) ? (40.0 - countedCash) : 0.0,
        'allocation_required': countedCash < 40.0,
      }
    });
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

  @override
  FutureApiResult<void> endShiftWithHandOver(
    String shiftId,
    EndShiftRequestWithHandOver endShiftRequest,
  ) async {
    if (onEndShiftWithHandOver != null) {
      return onEndShiftWithHandOver!(shiftId, endShiftRequest);
    }
    return ApiResult.success(null);
  }
}

AggregatorEntity _fakeAggregator({required String id, required double totalAmount}) {
  return AggregatorEntity(
    id: id,
    name: 'Aggregator-$id',
    code: 'AGG-$id',
    logo: '',
    description: '',
    commissionRate: 0.1,
    commissionPercentage: '10%',
    status: const AggregatorStatusEntity(value: true, label: 'Active', color: 'green'),
    integrationType: 'pos',
    hasIntegration: false,
    branchesCount: 1,
    enabledBranchesCount: 1,
    createdAt: '',
    totalAmount: totalAmount,
  );
}

Widget buildTestAppWithCubit({
  required Widget child,
  required EndShiftCubit cubit,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    locale: const Locale('en'),
    theme: ThemeData(
      extensions: LightTheme.extension,
    ),
    home: BlocProvider<EndShiftCubit>.value(
      value: cubit,
      child: Builder(
        builder: (context) {
          AppResponsive.init(context, designWidth: 375, designHeight: 812);
          return Scaffold(body: SingleChildScrollView(child: child));
        },
      ),
    ),
  );
}

void main() {
  group('Group A & B: Async Navigation & Preview Failure Handling', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift-100', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('fetchCashReconciliationPreview returns false and emits failure if counted cash is null', () async {
      expect(cubit.countedCash, isNull);

      final success = await cubit.fetchCashReconciliationPreview();
      expect(success, isFalse);
      expect(cubit.state, isA<EndShiftPreviewFailure>());
      expect(cubit.canProceedToEndShift, isFalse);
    });

    test('fetchCashReconciliationPreview sets isPreviewLoading while in flight and returns true on success', () async {
      final completer = Completer<ApiResult<Map<String, dynamic>>>();
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) {
        return completer.future;
      };

      cubit.setCountedCash(40.0);
      expect(cubit.previewStale, isTrue);

      final future = cubit.fetchCashReconciliationPreview();
      expect(cubit.isPreviewLoading, isTrue);
      expect(cubit.state, isA<EndShiftPreviewLoading>());
      expect(cubit.canProceedToEndShift, isFalse);

      completer.complete(
        ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': 40.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 0.0,
            'allocation_required': false,
          }
        }),
      );

      final result = await future;
      expect(result, isTrue);
      expect(cubit.isPreviewLoading, isFalse);
      expect(cubit.previewStale, isFalse);
      expect(cubit.previewData, isNotNull);
      expect(cubit.state, isA<EndShiftPreviewSuccess>());
      expect(cubit.canProceedToEndShift, isTrue);
    });

    test('Group B: HTTP error or network failure returns false and emits EndShiftPreviewFailure without clearing inputs', () async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.failure(
          ValidationFailure(
            error: LocalErrorModel(message: 'Validation failed: Invalid cash figure', errors: null),
            icon: CupertinoIcons.exclamationmark_triangle,
            statusCode: 422,
            stackTrace: StackTrace.empty,
          ),
        );
      };

      cubit.setCountedCash(40.0);
      final result = await cubit.fetchCashReconciliationPreview();

      expect(result, isFalse);
      expect(cubit.state, isA<EndShiftPreviewFailure>());
      final failureState = cubit.state as EndShiftPreviewFailure;
      expect(failureState.failure.statusCode, equals(422));
      expect(cubit.countedCash, equals(40.0)); // Counted cash preserved for correction
      expect(cubit.previewData, isNull);
      expect(cubit.previewStale, isTrue);
      expect(cubit.canProceedToEndShift, isFalse);
    });
  });

  group('Group C: Request Generation ID & Input Fingerprint Protection', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift-100', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('Out-of-order in-flight preview response is silently dropped when inputs changed', () async {
      final slowCompleter = Completer<ApiResult<Map<String, dynamic>>>();
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) {
        return slowCompleter.future;
      };

      cubit.setCountedCash(50.0);
      final initialReqId = cubit.previewRequestId;

      // Start slow preview 1 with countedCash: 50.0
      final future1 = cubit.fetchCashReconciliationPreview();
      expect(cubit.previewRequestId, equals(initialReqId + 1));
      final req1Id = cubit.previewRequestId;

      // User changes counted cash to 75.0 before preview 1 completes
      cubit.setCountedCash(75.0);
      expect(cubit.previewRequestId, greaterThan(req1Id)); // Invalidation increments generation ID
      expect(cubit.previewStale, isTrue);

      // Now preview 1 arrives with stale data
      slowCompleter.complete(
        ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 50.0,
              'counted_cash': 50.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 0.0,
            'allocation_required': false,
          }
        }),
      );

      final success1 = await future1;
      expect(success1, isFalse); // Silently discarded!
      expect(cubit.previewData, isNull); // Stale data was NOT set!
      expect(cubit.previewStale, isTrue);
    });

    test('Updating sales values or aggregators invalidates preview and increments generation ID', () {
      cubit.setCountedCash(100.0);
      final reqIdBefore = cubit.previewRequestId;

      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 200.0,
        cashCollected: 100.0,
        cardPayments: 100.0,
        aggregators: [
          _fakeAggregator(id: '1', totalAmount: 50.0),
        ],
      );

      expect(cubit.previewRequestId, greaterThan(reqIdBefore));
      expect(cubit.previewStale, isTrue);
      expect(cubit.previewData, isNull);
      expect(cubit.canProceedToEndShift, isFalse);
    });
  });

  group('Group D: Financial Reconciliation Rules & Server-Authoritative Getters', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift-100', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('Balanced scenario: Gross 115, cards 50, apps 25, counted 40 -> 0 variance, balanced', () async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': 40.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 0.0,
            'allocation_required': false,
          }
        });
      };

      cubit.setCountedCash(40.0);
      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 115.0,
        cashCollected: 40.0,
        cardPayments: 50.0,
        aggregators: [
          _fakeAggregator(id: '1', totalAmount: 25.0),
        ],
      );

      final success = await cubit.fetchCashReconciliationPreview();
      expect(success, isTrue);
      expect(cubit.expectedCash, equals(40.0));
      expect(cubit.previewCountedCash, equals(40.0));
      expect(cubit.cashVariance, equals(0.0));
      expect(cubit.cashVarianceType, equals('balanced'));
      expect(cubit.confirmedOpeningCash, equals(100.0));
      expect(cubit.canProceedToEndShift, isTrue);
    });

    test('Shortage scenario: Counted 30, expected 40 -> variance -10, shortage', () async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': 30.0,
              'cash_variance': -10.0,
              'cash_variance_type': 'shortage',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 10.0,
            'allocation_required': true,
          }
        });
      };

      cubit.setCountedCash(30.0);
      final success = await cubit.fetchCashReconciliationPreview();
      expect(success, isTrue);
      expect(cubit.expectedCash, equals(40.0));
      expect(cubit.previewCountedCash, equals(30.0));
      expect(cubit.cashVariance, equals(-10.0));
      expect(cubit.cashVarianceType, equals('shortage'));
      // Allocation required but not yet allocated -> cannot proceed
      expect(cubit.canProceedToEndShift, isFalse);

      // Allocate exactly 10.0
      cubit.updateShortageAllocations([
        const CashShortageAllocation(responsibleType: 'cashier', responsibleId: '1', amount: 10.0),
      ]);
      expect(cubit.canProceedToEndShift, isTrue);
    });

    testWidgets('EndShiftSummaryWidget renders server-authoritative cash reconciliation', (tester) async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': 40.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 0.0,
            'allocation_required': false,
          }
        });
      };

      cubit.setCountedCash(40.0);
      await cubit.fetchCashReconciliationPreview();

      await tester.pumpWidget(
        buildTestAppWithCubit(
          cubit: cubit,
          child: const EndShiftSummaryWidget(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cash Reconciliation'), findsOneWidget);
      expect(find.text('Expected Cash'), findsOneWidget);
      expect(find.text('40.00'), findsWidgets);
      expect(find.text('balanced'), findsOneWidget);
    });

    testWidgets('EndShiftWithHandoverSummaryWidget renders server-authoritative cash reconciliation', (tester) async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': 30.0,
              'cash_variance': -10.0,
              'cash_variance_type': 'shortage',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 10.0,
            'allocation_required': true,
          }
        });
      };

      cubit.setCountedCash(30.0);
      await cubit.fetchCashReconciliationPreview();

      await tester.pumpWidget(
        buildTestAppWithCubit(
          cubit: cubit,
          child: const EndShiftWithHandoverSummaryWidget(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cash Reconciliation'), findsOneWidget);
      expect(find.text('Expected Cash'), findsOneWidget);
      expect(find.text('40.00'), findsWidgets);
      expect(find.text('30.00'), findsWidgets);
      expect(find.text('-10.00'), findsWidgets);
      expect(find.text('shortage'), findsOneWidget);
    });
  });

  group('Group E: Submit Button Gating on Summary Step', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift-100', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('canProceedToEndShift is false when previewData is null', () {
      cubit.setCountedCash(40.0);
      expect(cubit.previewData, isNull);
      expect(cubit.canProceedToEndShift, isFalse);
    });

    test('canProceedToEndShift is false when previewStale is true', () async {
      cubit.setCountedCash(40.0);
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.canProceedToEndShift, isTrue);

      // Now modify input -> makes preview stale
      cubit.setCountedCash(50.0);
      expect(cubit.previewStale, isTrue);
      expect(cubit.canProceedToEndShift, isFalse);
    });

    test('canProceedToEndShift is false when shortage allocation sum does not equal shortage', () async {
      repository.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 50.0,
              'counted_cash': 30.0,
              'cash_variance': -20.0,
              'cash_variance_type': 'shortage',
              'confirmed_opening_cash': 100.0,
            },
            'shortage_to_allocate': 20.0,
            'allocation_required': true,
          }
        });
      };

      cubit.setCountedCash(30.0);
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.canProceedToEndShift, isFalse);

      // Partial allocation: 15.0 allocated instead of 20.0
      cubit.updateShortageAllocations([
        const CashShortageAllocation(responsibleType: 'cashier', responsibleId: '1', amount: 15.0),
      ]);
      expect(cubit.canProceedToEndShift, isFalse);

      // Full allocation: 20.0 allocated
      cubit.updateShortageAllocations([
        const CashShortageAllocation(responsibleType: 'cashier', responsibleId: '1', amount: 15.0),
        const CashShortageAllocation(responsibleType: 'manager', responsibleId: '2', amount: 5.0),
      ]);
      expect(cubit.canProceedToEndShift, isTrue);
    });

    test('endShift rejects early if canProceedToEndShift is false', () async {
      final emptyVariance = Variance(
        responsibilityType: 'none',
        currentCashierAmount: 0.0,
        reason: '',
        otherCashiers: [],
        supportingFiles: [],
      );

      cubit.setCountedCash(40.0);
      // Attempt endShift before preview
      await cubit.endShift(variance: emptyVariance, isThereVariance: false);
      expect(cubit.state, isA<EndShiftFailure>());
      final failureState = cubit.state as EndShiftFailure;
      expect(
        failureState.failure.error.message,
        contains('Stale or missing preview. Please preview cash reconciliation first.'),
      );
    });
  });
}
