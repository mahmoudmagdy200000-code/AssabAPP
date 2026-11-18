import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_requests/data/models/handovers_response.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_handovers/get_handovers_cubit.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_handovers/get_handovers_state.dart';
import 'package:assab/features/branch_manager_requests/presentation/screens/branch_manager_request_handovers_view.dart';
import 'package:assab/features/cashier_my_shifts/data/mapper/shift_status_mappers/cashier_in_progress_shift_mapper.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/in_progress/cashier_in_progress_shift_model.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/pending/cashier_pending_shift_model.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/strategies/cashier_my_shifts_cards_strategy/cashier_shifts_status_strategies/cashier_my_pending_shifts_strategy.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_default_card.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_has_to_start_card.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_with_opening_balance_card.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/manager_shift/manager_shift_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/manager_shift_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_final_handover_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/cashier_shifts_status_impl.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/in_progress_shift_card_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/pending_shift_card_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_summary_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_with_handover_summary_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/final_handover_widgets/final_handover_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/tabs_widgets/sales_and_handover_tab_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockEndShiftRepo extends ShiftManagementRepositoryImp {
  _MockEndShiftRepo() : super(_FakeRemoteDataSource());

  EndShiftRequestWithHandOver? lastHandoverRequest;
  int handoverSubmitCount = 0;

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
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
          'expected_cash': 90.0,
          'counted_cash': countedCash,
          'cash_variance': countedCash - 90.0,
          'cash_variance_type': 'balanced',
        },
        'shortage_to_allocate': 0.0,
        'allocation_required': false,
      },
    });
  }

  @override
  Future endShiftWithHandOver(
    String id,
    EndShiftRequestWithHandOver endShiftRequestWithVariance,
  ) async {
    handoverSubmitCount++;
    lastHandoverRequest = endShiftRequestWithVariance;
    return ApiResult.success(true);
  }
}

class _FakeStartCashierShiftCubit extends Cubit<StartCashierShiftState>
    implements StartCashierShiftCubit {
  _FakeStartCashierShiftCubit() : super(StartCashierShiftInitial());

  int startShiftCalls = 0;

  @override
  Future<void> startShift({
    required String shiftId,
    UserType? actorRole,
  }) async {
    startShiftCalls++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeCashierShiftsManagementCubit
    extends Cubit<CashierShiftsManagementState>
    implements CashierShiftsManagementCubit {
  _FakeCashierShiftsManagementCubit()
      : super(CashierShiftsManagementState.initial());

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockGetHandoversCubit extends Cubit<GetHandoversState>
    implements GetHandoversCubit {
  _MockGetHandoversCubit(List<HandoversResponseItem> items)
      : paginator = Paginator<HandoversResponseItem, HandoversResponse>(
          fetchPage: (_) async => ApiResult.success(
            HandoversResponse(
              data: items,
              meta: MetaModel(currentPage: 1, lastPage: 1, total: items.length),
            ),
          ),
          extractData: (r) => r.data,
          extractMeta: (r) => MetaInfo(
            currentPage: r.meta.currentPage,
            lastPage: r.meta.lastPage,
            total: r.meta.total,
          ),
        ),
        super(GetHandoversSuccess(items));

  @override
  final Paginator<HandoversResponseItem, HandoversResponse> paginator;

  @override
  void getHandovers({bool loadMore = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Widget _wrapTestApp({
  required Widget child,
  Locale locale = const Locale('ar'),
  List<BlocProvider<dynamic>> providers = const [],
}) {
  Widget app = AppResponsiveBuilder(
    builder: (_) => MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  if (providers.isNotEmpty) {
    app = MultiBlocProvider(providers: providers, child: app);
  }
  return app;
}

ShiftEntity _makeShiftEntity({
  double? openingBalance,
  ShiftStatusType status = ShiftStatusType.pending,
}) {
  return ShiftEntity(
    id: 'shift-100',
    shiftDateFormatted: '2026-11-18',
    shiftDate: '2026-11-18',
    shiftTimeDetails: ShiftTimeDetailsEntity(
      startTime: '08:00',
      endTime: '16:00',
    ),
    openingBalance: openingBalance,
    closingBalance: 0.0,
    vatAmount: 0.0,
    cashCollected: 90.0,
    handoverAmount: 0.0,
    status: status,
    cashier: ShiftCashierEntity(id: 'c-1', name: 'Ahmed Cashier'),
  );
}

Map<String, dynamic> _shiftModelJson({dynamic openingBalance}) => {
      'id': '100',
      'shift_date': '2026-11-18',
      'status': 'not_started',
      'cashier': {'id': '1', 'name': 'Ahmed'},
      'shift': {'start_time': '08:00', 'end_time': '16:00'},
      'opening_balance': openingBalance,
      'closing_balance': 0,
      'expected_balance': 0,
      'total_sales': 0,
      'net_sales': 0,
      'vat_amount': 0,
      'cash_collected': 0,
      'card_payments': 0,
    };

void main() {
  group('APP-01: Opening balance display (0 -> 0.00, 10 -> 10.00, null -> unavailable)', () {
    test('Mappers preserve null instead of coercing openingBalance to 0', () {
      final shiftNull = ShiftModel.fromJson(_shiftModelJson(openingBalance: null)).toEntity();
      final shiftZero = ShiftModel.fromJson(_shiftModelJson(openingBalance: 0)).toEntity();
      final shiftTen = ShiftModel.fromJson(_shiftModelJson(openingBalance: 10)).toEntity();
      expect(shiftNull.openingBalance, isNull);
      expect(shiftZero.openingBalance, 0.0);
      expect(shiftTen.openingBalance, 10.0);

      final pendingNull = CashierPendingShiftModel.fromJson({
        'id': '1',
        'date': '2026-11-18',
        'status': 'not_started',
        'status_label': 'Pending',
        'start_time': '08:00',
        'end_time': '16:00',
        'opening_balance': null,
        'cash_given': 0,
        'variance': 0,
        'assigned_to': 'Cashier',
        'assigned_by': 'Manager',
        'assigned_by_user_type': 'branch_manager',
        'is_next_shift': true,
        'can_start': true,
      });
      final pendingZero = CashierPendingShiftModel.fromJson({
        'id': '2',
        'date': '2026-11-18',
        'status': 'not_started',
        'status_label': 'Pending',
        'start_time': '08:00',
        'end_time': '16:00',
        'opening_balance': '0.00',
        'cash_given': 0,
        'variance': 0,
        'assigned_to': 'Cashier',
        'assigned_by': 'Manager',
        'assigned_by_user_type': 'branch_manager',
        'is_next_shift': true,
        'can_start': true,
      });
      final inProgressNotRecorded = CashierInProgressShiftModel.fromJson({
        'id': '3',
        'date': '2026-11-18',
        'status': 'in_progress',
        'start_time': '08:00',
        'end_time': '16:00',
        'opening_balance': 'Not yet recorded',
        'closing_balance': 0,
        'assigned_to': 'Cashier',
        'assigned_by': 'Manager',
        'assigned_by_user_type': 'branch_manager',
      }).toEntity();
      final inProgressZero = CashierInProgressShiftModel.fromJson({
        'id': '4',
        'date': '2026-11-18',
        'status': 'in_progress',
        'start_time': '08:00',
        'end_time': '16:00',
        'opening_balance': 0,
        'closing_balance': 0,
        'assigned_to': 'Cashier',
        'assigned_by': 'Manager',
        'assigned_by_user_type': 'branch_manager',
      }).toEntity();

      expect(pendingNull.openingBalance, isNull);
      expect(pendingZero.openingBalance, 0.0);
      expect(inProgressNotRecorded.openingBalance, isNull);
      expect(inProgressZero.openingBalance, 0.0);
    });

    for (final locale in const [Locale('ar'), Locale('en')]) {
      final expectedUnavailable =
          locale.languageCode == 'ar' ? 'غير متاح' : 'Unavailable';

      testWidgets(
        'PendingShiftCardWidget & InProgressShiftCardWidget show 0.00 / 10.00 / $expectedUnavailable (${locale.languageCode})',
        (tester) async {
          for (final testCase in <({double? input, String expected})>[
            (input: 0.0, expected: '0.00'),
            (input: 10.0, expected: '10.00'),
            (input: null, expected: expectedUnavailable),
          ]) {
            await tester.pumpWidget(
              _wrapTestApp(
                locale: locale,
                providers: [
                  BlocProvider<StartCashierShiftCubit>(
                    create: (_) => _FakeStartCashierShiftCubit(),
                  ),
                  BlocProvider<CashierShiftsManagementCubit>(
                    create: (_) => _FakeCashierShiftsManagementCubit(),
                  ),
                ],
                child: Builder(
                  builder: (ctx) => Column(
                    children: [
                      PendingShiftCardWidget(
                        selectedShiftsStatus: CashierShiftsPendingStatus(),
                      ).buildCard(
                        ctx,
                        _makeShiftEntity(openingBalance: testCase.input),
                      ),
                      InProgressShiftCardWidget().buildCard(
                        ctx,
                        _makeShiftEntity(
                          openingBalance: testCase.input,
                          status: ShiftStatusType.inProgress,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            await tester.pump();
            expect(tester.takeException(), isNull);
            expect(find.text(testCase.expected), findsNWidgets(2));
          }
        },
      );

      testWidgets(
        'CashierMyPendingShifts cards show 0.00 / 10.00 / $expectedUnavailable (${locale.languageCode})',
        (tester) async {
          for (final testCase in <({double? input, String expected})>[
            (input: 0.0, expected: '0.00'),
            (input: 10.0, expected: '10.00'),
            (input: null, expected: expectedUnavailable),
          ]) {
            final shift = CashierShiftEntity(
              id: 'my-shift-1',
              date: DateTime(2026, 11, 18),
              status: MyShiftStatusType.pending,
              startTime: '08:00',
              endTime: '16:00',
              openingBalance: testCase.input,
            );

            await tester.pumpWidget(
              _wrapTestApp(
                locale: locale,
                providers: [
                  BlocProvider<StartCashierShiftCubit>(
                    create: (_) => _FakeStartCashierShiftCubit(),
                  ),
                ],
                child: Column(
                  children: [
                    CashierMyPendingShiftsDefaultCard(shift: shift),
                    CashierMyPendingShiftsHasToStartCard(shift: shift),
                  ],
                ),
              ),
            );
            await tester.pump();
            expect(tester.takeException(), isNull);
            expect(find.text(testCase.expected), findsNWidgets(2));
          }
        },
      );

      testWidgets(
        'Shift close summary & details keep openingBalance consistent across 0, 10, null (${locale.languageCode})',
        (tester) async {
          final repo = _MockEndShiftRepo();
          for (final testCase in <({double? input, String expected})>[
            (input: 0.0, expected: '0.00'),
            (input: 10.0, expected: '10.00'),
            (input: null, expected: expectedUnavailable),
          ]) {
            final shift = _makeShiftEntity(
              openingBalance: testCase.input,
              status: ShiftStatusType.inProgress,
            );
            final cubit = EndShiftCubit(repo, shift.id, shift)
              ..endShiftTotalSalesValuesUpdated(
                totalSales: 200.0,
                cashCollected: 90.0,
                cardPayments: 110.0,
                aggregators: const [],
              );
            addTearDown(cubit.close);

            await tester.pumpWidget(
              _wrapTestApp(
                locale: locale,
                providers: [BlocProvider<EndShiftCubit>.value(value: cubit)],
                child: Builder(
                  builder: (ctx) => Column(
                    children: [
                      KeyedSubtree(
                        key: const ValueKey('sales_tab'),
                        child: SalesAndHandoverTabWidget(allowScroll: false)
                            .buildTabContent(ctx, shift: shift),
                      ),
                      const EndShiftSummaryWidget(),
                      const EndShiftWithHandoverSummaryWidget(),
                    ],
                  ),
                ),
              ),
            );
            await tester.pump();
            expect(tester.takeException(), isNull);
            final expectedMatcher = testCase.input == 0.0
                ? findsAtLeastNWidgets(1)
                : findsOneWidget;
            expect(
              find.descendant(
                of: find.byKey(const ValueKey('sales_tab')),
                matching: find.text(testCase.expected),
              ),
              expectedMatcher,
            );
            expect(
              find.descendant(
                of: find.byType(EndShiftSummaryWidget),
                matching: find.text(testCase.expected),
              ),
              expectedMatcher,
            );
            expect(
              find.descendant(
                of: find.byType(EndShiftWithHandoverSummaryWidget),
                matching: find.text(testCase.expected),
              ),
              expectedMatcher,
            );
          }
        },
      );
    }
  });

  group('APP-02: 200 sales / 110 card / 90 cash enters 90 custody with full & partial handover', () {
    test('Derives cash_collected = 90.00 (not 200.00) and supports both full (90) and partial (70) handover', () async {
      final repo = _MockEndShiftRepo();
      final cubit = EndShiftCubit(repo, 'shift-app02', _makeShiftEntity(openingBalance: 0.0, status: ShiftStatusType.inProgress));
      addTearDown(cubit.close);

      final previewOk = await cubit.previewFromSalesInputs(
        totalSales: '200',
        countedCash: '90',
        cardPayments: '110',
        aggregators: const [],
        isArabic: false,
      );

      expect(previewOk, isTrue);
      expect(cubit.totalSales, 200.0);
      expect(cubit.cardPayments, 110.0);
      expect(cubit.cashCollected, 90.0);

      // Full handover: 90.00 out of 90.00 cash custody
      await cubit.endShitWithHandOver(
        EndShiftRequestWithHandOver(
          totalSales: cubit.totalSales,
          cashCollected: cubit.cashCollected,
          cardPayments: cubit.cardPayments,
          posReceipt: null,
          nextCashierId: 'mgr-1',
          handoverAmount: 90.0,
          handoverNotes: 'Full handover',
          aggregators: const [],
          variance: Variance(
            responsibilityType: 'balanced',
            currentCashierAmount: 0,
            reason: '',
            otherCashiers: [],
          ),
          isThereVariance: false,
          isManager: true,
        ),
      );

      expect(cubit.state, isA<EndShiftSuccess>());
      expect(repo.lastHandoverRequest?.totalSales, 200.0);
      expect(repo.lastHandoverRequest?.cardPayments, 110.0);
      expect(repo.lastHandoverRequest?.cashCollected, 90.0);
      expect(repo.lastHandoverRequest?.handoverAmount, 90.0);

      // Partial handover: 70.00 out of 90.00 cash custody
      await cubit.endShitWithHandOver(
        EndShiftRequestWithHandOver(
          totalSales: cubit.totalSales,
          cashCollected: cubit.cashCollected,
          cardPayments: cubit.cardPayments,
          posReceipt: null,
          nextCashierId: 'mgr-1',
          handoverAmount: 70.0,
          handoverNotes: 'Partial handover keeping 20 float',
          aggregators: const [],
          variance: Variance(
            responsibilityType: 'balanced',
            currentCashierAmount: 0,
            reason: '',
            otherCashiers: [],
          ),
          isThereVariance: false,
          isManager: true,
        ),
      );

      expect(cubit.state, isA<EndShiftSuccess>());
      expect(repo.handoverSubmitCount, 2);
      expect(repo.lastHandoverRequest?.cashCollected, 90.0);
      expect(repo.lastHandoverRequest?.handoverAmount, 70.0);
    });
  });

  group('APP-03 (Read-only repros): Document current behavior without altering lifecycle rules', () {
    testWidgets('HN-01: Default pending shift card renders active Start Shift inside window with no-op onClick; opening-balance card disables Start Shift', (tester) async {
      final now = DateTime.now();
      final start = now.subtract(const Duration(minutes: 10));
      final end = now.add(const Duration(hours: 2));
      String hhmm(DateTime d) =>
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

      // Verify test shift window is indeed open right now.
      final windowStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: now,
        startTime: hhmm(start),
        endTime: hhmm(end),
        now: now,
      );
      if (windowStatus.canStart) {
        final defaultShift = CashierShiftEntity(
          id: 'non-next-1',
          date: DateTime(now.year, now.month, now.day),
          status: MyShiftStatusType.pending,
          startTime: hhmm(start),
          endTime: hhmm(end),
          openingBalance: 0,
          isNextShift: false,
        );
        final withBalanceShift = CashierShiftEntity(
          id: 'non-next-2',
          date: DateTime(now.year, now.month, now.day),
          status: MyShiftStatusType.pending,
          startTime: hhmm(start),
          endTime: hhmm(end),
          openingBalance: 50,
          isNextShift: false,
        );

        final fakeStartCubit = _FakeStartCashierShiftCubit();
        final strategy = CashierMyPendingShiftsStrategy();
        expect(strategy.buildCard(defaultShift), isA<CashierMyPendingShiftsDefaultCard>());
        expect(
          strategy.buildCard(withBalanceShift),
          isA<CashierMyPendingShiftsWithOpeningBalanceCard>(),
        );

        await tester.pumpWidget(
          _wrapTestApp(
            locale: const Locale('en'),
            providers: [BlocProvider<StartCashierShiftCubit>.value(value: fakeStartCubit)],
            child: Column(
              children: [
                CashierMyPendingShiftsDefaultCard(shift: defaultShift),
                CashierMyPendingShiftsWithOpeningBalanceCard(shift: withBalanceShift),
              ],
            ),
          ),
        );
        await tester.pump();

        final startButtons = tester.widgetList<AppButton>(
          find.byWidgetPredicate((w) => w is AppButton && w.text == 'Start Shift'),
        ).toList();
        expect(startButtons, hasLength(2));
        // Card 1: enabled == true yet onClick is empty () {}, never calls startShift
        expect(startButtons[0].enabled, isTrue);
        startButtons[0].onClick();
        expect(fakeStartCubit.startShiftCalls, 0);
        // Card 2 (openingBalance != 0 & isNextShift == false): hardcoded enabled: false
        expect(startButtons[1].enabled, isFalse);
      }
    });

    testWidgets('HN-04: BranchManagerRequestHandoversView hides Accept/Reject when backend HandoverSummaryResource returns can_be_accepted: false', (tester) async {
      final pendingHandoverFromBackend = HandoversResponseItem.fromJson({
        'id': 'handover-1',
        'shift_date': '2026-11-18',
        'shift_date_iso': '2026-11-18',
        'status': 'pending',
        'cash_given': 90,
        'variance': 'balanced',
        'variance_amount': 0,
        'cash_from': 'Ahmed Cashier',
        'acceptance_message': null,
        // HandoverSummaryResource.php:28-35 checks `$authUser instanceof Cashier`,
        // yielding false for BranchManager even when handed over to BranchManager.
        'is_incoming': false,
        'is_outgoing': false,
        'can_be_accepted': false,
      });

      final cubit = _MockGetHandoversCubit([pendingHandoverFromBackend]);
      final validationCubit = ValidationCubit(requiredFields: const {});
      addTearDown(cubit.close);
      addTearDown(validationCubit.close);

      await tester.pumpWidget(
        AppResponsiveBuilder(
          builder: (_) => MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('en'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: Scaffold(
              body: MultiBlocProvider(
                providers: [
                  BlocProvider<GetHandoversCubit>.value(value: cubit),
                  BlocProvider<ValidationCubit>.value(value: validationCubit),
                ],
                child: const BranchManagerRequestHandoversView(
                  actorRole: UserType.branchManager,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Accept'), findsNothing);
      expect(find.text('Reject'), findsNothing);
      expect(find.text(S.current.waitingForYourApproval), findsOneWidget);
    });

    testWidgets('HN-05: ManagerMainScreenFinalHandoverTabWidget binds strictly to today currentManagerShift with no historical shift selector', (tester) async {
      final todayCompletedShift = ManagerShiftModel.fromJson({
        'id': 'mgr-today',
        'shift_date': '2026-11-18',
        'status': 'completed',
        'status_label': 'Completed',
        'shift_details': {
          'assigned_to': 'Manager',
          'assigned_by': 'Admin',
          'store_branch': 'Main Branch',
          'branch_id': 'b-1',
          'start_time': '08:00',
          'end_time': '22:00',
          'final_approval_by': 'Accountant',
          'manager_name': 'Manager',
          'manager_id': 'm-1',
        },
        'handoffs_summary': {
          'total_handovers': 1,
          'approved': 1,
          'pending': 0,
          'rejected': 0,
          'rejected_final': 0,
          'total_amount': 90,
          'total_variance': 0,
          'all_received': true,
        },
        'final_handover': {
          'handover_amount': 90,
          'status': 'pending',
          'handover_from': 'Manager',
          'handover_to': 'Accountant',
          'handover_date': '2026-11-18',
          'handover_time': '22:05:00',
          'current_time': '22:05:00',
          'current_time_setting': 'today',
          'variance_type': 'balanced',
        },
        'available_actions': {
          'can_start': false,
          'can_end': false,
          'can_submit_daily_report': false,
          'can_reopen': false,
          'can_approve_handovers': false,
          'can_reject_handovers': false,
        },
        'timestamps': <String, dynamic>{},
      }).toEntity();

      final currentShift = CurrentShiftEntity(
        shift: todayCompletedShift,
        progress: ProgressEntity(
          title: 'Completed',
          description: '',
          status: 'completed',
          startTime: null,
          endTime: null,
          progressPercentage: 100,
        ),
        handover: [],
      );

      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('en'),
          child: Builder(
            builder: (ctx) => ManagerMainScreenFinalHandoverTabWidget(
              shiftDate: '2026-11-18',
              shiftStatus: ShiftStatusType.completed,
              currentManagerShift: currentShift,
            ).buildTabContent(ctx),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FinalHandoverWidget), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsNothing);
    });
  });
}
