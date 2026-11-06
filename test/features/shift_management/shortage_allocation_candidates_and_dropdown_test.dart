import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/cash_shortage_allocation_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockShiftManagementRepository extends ShiftManagementRepositoryImp {
  MockShiftManagementRepository() : super(FakeRemoteDataSource());

  FutureApiResult<List<ShortageAllocationCandidate>> Function({
    required String shiftId,
  })? onCandidates;

  FutureApiResult<Map<String, dynamic>> Function({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    List<EndShiftAggregatorModel>? aggregators,
  })? onPreview;

  @override
  FutureApiResult<List<ShortageAllocationCandidate>> getShortageAllocationCandidates({
    required String shiftId,
  }) async {
    if (onCandidates != null) {
      return onCandidates!(shiftId: shiftId);
    }
    return ApiResult.success([]);
  }

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
          'cash_variance_type': 'shortage',
        },
        'shortage_to_allocate': 20.0,
        'allocation_required': true,
      },
    });
  }
}

Widget buildTestableWidget(Widget child, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(
      extensions: LightTheme.extension,
    ),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          AppResponsive.init(context, designWidth: 375, designHeight: 812);
          return SingleChildScrollView(child: child);
        },
      ),
    ),
  );
}

void main() {
  group('ShortageAllocationCandidate Model', () {
    test('fromJson & toJson serialization preserves all fields', () {
      final json = {
        'id': '101',
        'name': 'Ahmed Cashier',
        'type': 'cashier',
        'role': 'كاشير',
        'employee_number': 'EMP-101',
      };

      final candidate = ShortageAllocationCandidate.fromJson(json);
      expect(candidate.id, '101');
      expect(candidate.name, 'Ahmed Cashier');
      expect(candidate.type, 'cashier');
      expect(candidate.role, 'كاشير');
      expect(candidate.employeeNumber, 'EMP-101');

      final serialized = candidate.toJson();
      expect(serialized['id'], '101');
      expect(serialized['name'], 'Ahmed Cashier');
      expect(serialized['type'], 'cashier');
      expect(serialized['role'], 'كاشير');
      expect(serialized['employee_number'], 'EMP-101');
    });

    test('fromJson handles null employee_number and default type gracefully', () {
      final json = {
        'id': 202,
        'name': 'Manager Khaled',
        'role': 'مدير فرع',
      };

      final candidate = ShortageAllocationCandidate.fromJson(json);
      expect(candidate.id, '202');
      expect(candidate.name, 'Manager Khaled');
      expect(candidate.type, 'cashier');
      expect(candidate.employeeNumber, isNull);
    });
  });

  group('EndShiftCubit Candidate Integration', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift_123', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('fetchShortageCandidates success updates state and properties', () async {
      final mockCandidates = [
        const ShortageAllocationCandidate(
          id: '1',
          name: 'Ali Cashier',
          type: 'cashier',
          role: 'كاشير',
        ),
        const ShortageAllocationCandidate(
          id: '2',
          name: 'Omar Manager',
          type: 'branch_manager',
          role: 'مدير فرع',
        ),
      ];

      repository.onCandidates = ({required String shiftId}) async {
        expect(shiftId, 'shift_123');
        return ApiResult.success(mockCandidates);
      };

      expect(cubit.shortageCandidates, isEmpty);
      expect(cubit.isLoadingCandidates, isFalse);
      expect(cubit.candidatesError, isNull);

      final future = cubit.fetchShortageCandidates();
      expect(cubit.isLoadingCandidates, isTrue);

      await future;

      expect(cubit.isLoadingCandidates, isFalse);
      expect(cubit.candidatesError, isNull);
      expect(cubit.shortageCandidates.length, 2);
      expect(cubit.shortageCandidates[0].name, 'Ali Cashier');
      expect(cubit.shortageCandidates[1].name, 'Omar Manager');
      expect(cubit.state, isA<EndShiftCandidatesSuccess>());
    });

    test('fetchShortageCandidates failure sets candidatesError', () async {
      repository.onCandidates = ({required String shiftId}) async {
        return ApiResult.failure(
          ValidationFailure(
            error: LocalErrorModel(
              message: 'فشل في الاتصال بالخادم',
              errors: null,
            ),
            icon: CupertinoIcons.exclamationmark_triangle,
            statusCode: 500,
            stackTrace: StackTrace.empty,
          ),
        );
      };

      await cubit.fetchShortageCandidates();

      expect(cubit.isLoadingCandidates, isFalse);
      expect(cubit.shortageCandidates, isEmpty);
      expect(cubit.candidatesError, 'فشل في الاتصال بالخادم');
      expect(cubit.state, isA<EndShiftCandidatesFailure>());
    });

    test('fetchCashReconciliationPreview triggers candidate fetch when allocation required', () async {
      final mockCandidates = [
        const ShortageAllocationCandidate(
          id: '1',
          name: 'Ali Cashier',
          type: 'cashier',
          role: 'كاشير',
        ),
      ];

      bool candidatesFetched = false;
      repository.onCandidates = ({required String shiftId}) async {
        candidatesFetched = true;
        return ApiResult.success(mockCandidates);
      };

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
            },
            'shortage_to_allocate': 20.0,
            'allocation_required': true,
          },
        });
      };

      cubit.setCountedCash(30.0);
      final result = await cubit.fetchCashReconciliationPreview();

      expect(result, isTrue);
      expect(candidatesFetched, isTrue);
      expect(cubit.shortageCandidates.length, 1);
    });

    test('invalidatePreview clears candidates and error state', () async {
      cubit.setCountedCash(30.0);
      await cubit.fetchShortageCandidates();

      cubit.invalidatePreview();

      expect(cubit.previewStale, isTrue);
      expect(cubit.shortageCandidates, isEmpty);
      expect(cubit.isLoadingCandidates, isFalse);
      expect(cubit.candidatesError, isNull);
    });
  });

  group('CashShortageAllocationWidget UI & Dropdown', () {
    final sampleCandidates = [
      const ShortageAllocationCandidate(
        id: '10',
        name: 'سالم الكاشير',
        type: 'cashier',
        role: 'كاشير',
      ),
      const ShortageAllocationCandidate(
        id: '11',
        name: 'ياسر كاشير مسائي',
        type: 'cashier',
        role: 'كاشير',
      ),
      const ShortageAllocationCandidate(
        id: '20',
        name: 'سعد مدير الفرع',
        type: 'branch_manager',
        role: 'مدير فرع',
      ),
      const ShortageAllocationCandidate(
        id: '30',
        name: 'فهد موظف استقبال',
        type: 'employee',
        role: 'موظف',
      ),
    ];

    testWidgets('renders candidates dropdown populated with matching role', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            candidates: sampleCandidates,
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and cards
      expect(find.text('توزيع العجز النقدي'), findsOneWidget);
      expect(find.text('إجمالي العجز'), findsOneWidget);
      expect(find.text('20.00 ر.س'), findsWidgets);

      // Check candidate dropdown is present
      expect(find.text('اختر المسؤول (الاسم ومعرف النظام)'), findsOneWidget);
    });

    testWidgets('shows loading state when isLoadingCandidates is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            isLoadingCandidates: true,
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('جاري تحميل قائمة المسؤولين...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error box and retry button when candidatesError is set', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            candidatesError: 'فشل الاتصال بالشبكة',
            onRetryCandidates: () {
              retried = true;
            },
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('فشل الاتصال بالشبكة'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);

      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pumpAndSettle();

      expect(retried, isTrue);
    });

    testWidgets('shows empty helper when no candidates of selected role exist', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            candidates: const [
              ShortageAllocationCandidate(
                id: '20',
                name: 'سعد مدير الفرع',
                type: 'branch_manager',
                role: 'مدير فرع',
              ),
            ],
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Current selected type is 'cashier' by default, but only 'branch_manager' exists
      expect(find.text('لا يوجد كاشير متاح في هذا الفرع.'), findsOneWidget);
    });

    testWidgets('adding allocation with valid candidate updates allocations list', (tester) async {
      List<CashShortageAllocation> emittedAllocs = [];

      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            candidates: sampleCandidates,
            onAllocationsChanged: (allocs) {
              emittedAllocs = allocs;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the candidate dropdown to open menu
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();

      // Tap the first cashier
      await tester.tap(find.text('سالم الكاشير (ID: 10)').last);
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField).first, '20.0');
      await tester.pumpAndSettle();

      // Tap 'إضافة'
      await tester.tap(find.text('إضافة'));
      await tester.pumpAndSettle();

      expect(emittedAllocs.length, 1);
      expect(emittedAllocs[0].responsibleId, '10');
      expect(emittedAllocs[0].name, 'سالم الكاشير');
      expect(emittedAllocs[0].amount, 20.0);
      expect(emittedAllocs[0].responsibleType, 'cashier');

      // Allocation complete state badge
      expect(find.text('مكتمل'), findsOneWidget);
    });

    testWidgets('supports English LTR layout properly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            candidates: sampleCandidates,
            onAllocationsChanged: (_) {},
          ),
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('توزيع العجز النقدي'), findsOneWidget);
      expect(find.text('اختر المسؤول (الاسم ومعرف النظام)'), findsOneWidget);
    });
  });
}
