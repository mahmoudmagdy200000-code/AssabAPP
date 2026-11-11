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
  })?
  onCandidates;

  FutureApiResult<Map<String, dynamic>> Function({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  })?
  onPreview;

  @override
  FutureApiResult<List<ShortageAllocationCandidate>>
  getShortageAllocationCandidates({required String shiftId}) async {
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
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  }) async {
    final callback = onPreview;
    if (callback != null) {
      return callback(
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
    theme: ThemeData(extensions: LightTheme.extension),
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
      expect(candidate.isValid, isTrue);

      final serialized = candidate.toJson();
      expect(serialized['id'], '101');
      expect(serialized['name'], 'Ahmed Cashier');
      expect(serialized['type'], 'cashier');
      expect(serialized['role'], 'كاشير');
      expect(serialized['employee_number'], 'EMP-101');
    });

    test(
      'fromJson handles null employee_number and does NOT default to cashier when type is missing',
      () {
        final json = {'id': 202, 'name': 'Manager Khaled', 'role': 'مدير فرع'};

        final candidate = ShortageAllocationCandidate.fromJson(json);
        expect(candidate.id, '202');
        expect(candidate.name, 'Manager Khaled');
        expect(candidate.type, '');
        expect(candidate.isValid, isFalse);
        expect(candidate.employeeNumber, isNull);
      },
    );

    test('isValid validates id, name, and allowed types', () {
      expect(
        const ShortageAllocationCandidate(
          id: '1',
          name: 'A',
          type: 'cashier',
          role: '',
        ).isValid,
        isTrue,
      );
      expect(
        const ShortageAllocationCandidate(
          id: '2',
          name: 'B',
          type: 'branch_manager',
          role: '',
        ).isValid,
        isTrue,
      );
      expect(
        const ShortageAllocationCandidate(
          id: '3',
          name: 'C',
          type: 'employee',
          role: '',
        ).isValid,
        isTrue,
      );
      expect(
        const ShortageAllocationCandidate(
          id: '4',
          name: 'D',
          type: 'invalid_role',
          role: '',
        ).isValid,
        isFalse,
      );
      expect(
        const ShortageAllocationCandidate(
          id: '',
          name: 'E',
          type: 'cashier',
          role: '',
        ).isValid,
        isFalse,
      );
      expect(
        const ShortageAllocationCandidate(
          id: '5',
          name: '',
          type: 'cashier',
          role: '',
        ).isValid,
        isFalse,
      );
    });
  });

  group('EndShiftCubit Candidate Integration & Race Condition Protection', () {
    late MockShiftManagementRepository repository;
    late EndShiftCubit cubit;

    setUp(() {
      repository = MockShiftManagementRepository();
      cubit = EndShiftCubit(repository, 'shift_123', null);
    });

    tearDown(() {
      cubit.close();
    });

    test(
      'fetchShortageCandidates success updates state and properties',
      () async {
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
      },
    );

    test(
      'fetchShortageCandidates filters out invalid or incomplete candidates',
      () async {
        final mixedCandidates = [
          const ShortageAllocationCandidate(
            id: '1',
            name: 'Ali Cashier',
            type: 'cashier',
            role: 'كاشير',
          ),
          const ShortageAllocationCandidate(
            id: '2',
            name: 'Incomplete Staff',
            type: '', // Missing type
            role: '',
          ),
          const ShortageAllocationCandidate(
            id: '', // Missing ID
            name: 'No ID Staff',
            type: 'employee',
            role: '',
          ),
        ];

        repository.onCandidates = ({required String shiftId}) async {
          return ApiResult.success(mixedCandidates);
        };

        await cubit.fetchShortageCandidates();

        expect(cubit.shortageCandidates.length, 1);
        expect(cubit.shortageCandidates[0].id, '1');
        expect(cubit.shortageCandidates[0].name, 'Ali Cashier');
      },
    );

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

    test('fetchShortageCandidates failure with 403 Forbidden sets candidatesError and emits failure', () async {
      repository.onCandidates = ({required String shiftId}) async {
        return ApiResult.failure(
          ValidationFailure(
            error: LocalErrorModel(
              message: 'غير مصرح لك باستعراض قائمة مسؤولي العجز في هذا الفرع',
              errors: null,
            ),
            icon: CupertinoIcons.lock,
            statusCode: 403,
            stackTrace: StackTrace.empty,
          ),
        );
      };

      await cubit.fetchShortageCandidates();

      expect(cubit.isLoadingCandidates, isFalse);
      expect(cubit.shortageCandidates, isEmpty);
      expect(cubit.candidatesError, 'غير مصرح لك باستعراض قائمة مسؤولي العجز في هذا الفرع');
      expect(cubit.state, isA<EndShiftCandidatesFailure>());
      final failState = cubit.state as EndShiftCandidatesFailure;
      expect(failState.failure.statusCode, 403);
    });

    test('fetchShortageCandidates with empty candidate list returns empty list and emits success', () async {
      repository.onCandidates = ({required String shiftId}) async {
        return ApiResult.success([]);
      };

      await cubit.fetchShortageCandidates();

      expect(cubit.isLoadingCandidates, isFalse);
      expect(cubit.shortageCandidates, isEmpty);
      expect(cubit.candidatesError, isNull);
      expect(cubit.state, isA<EndShiftCandidatesSuccess>());
      final successState = cubit.state as EndShiftCandidatesSuccess;
      expect(successState.candidates, isEmpty);
    });

    test(
      'out-of-order in-flight candidate response is dropped when preview is invalidated',
      () async {
        final completer =
            Completer<ApiResult<List<ShortageAllocationCandidate>>>();
        repository.onCandidates = ({required String shiftId}) =>
            completer.future;

        final future = cubit.fetchShortageCandidates();

        // Invalidate preview (increments candidate generation ID)
        cubit.invalidatePreview();

        // Now complete the delayed candidate response
        completer.complete(
          ApiResult.success([
            const ShortageAllocationCandidate(
              id: '99',
              name: 'Late Candidate',
              type: 'cashier',
              role: 'كاشير',
            ),
          ]),
        );

        await future;

        // Stale candidates must NOT overwrite the invalidated cubit state
        expect(cubit.shortageCandidates, isEmpty);
        expect(cubit.state, isA<EndShiftPreviewInvalidated>());
      },
    );

    test('stale allocations are pruned when candidate list updates', () async {
      final initialCandidates = [
        const ShortageAllocationCandidate(
          id: '1',
          name: 'Ali',
          type: 'cashier',
          role: 'كاشير',
        ),
        const ShortageAllocationCandidate(
          id: '2',
          name: 'Omar',
          type: 'branch_manager',
          role: 'مدير فرع',
        ),
      ];

      repository.onCandidates = ({required String shiftId}) async =>
          ApiResult.success(initialCandidates);
      await cubit.fetchShortageCandidates();

      // Add allocations for candidate 1 and candidate 2
      cubit.updateShortageAllocations([
        const CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '1',
          amount: 10.0,
        ),
        const CashShortageAllocation(
          responsibleType: 'branch_manager',
          responsibleId: '2',
          amount: 10.0,
        ),
      ]);
      expect(cubit.shortageAllocations.length, 2);

      // Candidate list is re-fetched and candidate 2 is no longer in the branch
      repository.onCandidates = ({required String shiftId}) async =>
          ApiResult.success([
            const ShortageAllocationCandidate(
              id: '1',
              name: 'Ali',
              type: 'cashier',
              role: 'كاشير',
            ),
          ]);
      await cubit.fetchShortageCandidates();

      // Candidate 2's allocation must be pruned
      expect(cubit.shortageAllocations.length, 1);
      expect(cubit.shortageAllocations[0].responsibleId, '1');
    });

    test(
      'fetchCashReconciliationPreview triggers candidate fetch when allocation required',
      () async {
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
      },
    );

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

    testWidgets(
      'renders candidates dropdown populated with matching role in Arabic RTL',
      (tester) async {
        await tester.pumpWidget(
          buildTestableWidget(
            CashShortageAllocationWidget(
              shortageAmount: 20.0,
              candidates: sampleCandidates,
              onAllocationsChanged: (_) {},
            ),
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('توزيع العجز النقدي'), findsOneWidget);
        expect(find.text('إجمالي العجز'), findsOneWidget);
        expect(find.text('الموزّع'), findsOneWidget);
        expect(find.text('المتبقي'), findsOneWidget);
        expect(find.text('اختر المسؤول (الاسم ومعرف النظام)'), findsOneWidget);
        expect(find.text('أضف'), findsOneWidget);
      },
    );

    testWidgets(
      'supports English LTR layout properly with actual English strings',
      (tester) async {
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

        expect(find.text('Cash Shortage Allocation'), findsOneWidget);
        expect(find.text('Total Shortage'), findsOneWidget);
        expect(find.text('Allocated'), findsOneWidget);
        expect(find.text('Remaining'), findsOneWidget);
        expect(find.text('Select Responsible (Name & ID)'), findsOneWidget);
        expect(find.text('Responsible Type'), findsOneWidget);
        expect(find.text('Add'), findsOneWidget);
      },
    );

    testWidgets('shows loading state when isLoadingCandidates is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CashShortageAllocationWidget(
            shortageAmount: 20.0,
            isLoadingCandidates: true,
            onAllocationsChanged: (_) {},
          ),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      expect(find.text('جاري تحميل قائمة المسؤولين...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'shows error box and retry button when candidatesError is set',
      (tester) async {
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
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('فشل الاتصال بالشبكة'), findsOneWidget);
        expect(find.text('أعد المحاولة'), findsOneWidget);

        await tester.tap(find.text('أعد المحاولة'));
        await tester.pumpAndSettle();

        expect(retried, isTrue);
      },
    );

    testWidgets(
      'shows 403 forbidden error message and triggers retry on button tap',
      (tester) async {
        bool retried = false;
        await tester.pumpWidget(
          buildTestableWidget(
            CashShortageAllocationWidget(
              shortageAmount: 20.0,
              candidatesError: 'غير مصرح لك باستعراض مسؤولي الوردية (403)',
              onRetryCandidates: () {
                retried = true;
              },
              onAllocationsChanged: (_) {},
            ),
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('غير مصرح لك باستعراض مسؤولي الوردية (403)'), findsOneWidget);
        expect(find.text('أعد المحاولة'), findsOneWidget);

        await tester.tap(find.text('أعد المحاولة'));
        await tester.pumpAndSettle();

        expect(retried, isTrue);
      },
    );

    testWidgets(
      'shows clear empty helper message when candidates list is completely empty []',
      (tester) async {
        await tester.pumpWidget(
          buildTestableWidget(
            CashShortageAllocationWidget(
              shortageAmount: 20.0,
              candidates: const [],
              onAllocationsChanged: (_) {},
            ),
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('لا يوجد مسؤول متاح بهذا الدور في هذا الفرع.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows empty helper when no candidates of selected role exist',
      (tester) async {
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
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('لا يوجد مسؤول متاح بهذا الدور في هذا الفرع.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'adding allocation with valid candidate updates allocations list',
      (tester) async {
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
            locale: const Locale('ar'),
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

        // Tap 'أضف' (the localized add button)
        await tester.tap(find.text('أضف'));
        await tester.pumpAndSettle();

        expect(emittedAllocs.length, 1);
        expect(emittedAllocs[0].responsibleId, '10');
        expect(emittedAllocs[0].name, 'سالم الكاشير');
        expect(emittedAllocs[0].amount, 20.0);
        expect(emittedAllocs[0].responsibleType, 'cashier');

        // Allocation complete state badge in Arabic
        expect(find.text('مكتملة'), findsOneWidget);
      },
    );
  });
}
