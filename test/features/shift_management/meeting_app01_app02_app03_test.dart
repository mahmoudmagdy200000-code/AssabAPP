import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_state.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/in_progress_cards/cashier_my_in_progress_shifts_default_card.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/historical_final_handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_name_and_branch_details.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/final_handover_widgets/historical_final_handover_sheet_widget.dart';
import 'package:assab/features/branch_manager_requests/data/models/handovers_response.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_handovers/get_handovers_cubit.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_handovers/get_handovers_state.dart';
import 'package:assab/features/branch_manager_requests/presentation/screens/branch_manager_request_handovers_view.dart';
import 'package:assab/features/cashier_my_shifts/data/mapper/shift_status_mappers/cashier_in_progress_shift_mapper.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/in_progress/cashier_in_progress_shift_model.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/pending/cashier_pending_shift_model.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
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
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_to_entity.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

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
  String? lastShiftId;

  @override
  Future<void> startShift({
    required String shiftId,
    UserType? actorRole,
  }) async {
    startShiftCalls++;
    lastShiftId = shiftId;
    emit(StartCashierShiftSuccess());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeCashierMyShiftsCubit extends Cubit<CashierMyShiftsState>
    implements CashierMyShiftsCubit {
  _FakeCashierMyShiftsCubit() : super(CashierMyShiftsState.initial());

  int pendingReloads = 0;
  int inProgressReloads = 0;

  @override
  Future<void> getPendingShifts({bool loadMore = false}) async {
    pendingReloads++;
  }

  @override
  Future<void> getInProgressShifts() async {
    inProgressReloads++;
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

  group('APP-03 Approved fixes (HN-01, HN-04, HN-05)', () {
    testWidgets('HN-01: Eligible next shift starts and switches to In Progress; outside-window & non-next shifts disable with AR/EN reasons', (tester) async {
      final now = DateTime.now();
      final startOpen = now.subtract(const Duration(minutes: 10));
      final endOpen = now.add(const Duration(hours: 2));
      String hhmm(DateTime d) =>
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

      final windowOpen = ShiftStartWindowHelper.evaluate(
        shiftDate: now,
        startTime: hhmm(startOpen),
        endTime: hhmm(endOpen),
        now: now,
      );

      // 1. Eligible shift inside window starts & switches tab to In Progress (step 1)
      if (windowOpen.canStart) {
        final eligible = CashierShiftEntity(
          id: 'eligible-1',
          date: DateTime(now.year, now.month, now.day),
          status: MyShiftStatusType.pending,
          startTime: hhmm(startOpen),
          endTime: hhmm(endOpen),
          openingBalance: 0,
          isNextShift: true,
          canStart: true,
        );
        final laterTurnDefault = CashierShiftEntity(
          id: 'later-turn-1',
          date: DateTime(now.year, now.month, now.day),
          status: MyShiftStatusType.pending,
          startTime: hhmm(startOpen),
          endTime: hhmm(endOpen),
          openingBalance: 0,
          isNextShift: false,
          canStart: false,
        );
        final laterTurnWithBal = CashierShiftEntity(
          id: 'later-turn-2',
          date: DateTime(now.year, now.month, now.day),
          status: MyShiftStatusType.pending,
          startTime: hhmm(startOpen),
          endTime: hhmm(endOpen),
          openingBalance: 50,
          isNextShift: false,
          canStart: false,
        );

        final fakeStartCubit = _FakeStartCashierShiftCubit();
        final fakeMyShiftsCubit = _FakeCashierMyShiftsCubit();
        final pagingCubit = PagingCubit(totalSteps: 4);
        addTearDown(pagingCubit.close);
        addTearDown(fakeMyShiftsCubit.close);

        await tester.pumpWidget(
          _wrapTestApp(
            locale: const Locale('en'),
            providers: [
              BlocProvider<StartCashierShiftCubit>.value(value: fakeStartCubit),
              BlocProvider<CashierMyShiftsCubit>.value(value: fakeMyShiftsCubit),
              BlocProvider<PagingCubit>.value(value: pagingCubit),
            ],
            child: Column(
              children: [
                CashierMyPendingShiftsHasToStartCard(shift: eligible),
                CashierMyPendingShiftsDefaultCard(shift: laterTurnDefault),
                CashierMyPendingShiftsWithOpeningBalanceCard(shift: laterTurnWithBal),
              ],
            ),
          ),
        );
        await tester.pump();

        final buttons = tester
            .widgetList<AppButton>(
              find.byWidgetPredicate((w) => w is AppButton && w.text == 'Start Shift'),
            )
            .toList();
        expect(buttons, hasLength(3));
        expect(buttons[0].enabled, isTrue);
        expect(buttons[1].enabled, isFalse);
        expect(buttons[2].enabled, isFalse);
        expect(
          find.text('An earlier active shift must be started first.'),
          findsNWidgets(2),
        );

        await tester.tap(find.byWidget(buttons[0]));
        await tester.pump();

        expect(fakeStartCubit.startShiftCalls, 1);
        expect(fakeStartCubit.lastShiftId, 'eligible-1');
        expect(fakeMyShiftsCubit.pendingReloads, 1);
        expect(fakeMyShiftsCubit.inProgressReloads, 1);
        expect(pagingCubit.state.currentIndex, 1);
      }

      // 2. Outside window (future date) shows localized AR and EN disabled reasons
      final futureDate = now.add(const Duration(days: 2));
      final outsideShift = CashierShiftEntity(
        id: 'outside-window-1',
        date: DateTime(futureDate.year, futureDate.month, futureDate.day),
        status: MyShiftStatusType.pending,
        startTime: '18:00',
        endTime: '23:00',
        openingBalance: 0,
        isNextShift: true,
        canStart: false,
        startDisabledReason: 'تفتح نافذة البدء الساعة 16:00',
      );
      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('ar'),
          providers: [
            BlocProvider<StartCashierShiftCubit>.value(
              value: _FakeStartCashierShiftCubit(),
            ),
          ],
          child: CashierMyPendingShiftsHasToStartCard(shift: outsideShift),
        ),
      );
      await tester.pump();
      expect(find.textContaining('تفتح نافذة البدء الساعة'), findsOneWidget);

      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('en'),
          providers: [
            BlocProvider<StartCashierShiftCubit>.value(
              value: _FakeStartCashierShiftCubit(),
            ),
          ],
          child: CashierMyPendingShiftsHasToStartCard(shift: outsideShift),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Start window opens at'), findsOneWidget);
    });

    testWidgets('HN-04: BranchManagerRequestHandoversView renders Accept/Reject when can_be_accepted is true, hides them when false, and shows Receipt ID', (tester) async {
      final pendingActionable = HandoversResponseItem.fromJson({
        'id': 'handover-actionable',
        'shift_date': '2026-11-18',
        'shift_date_iso': '2026-11-18',
        'status': 'pending',
        'cash_given': 90,
        'variance': 'balanced',
        'variance_amount': 0,
        'cash_from': 'Ahmed Cashier',
        'acceptance_message': null,
        'is_incoming': true,
        'is_outgoing': false,
        'can_be_accepted': true,
      });
      final approvedWithReceipt = HandoversResponseItem.fromJson({
        'id': 'handover-approved',
        'shift_date': '2026-11-18',
        'shift_date_iso': '2026-11-18',
        'status': 'approved',
        'cash_given': 90,
        'variance': 'balanced',
        'variance_amount': 0,
        'cash_from': 'Ahmed Cashier',
        'receipt_id': 'RCPT-90-XYZ',
        'responsibility_reviewed_at': '2026-11-18 12:00:00',
        'acceptance_message': null,
        'is_incoming': true,
        'is_outgoing': false,
        'can_be_accepted': false,
      });
      final otherRecipientPending = HandoversResponseItem.fromJson({
        'id': 'handover-other',
        'shift_date': '2026-11-18',
        'shift_date_iso': '2026-11-18',
        'status': 'pending',
        'cash_given': 70,
        'variance': 'balanced',
        'variance_amount': 0,
        'cash_from': 'Sara Cashier',
        'acceptance_message': null,
        'is_incoming': false,
        'is_outgoing': false,
        'can_be_accepted': false,
      });

      final cubit = _MockGetHandoversCubit([
        pendingActionable,
        approvedWithReceipt,
        otherRecipientPending,
      ]);
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

      expect(find.text(S.current.acceptHandover), findsOneWidget);
      expect(find.text(S.current.rejectHandover), findsOneWidget);
      expect(find.text('RCPT-90-XYZ'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(
        find.text('Awaiting confirmation from designated recipient'),
        findsOneWidget,
      );
    });

    testWidgets('HN-05: ManagerMainScreenFinalHandoverTabWidget adds Previous Final Handovers button and sheet handles data, empty state, and 403 error', (tester) async {
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
      expect(find.text('Previous Final Handovers'), findsOneWidget);

      // Case 1: Known date renders Read-Only historical record
      final sampleRecord = HistoricalFinalHandoverEntity(
        shiftId: 'hist-1',
        shiftDate: '2026-11-10',
        shiftStatus: 'completed',
        branchName: 'Al Olaya Branch',
        managerName: 'Manager A',
        handoverAmount: 200.0,
        handoverStatus: 'accepted',
        handoverFrom: 'Manager A',
        handoverTo: 'Accountant 1',
        handoverDate: '2026-11-10',
        handoverTime: '22:10:00',
        handoverNotes: 'Evening close ok',
        variance: 0.0,
        totalSales: 500.0,
        netSales: 434.78,
        vatAmount: 65.22,
        cashCollected: 200.0,
        cardPayments: 300.0,
        aggregatorPayments: 0.0,
        dailyCloseSubmitted: true,
        cashierBreakdown: const [],
      );

      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('en'),
          child: HistoricalFinalHandoverSheetWidget(
            key: const ValueKey('known'),
            initialDate: DateTime(2026, 11, 10),
            loader: (_) async => ApiResult.success(sampleRecord),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Read Only'), findsOneWidget);
      expect(find.text('Al Olaya Branch • 2026-11-10'), findsOneWidget);
      expect(find.text('200.00'), findsWidgets);
      expect(find.text('500.00'), findsOneWidget);

      // Case 2: Date with no handover renders empty state
      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('en'),
          child: HistoricalFinalHandoverSheetWidget(
            key: const ValueKey('empty'),
            initialDate: DateTime(2026, 11, 5),
            loader: (_) async => ApiResult.success(null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No final handover recorded for this date'), findsOneWidget);

      // Case 3: Cross-branch / unauthorized 403 renders failure cleanly
      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('en'),
          child: HistoricalFinalHandoverSheetWidget(
            key: const ValueKey('error'),
            initialDate: DateTime(2026, 11, 10),
            loader: (_) async => ApiResult.failure(
              ServerFailure(
                error: LocalErrorModel(message: 'Forbidden scope'),
                icon: Icons.error_outline,
                statusCode: 403,
                stackTrace: StackTrace.empty,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Forbidden scope'), findsOneWidget);
    });
  });

  group('Emulator-observed fixes (Items 2-5)', () {
    testWidgets('Item 2: CashierMyInProgressShiftsDefaultCard displays 0.00 / 10.00 / غير متاح', (tester) async {
      for (final (double? bal, String expectedText) in [
        (0.0, '0.00'),
        (10.0, '10.00'),
        (null, 'غير متاح'),
      ]) {
        final entity = CashierShiftEntity(
          id: 'in-prog-${bal ?? 'null'}',
          date: DateTime(2026, 11, 18),
          status: MyShiftStatusType.inProgress,
          startTime: '15:00',
          endTime: '23:59',
          openingBalance: bal,
          closingBalance: 0,
          nextCashier: 'Manager',
        );

        await tester.pumpWidget(
          _wrapTestApp(
            locale: const Locale('ar'),
            child: SingleChildScrollView(
              child: CashierMyInProgressShiftsDefaultCard(shift: entity),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('الرصيد الافتتاحي:'), findsOneWidget);
        expect(find.text(expectedText), findsOneWidget);
      }
    });

    test('Item 3: Repeated configureDependencies after getIt.reset does not throw duplicate AddItemCubit', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await getIt.reset(dispose: true);
      await configureDependencies();
      expect(getIt.isRegistered<AddItemCubit>(), isTrue);

      await getIt.reset(dispose: true);
      await configureDependencies();
      expect(getIt.isRegistered<AddItemCubit>(), isTrue);
      await getIt.reset(dispose: true);
    });

    testWidgets('Item 4: Long BranchManager recipient name wraps inside Expanded CashierNameAndBranch without overflow', (tester) async {
      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('ar'),
          child: const SizedBox(
            width: 300,
            child: Row(
              children: [
                SizedBox(width: 40, height: 35),
                SizedBox(width: 10),
                Expanded(
                  child: CashierNameAndBranch(
                    Name: 'مدير شاورما الأصيل — فرع الروضة (Branch Manager)',
                    BranchName: 'شاورما الأصيل — فرع الروضة الرئيسي الممتد',
                  ),
                ),
                SizedBox(width: 24, height: 24),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        find.text('مدير شاورما الأصيل — فرع الروضة (Branch Manager)'),
        findsOneWidget,
      );
    });

    testWidgets('Item 5: Arabic RTL summary shows متوازن (not balanced) + المتبقي 20.00 on partial handover only; SalesAndHandoverTab removes riyal icon from people & shows المتبقي', (tester) async {
      // Case A: Partial handover 70 out of 90 cashCollected -> shows المتبقي 20.00 and متوازن
      final repoPartial = _MockEndShiftRepo();
      final cubitPartial = EndShiftCubit(
        repoPartial,
        'shift-partial',
        _makeShiftEntity(openingBalance: 0.0, status: ShiftStatusType.inProgress),
      );
      addTearDown(cubitPartial.close);

      await cubitPartial.previewFromSalesInputs(
        totalSales: '200',
        countedCash: '90',
        cardPayments: '110',
        aggregators: const [],
        isArabic: true,
      );
      cubitPartial.handOverAmount = 70.0;

      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('ar'),
          providers: [BlocProvider<EndShiftCubit>.value(value: cubitPartial)],
          child: const EndShiftWithHandoverSummaryWidget(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('متوازن'), findsOneWidget);
      expect(find.text('balanced'), findsNothing);
      expect(find.text('المتبقي'), findsOneWidget);
      expect(find.text('20.00'), findsOneWidget);

      // Case B: Full handover 90 out of 90 -> hides المتبقي
      cubitPartial.handOverAmount = 90.0;
      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('ar'),
          providers: [BlocProvider<EndShiftCubit>.value(value: cubitPartial)],
          child: const EndShiftWithHandoverSummaryWidget(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المتبقي'), findsNothing);

      // Case C: SalesAndHandoverTabWidget shows المتبقي 20.00 and no Saudi Riyal SVG on handoverTo / next_cashier
      final shiftDetails = ShiftEntity(
        id: 'shift-details-2b',
        shiftDate: '2026-11-18',
        shiftDateFormatted: '18 Nov, 2026',
        status: ShiftStatusType.completed,
        totalSales: 200.0,
        cashCollected: 90.0,
        cardPayment: 110.0,
        deliveryApps: 0.0,
        vatAmount: 26.09,
        openingBalance: 0.0,
        closingBalance: 70.0,
        handoverAmount: 70.0,
        variance: 0.0,
        cashier: ShiftCashierEntity(id: 'c1', name: 'كاشير 1'),
        nextCashier: ShiftCashierEntity(
          id: 'm1',
          name: 'مدير شاورما الأصيل — فرع الروضة (Branch Manager)',
        ),
        handoverTo: const HandoverToEntity(
          id: 'm1',
          name: 'مدير شاورما الأصيل — فرع الروضة',
          type: 'branch_manager',
          email: 'bm@test.sa',
        ),
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '15:00',
          endTime: '23:59',
        ),
      );

      await tester.pumpWidget(
        _wrapTestApp(
          locale: const Locale('ar'),
          child: Builder(
            builder: (ctx) => SalesAndHandoverTabWidget(
              allowScroll: true,
            ).buildTabContent(ctx, shift: shiftDetails),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المتبقي'), findsOneWidget);
      expect(find.text('20.00'), findsOneWidget);

      final handoverToFinder = find.text('مدير شاورما الأصيل — فرع الروضة');
      expect(handoverToFinder, findsOneWidget);
      final handoverToRow = find.ancestor(
        of: handoverToFinder,
        matching: find.byType(Row),
      ).first;
      expect(
        find.descendant(
          of: handoverToRow,
          matching: find.byWidgetPredicate(
            (w) => w is AppSvg && w.assetName == AppAssets.saudiRiyal,
          ),
        ),
        findsNothing,
      );
    });
  });
}
