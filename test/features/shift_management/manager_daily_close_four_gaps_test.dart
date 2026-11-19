import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/routing/app_router.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/shift_module_features/shift_management/data/daily_close_submission.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_handover.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/hand_over_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/handover_user_item.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/shift_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/timestamps_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/handover/handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_final_handover_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/arguments/shift_arguments.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/update_manager_final_daily_close_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_request_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/handover_widgets/handover_success_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/final_handover_widgets/final_handover_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/final_handover_widgets/pending_daily_closures_section_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestRemoteDataSource implements ShiftManagementRemoteDataSource {
  Map<String, dynamic>? nextEndWithHandoverResponse;
  Map<String, dynamic>? nextHandoverResponse;
  int approveCalls = 0;
  final List<int?> requestedHistoryPages = [];
  Future<dynamic> Function({int? perPage, int? page})? onGetWorkdayHistory;
  Future<dynamic> Function({String? managerWorkdayId, String? workday})?
      onGetDailyClose;

  @override
  Future<dynamic> endShiftWithHandOver({
    required String shiftId,
    required FormData data,
  }) async =>
      nextEndWithHandoverResponse;

  @override
  Future<dynamic> previewCashReconciliation({
    required String shiftId,
    required Map<String, dynamic> body,
  }) async => {
        'data': {
          'allocation_required': false,
          'shortage_to_allocate': 0,
          'cash_reconciliation': {'cash_variance_type': 'balanced'},
        },
      };

  @override
  Future<dynamic> handOver({
    required String shiftId,
    required HandOverRequest handOverRequest,
  }) async =>
      nextHandoverResponse;

  @override
  Future approveHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  }) async {
    approveCalls++;
  }

  @override
  Future<dynamic> getWorkdayHistory({
    String? date,
    String? dateFrom,
    String? dateTo,
    int? perPage,
    int? page,
  }) async {
    requestedHistoryPages.add(page);
    if (onGetWorkdayHistory != null) {
      return onGetWorkdayHistory!(perPage: perPage, page: page);
    }
    return {'data': [], 'meta': {'current_page': 1, 'last_page': 1}};
  }

  @override
  Future<FinalDailyCloseResponse> getDailyClose({
    String? managerWorkdayId,
    String? workday,
  }) async {
    if (onGetDailyClose != null) {
      final raw = await onGetDailyClose!(
        managerWorkdayId: managerWorkdayId,
        workday: workday,
      );
      return FinalDailyCloseResponse.fromJson(
        raw is Map<String, dynamic> ? raw : Map<String, dynamic>.from(raw as Map),
      );
    }
    throw UnimplementedError();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TrackingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  bool failNextPost = false;
  Map<String, dynamic>? nextPostBody;
  int? nextPostStatus;
  void Function(RequestOptions options)? onPost;

  List<RequestOptions> get submitPosts => requests
      .where((r) => r.uri.path.endsWith('/daily-close/submit'))
      .toList();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (failNextPost) {
      failNextPost = false;
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'network-timeout',
      );
    }
    onPost?.call(options);
    final status = nextPostStatus ?? 200;
    final resBody = nextPostBody ?? {'success': true, 'message': 'Submitted'};
    nextPostStatus = null;
    nextPostBody = null;
    return ResponseBody.fromString(
      jsonEncode(resBody),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Widget _wrapTestApp({
  Key? appKey,
  required Widget child,
  required Locale locale,
  Size size = const Size(430, 932),
  bool scrollable = true,
}) {
  return MaterialApp(
    key: appKey,
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(extensions: LightTheme.extension),
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Builder(
        builder: (context) {
          AppResponsive.init(
            context,
            designWidth: size.width,
            designHeight: size.height,
          );
          if (!scrollable) {
            return child;
          }
          return Scaffold(body: SingleChildScrollView(child: child));
        },
      ),
    ),
  );
}

Map<String, dynamic> _historyRow({
  required String id,
  required String date,
  required String managerId,
  required bool submitted,
  String branchId = 'branch-1',
  String status = 'completed',
  int revision = 1,
}) {
  return {
    'id': id,
    'shift_date': date,
    'status': status,
    'shift_details': {
      'manager_id': managerId,
      'manager_name': 'Demo Manager',
      'branch_id': branchId,
      'store_branch': 'Assab Main Branch',
    },
    'final_handover': {
      'status': submitted ? 'Completed' : 'Pending',
      'handover_amount': 300,
    },
    'daily_close': {
      'is_submitted': submitted,
      'report_revision': revision,
      'approved_at': null,
    },
    'financial_summary': {
      'total_sales': 1200,
      'cash_collected': 300,
    },
  };
}

Map<String, dynamic> _dailyClosePayload({
  required String workdayId,
  required String businessDate,
  required String managerId,
  required String branchId,
  required int revision,
  required bool submitted,
}) {
  return {
    'success': true,
    'message': 'OK',
    'data': {
      'manager_workday_id': workdayId,
      'business_date': businessDate,
      'server_time': '$businessDate 22:00:00',
      'timezone': 'Asia/Riyadh',
      'workday_dates': {'today': businessDate},
      'shift': {
        'status': 'completed',
        'shift_details': {
          'manager_id': managerId,
          'branch_id': branchId,
        },
        'daily_close': {
          'is_submitted': submitted,
          'report_revision': revision,
        },
      },
      'cashier_breakdown': [
        {
          'cashier_id': 'c-1',
          'cashier_shift_id': 'cs-1',
          'expected_revision': 1,
          'cashier_name': 'Cashier One',
          'cash_collected': 300.0,
          'card_payments': 900.0,
          'delivery_app_payments': 0.0,
          'variance': 0.0,
          'total_sales': 1200.0,
          'is_modified': false,
        },
      ],
      'totals': {
        'total_cash_collected': 300.0,
        'total_card_payments': 900.0,
        'total_delivery_apps': 0.0,
        'total_variance': 0.0,
        'total_sales': 1200.0,
      },
      'aggregators': [],
    },
  };
}

CurrentShiftEntity _makeTodayShift({
  String id = 'day-19',
  String date = '2026-11-19',
}) {
  return CurrentShiftEntity(
    shift: ManagerShiftEntity(
      id: id,
      shiftDate: date,
      status: ShiftStatusType.completed,
      canSubmitDailyReport: true,
      shiftDetails: ManagerShiftDetailsEntity(
        assignedTo: 'Me',
        assignedBy: 'Owner',
        storeBranch: 'Assab Main Branch',
        branchId: 'branch-1',
        startTime: '08:00',
        endTime: '23:00',
        finalApprovalBy: 'Accountant',
        managerName: 'Demo Manager',
      ),
      finalHandover: FinalHandoverEntity(
        handoverAmount: 300,
        status: FinalHandOverStatus.pending,
        handoverFrom: 'Demo Manager',
        handoverTo: 'Accountant',
        handoverDate: date,
        handoverTime: '23:00:00',
        currentTime: '$date 23:00:00',
        currentTimeSetting: HandoverTiming.today,
        handoverNotes: null,
        openingBalance: 0,
        closingBalance: 300,
        expectedBalance: 300,
        variance: 0,
        varianceType: 'Balanced',
        lastDeposit: 300,
        pettyCash: 300,
      ),
      timestamps: TimestampsEntity(actualStart: null, actualEnd: null),
    ),
    progress: ProgressEntity(
      title: 'Workday',
      description: 'Daily operations',
      status: 'Completed',
      startTime: '08:00',
      endTime: '23:00',
      progressPercentage: 100,
    ),
    handover: const [],
  );
}

ShiftEntity _cashierShiftEntity({required String cashierId}) {
  return ShiftEntity(
    id: 'shift-1',
    shiftDateFormatted: '19 Nov 2026',
    shiftDate: '2026-11-19',
    shiftTimeDetails: ShiftTimeDetailsEntity(
      startTime: '08:00:00',
      endTime: '16:00:00',
    ),
    openingBalance: 0,
    closingBalance: 0,
    vatAmount: 0,
    cashCollected: 100,
    handoverAmount: 100,
    status: ShiftStatusType.inProgress,
    cashier: ShiftCashierEntity(id: cashierId, name: 'Demo User'),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await getIt.reset();
  });

  group('Gap 1: Actual handover outcome on success screens (AR & EN)', () {
    for (final lang in ['en', 'ar']) {
      testWidgets(
        'EndShiftWithHandover ($lang): accepted vs pending vs unknown with 0 approve calls',
        (tester) async {
          final previousRole = UserTypeService.selectedUserType;
          UserTypeService.selectedUserType = UserType.branchManager;
          addTearDown(() => UserTypeService.selectedUserType = previousRole);

          for (final tc in [
            (
              payload: {
                'success': true,
                'data': {
                  'summary': {
                    'handover_details': {'status': 'accepted'},
                  },
                },
              },
              expectedText: lang == 'en'
                  ? 'Cash Custody Receipt Confirmed'
                  : 'تم تأكيد استلام العهدة',
            ),
            (
              payload: {
                'success': true,
                'data': {
                  'summary': {
                    'handover_details': {'status': 'pending'},
                  },
                },
              },
              expectedText: lang == 'en'
                  ? 'Your cash handover is now pending approval from Receiver. You’ll be notified once they confirm it.'
                  : 'تسليمك النقدي الآن في انتظار موافقة Receiver. سيتم إعلامك بمجرد تأكيد ذلك.',
            ),
            (
              payload: {'success': true, 'data': <String, dynamic>{}},
              expectedText: lang == 'en'
                  ? 'Handover status could not be confirmed from the server response. Check the details to verify.'
                  : 'تعذر تأكيد حالة استلام العهدة من استجابة الخادم. يرجى مراجعة التفاصيل للتحقق.',
            ),
          ]) {
            // Even when manager identity matches cashier, missing status must stay unknown.
            SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
            final remote = _TestRemoteDataSource()
              ..nextEndWithHandoverResponse = tc.payload;
            final repo = ShiftManagementRepositoryImp(remote);
            final cubit = EndShiftCubit(
              repo,
              'shift-1',
              _cashierShiftEntity(cashierId: 'mgr-1'),
            )
              ..setActorIdForTesting('mgr-1')
              ..setCountedCash(100);
            final previewOk = await cubit.fetchCashReconciliationPreview();
            expect(previewOk, isTrue);

            await cubit.endShitWithHandOver(
              EndShiftRequestWithHandOver(
                totalSales: 100,
                cashCollected: 100,
                cardPayments: 0,
                posReceipt: null,
                nextCashierId: 'mgr-1',
                handoverAmount: 100,
                handoverNotes: null,
                aggregators: const [],
                variance: Variance(
                  responsibilityType: 'none',
                  currentCashierAmount: 0,
                  reason: '',
                  otherCashiers: const [],
                ),
                isThereVariance: false,
                isManager: true,
              ),
            );

            final state = cubit.state as EndShiftSuccess;
            await cubit.close();

            await tester.pumpWidget(
              _wrapTestApp(
                locale: Locale(lang),
                scrollable: false,
                child: EndShiftRequestWidget(
                  withHandOver: true,
                  shiftId: 'shift-1',
                  handoverReceiverName: 'Receiver',
                  handoverOutcome: state.handoverOutcome,
                  isNavigatedFromCashier: false,
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.text(tc.expectedText), findsOneWidget);
            expect(remote.approveCalls, 0);
          }
        },
      );

      testWidgets(
        'StartHandover -> AppRouter -> HandoverSuccessWidget ($lang): accepted vs pending vs unknown with 0 approve calls',
        (tester) async {
          for (final tc in [
            (
              payload: {
                'success': true,
                'data': {
                  'handover_details': {'status': 'approved'},
                },
              },
              expectedText: lang == 'en'
                  ? 'Cash Custody Receipt Confirmed'
                  : 'تم تأكيد استلام العهدة',
            ),
            (
              payload: {
                'success': true,
                'data': {
                  'handover_details': {'status': 'pending'},
                },
              },
              expectedText: lang == 'en'
                  ? 'Pending Recipient Approval'
                  : 'في انتظار موافقة المستلم',
            ),
            (
              payload: {'success': true, 'data': <String, dynamic>{}},
              expectedText: lang == 'en'
                  ? 'Handover Submitted'
                  : 'تم إرسال التسليم',
            ),
          ]) {
            final remote = _TestRemoteDataSource()
              ..nextHandoverResponse = tc.payload;
            final repo = ShiftManagementRepositoryImp(remote);
            final cubit = HandoverCubit(repo, 'shift-1')
              ..selectedCashier = HandoverUserItem(
                id: 'mgr-1',
                name: 'Receiver',
                image: '',
                status: CashierStatus.active,
                branchName: 'Main',
                isManager: true,
              );

            await cubit.handOver(handOverAmount: 100, note: 'Self close');
            final state = cubit.state as RecordingHandoverSuccess;
            await cubit.close();

            const shiftArgs = ShiftArguments(
              shiftId: 'shift-1',
              nextCashier: 'Receiver',
              totalSales: 100,
              cashCollected: 100,
              cardPayment: 0,
              deliveryApps: 0,
            );
            final route =
                AppRouter.generateRoute(
                      RouteSettings(
                        name: AppRouteName.handoverSuccessScreen,
                        arguments: {
                          'shiftArguments': shiftArgs,
                          'isOpenedFromShiftDetailsScreen': false,
                          'handoverOutcome': state.handoverOutcome,
                        },
                      ),
                    )
                    as MaterialPageRoute;

            await tester.pumpWidget(
              _wrapTestApp(
                locale: Locale(lang),
                scrollable: false,
                child: Builder(builder: route.builder),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.byType(HandoverSuccessWidget), findsOneWidget);
            expect(find.text(tc.expectedText), findsOneWidget);
            expect(remote.approveCalls, 0);
          }
        },
      );
    }
  });

  group('Gap 2: Full workday/history pagination across >50 records', () {
    testWidgets(
      'finds Nov 16 on page 2 ahead of Nov 18 on page 1, excludes other manager, fails closed on page 2 error, and unlocks Nov 18 once Nov 16 closes',
      (tester) async {
        SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
        var nov16Submitted = false;
        var failPage2 = false;
        final remote = _TestRemoteDataSource();
        remote.onGetWorkdayHistory = ({int? perPage, int? page}) async {
          if (page == 1) {
            final rows = <Map<String, dynamic>>[
              _historyRow(
                id: 'day-18',
                date: '2026-11-18',
                managerId: 'mgr-1',
                submitted: false,
              ),
              _historyRow(
                id: 'day-14-other-mgr',
                date: '2026-11-14',
                managerId: 'mgr-2',
                submitted: false,
              ),
              for (var i = 0; i < 48; i++)
                _historyRow(
                  id: 'closed-p1-$i',
                  date: '2026-10-${(30 - (i % 25)).toString().padLeft(2, '0')}',
                  managerId: 'mgr-1',
                  submitted: true,
                ),
            ];
            return {
              'data': rows,
              'meta': {'current_page': 1, 'last_page': 2},
            };
          }
          if (failPage2) {
            throw DioException.connectionError(
              requestOptions: RequestOptions(path: 'branch-manager/workday/history'),
              reason: 'page-2-down',
            );
          }
          return {
            'data': [
              _historyRow(
                id: 'day-16',
                date: '2026-11-16',
                managerId: 'mgr-1',
                submitted: nov16Submitted,
              ),
              _historyRow(
                id: 'closed-p2-1',
                date: '2026-09-01',
                managerId: 'mgr-1',
                submitted: true,
              ),
            ],
            'meta': {'current_page': 2, 'last_page': 2},
          };
        };

        final repo = ShiftManagementRepositoryImp(remote);

        // 1) Page 2 error must fail closed rather than exposing Nov 18.
        failPage2 = true;
        await tester.pumpWidget(
          _wrapTestApp(
            locale: const Locale('en'),
            child: PendingDailyClosuresSectionWidget(
              currentManagerShift: _makeTodayShift(),
              loadPending: () => repo.getPendingDailyClosures(
                actorId: 'mgr-1',
                branchId: 'branch-1',
                excludeWorkdayId: 'day-19',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('2026-11-18'), findsNothing);

        // 2) Recover Page 2 -> Nov 16 appears first & only Nov 16 is enabled.
        failPage2 = false;
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        expect(remote.requestedHistoryPages, containsAll([1, 2]));
        expect(find.text('day-14-other-mgr'), findsNothing);
        expect(find.text('2026-11-16'), findsOneWidget);
        expect(find.text('2026-11-18'), findsOneWidget);
        expect(find.textContaining('2026-11-16'), findsWidgets);

        final openedIds = <String>[];
        await tester.pumpWidget(
          _wrapTestApp(
            locale: const Locale('en'),
            child: PendingDailyClosuresSectionWidget(
              currentManagerShift: _makeTodayShift(),
              loadPending: () => repo.getPendingDailyClosures(
                actorId: 'mgr-1',
                branchId: 'branch-1',
                excludeWorkdayId: 'day-19',
              ),
              onOpenClosure: (item) async {
                openedIds.add(item.id);
                if (item.id == 'day-16') {
                  nov16Submitted = true;
                }
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tapping Nov 18's disabled button does nothing.
        await tester.tap(find.text('Final Daily Close Submission').at(1));
        await tester.pump();
        expect(openedIds, isEmpty);

        // Tapping Nov 16 opens day-16, closes it, and refreshes -> now Nov 18 is unlocked.
        await tester.tap(find.text('Final Daily Close Submission').at(0));
        await tester.pumpAndSettle();
        expect(openedIds, ['day-16']);

        expect(find.text('2026-11-16'), findsNothing);
        expect(find.text('2026-11-18'), findsOneWidget);
        await tester.tap(find.text('Final Daily Close Submission'));
        await tester.pumpAndSettle();
        expect(openedIds, ['day-16', 'day-18']);
      },
    );
  });

  group('Gap 3 & Gap 4: Unified oldest-first gating + fresh GET reconcile', () {
    for (final lang in ['en', 'ar']) {
      testWidgets(
        'Gap 3 ($lang): 3 pending days (16, 18, 19) block Today & direct route with 0 POSTs, unlock 16 -> 18 -> 19 sequentially',
        (tester) async {
          tester.view.physicalSize = const Size(430, 1400);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });
          SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
          final adapter = _TrackingAdapter();
          final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
            ..httpClientAdapter = adapter;

          var closed16 = false;
          var closed18 = false;
          var closed19 = false;

          final remote = _TestRemoteDataSource();
          remote.onGetWorkdayHistory = ({int? perPage, int? page}) async {
            return {
              'data': [
                _historyRow(
                  id: 'day-19',
                  date: '2026-11-19',
                  managerId: 'mgr-1',
                  submitted: closed19,
                ),
                _historyRow(
                  id: 'day-18',
                  date: '2026-11-18',
                  managerId: 'mgr-1',
                  submitted: closed18,
                ),
                _historyRow(
                  id: 'day-16',
                  date: '2026-11-16',
                  managerId: 'mgr-1',
                  submitted: closed16,
                ),
              ],
              'meta': {'current_page': 1, 'last_page': 1},
            };
          };
          remote.onGetDailyClose = ({String? managerWorkdayId, String? workday}) async {
            final id = managerWorkdayId ?? 'day-19';
            final date = id == 'day-16'
                ? '2026-11-16'
                : (id == 'day-18' ? '2026-11-18' : '2026-11-19');
            final submitted = id == 'day-16'
                ? closed16
                : (id == 'day-18' ? closed18 : closed19);
            return _dailyClosePayload(
              workdayId: id,
              businessDate: date,
              managerId: 'mgr-1',
              branchId: 'branch-1',
              revision: 1,
              submitted: submitted,
            );
          };

          final repo = ShiftManagementRepositoryImp(remote);
          getIt.registerSingleton<Dio>(dio);
          getIt.registerSingleton<ShiftManagementRepositoryImp>(repo);

          final managerCubit = ManagerShiftCubit(repo)
            ..managerShift = _makeTodayShift();
          addTearDown(managerCubit.close);

          String? lastOpenedId;
          await tester.pumpWidget(
            BlocProvider.value(
              value: managerCubit,
              child: _wrapTestApp(
                locale: Locale(lang),
                child: Builder(
                  builder: (ctx) => ManagerMainScreenFinalHandoverTabWidget(
                    shiftDate: '2026-11-19',
                    shiftStatus: ShiftStatusType.completed,
                    currentManagerShift: _makeTodayShift(),
                    onOpenDailyClose: (id, _) async {
                      lastOpenedId = id;
                    },
                  ).buildTabContent(ctx),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final submitLabel = lang == 'en'
              ? 'Final Daily Close Submission'
              : 'إرسال اليومية نهائياً';
          final seeDetailsLabel = lang == 'en' ? 'See Details' : 'عرض التفاصيل';

          // Today (day-19) AND day-18 both show Nov 16 blocking date.
          expect(find.textContaining('2026-11-16'), findsWidgets);
          expect(find.byType(FinalHandoverWidget), findsOneWidget);
          expect(find.byType(PendingDailyClosuresSectionWidget), findsOneWidget);

          // Tapping Today's disabled submit button or Nov 18's disabled button does nothing.
          final submitButtons = find.text(submitLabel);
          expect(submitButtons, findsNWidgets(3)); // Today + Nov 16 + Nov 18
          await tester.ensureVisible(submitButtons.at(0));
          await tester.tap(submitButtons.at(0)); // Today (day-19)
          await tester.ensureVisible(submitButtons.at(2));
          await tester.tap(submitButtons.at(2)); // Pending Nov 18
          await tester.pump();
          expect(lastOpenedId, isNull);
          expect(adapter.submitPosts, isEmpty);

          // Direct navigation to UpdateManagerFinalDailyCloseScreen for day-19:
          // details visible, submit blocked, 0 POSTs!
          final dailyCubit19 = FinalDailyCloseCubit(repo);
          final endManagerCubit = EndAndUpdateManagerShiftCubit(repo);
          addTearDown(dailyCubit19.close);
          addTearDown(endManagerCubit.close);
          await dailyCubit19.getDailyClose(managerWorkdayId: 'day-19');

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit19),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapTestApp(
                locale: Locale(lang),
                scrollable: false,
                child: const UpdateManagerFinalDailyCloseScreen(
                  key: ValueKey('direct-day-19'),
                  branchName: 'Assab Main Branch',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Cashier One'), findsOneWidget);
          expect(find.text('2026-11-19'), findsOneWidget);
          expect(find.textContaining('2026-11-16'), findsOneWidget);
          await tester.ensureVisible(find.text(submitLabel));
          await tester.tap(find.text(submitLabel));
          await tester.pump();
          expect(adapter.submitPosts, isEmpty);

          // Now close day-16 (submit POST #1 for day-16).
          final dailyCubit16 = FinalDailyCloseCubit(repo);
          addTearDown(dailyCubit16.close);
          await dailyCubit16.getDailyClose(managerWorkdayId: 'day-16');

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit16),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapTestApp(
                locale: Locale(lang),
                scrollable: false,
                child: const UpdateManagerFinalDailyCloseScreen(
                  key: ValueKey('submit-day-16'),
                  branchName: 'Assab Main Branch',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text(submitLabel));
          await tester.tap(find.text(submitLabel));
          await tester.pumpAndSettle();
          await tester.tap(find.text(lang == 'en' ? 'Send' : 'إرسال'));
          closed16 = true;
          await tester.pumpAndSettle();

          expect(adapter.submitPosts.length, 1);
          expect(
            adapter.submitPosts.single.data['branch_manager_shift_id'],
            'day-16',
          );

          // Re-open or refresh stale-open day-19 -> now blocked by Nov 18! Still 0 POSTs for 19!
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit19),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapTestApp(
                appKey: const ValueKey('app-reopen-day-19'),
                locale: Locale(lang),
                scrollable: false,
                child: const UpdateManagerFinalDailyCloseScreen(
                  key: ValueKey('reopen-day-19'),
                  branchName: 'Assab Main Branch',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.textContaining('2026-11-18'), findsOneWidget);
          await tester.ensureVisible(find.text(submitLabel));
          await tester.tap(find.text(submitLabel));
          await tester.pump();
          expect(adapter.submitPosts.length, 1);

          // Keep day-19 mounted while day-18 is closed elsewhere; refresh updates eligibility!
          closed18 = true;
          final refreshLabel = lang == 'en'
              ? 'Refresh Daily Close Status'
              : 'تحديث حالة اليومية';
          await tester.ensureVisible(find.text(refreshLabel));
          await tester.tap(find.text(refreshLabel));
          await tester.pumpAndSettle();
          expect(find.textContaining('2026-11-18'), findsNothing);

          // Simulate day-18 submitted before 19: verify sequential POST for 18, then 19.
          closed18 = false;
          final dailyCubit18 = FinalDailyCloseCubit(repo);
          addTearDown(dailyCubit18.close);
          await dailyCubit18.getDailyClose(managerWorkdayId: 'day-18');
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit18),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapTestApp(
                appKey: const ValueKey('app-submit-day-18'),
                locale: Locale(lang),
                scrollable: false,
                child: const UpdateManagerFinalDailyCloseScreen(
                  key: ValueKey('submit-day-18'),
                  branchName: 'Assab Main Branch',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text(submitLabel));
          await tester.tap(find.text(submitLabel));
          await tester.pumpAndSettle();
          await tester.tap(find.text(lang == 'en' ? 'Send' : 'إرسال'));
          closed18 = true;
          await tester.pumpAndSettle();

          expect(adapter.submitPosts.length, 2);
          expect(
            adapter.submitPosts[1].data['branch_manager_shift_id'],
            'day-18',
          );

          // Finally day-19 is eligible on tab and screen -> submit sends POST #3 with day-19.
          await dailyCubit19.getDailyClose(managerWorkdayId: 'day-19');
          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit19),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapTestApp(
                appKey: const ValueKey('app-submit-day-19'),
                locale: Locale(lang),
                scrollable: false,
                child: const UpdateManagerFinalDailyCloseScreen(
                  key: ValueKey('submit-day-19'),
                  branchName: 'Assab Main Branch',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text(seeDetailsLabel), findsNothing);
          await tester.ensureVisible(find.text(submitLabel));
          await tester.tap(find.text(submitLabel));
          await tester.pumpAndSettle();
          await tester.tap(find.text(lang == 'en' ? 'Send' : 'إرسال'));
          closed19 = true;
          await tester.pumpAndSettle();

          expect(adapter.submitPosts.length, 3);
          expect(
            adapter.submitPosts.map((r) => r.data['branch_manager_shift_id']).toList(),
            ['day-16', 'day-18', 'day-19'],
          );
        },
      );
    }

    testWidgets(
      'Gap 4 UI: Refresh uses fresh GET revision & distinguishes GET failure vs open-revision-mismatch (0 POSTs)',
      (tester) async {
        SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
        final adapter = _TrackingAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
          ..httpClientAdapter = adapter;

        var getRevision = 4;
        var failGet = false;

        final remote = _TestRemoteDataSource();
        remote.onGetWorkdayHistory = ({int? perPage, int? page}) async => {
              'data': [
                _historyRow(
                  id: 'day-19',
                  date: '2026-11-19',
                  managerId: 'mgr-1',
                  submitted: false,
                  revision: getRevision,
                ),
              ],
              'meta': {'current_page': 1, 'last_page': 1},
            };
        remote.onGetDailyClose = ({String? managerWorkdayId, String? workday}) async {
          if (failGet) {
            throw DioException.connectionError(
              requestOptions: RequestOptions(path: 'branch-manager/workday/daily-close'),
              reason: 'offline',
            );
          }
          return _dailyClosePayload(
            workdayId: 'day-19',
            businessDate: '2026-11-19',
            managerId: 'mgr-1',
            branchId: 'branch-1',
            revision: getRevision,
            submitted: false,
          );
        };

        final repo = ShiftManagementRepositoryImp(remote);
        getIt.registerSingleton<Dio>(dio);
        getIt.registerSingleton<ShiftManagementRepositoryImp>(repo);

        final prefs = await SharedPreferences.getInstance();
        final submission = DailyCloseSubmission(
          dio,
          prefs,
          actorId: 'mgr-1',
          branchId: 'branch-1',
        );
        // Simulate earlier timed-out POST with revision 4.
        await tester.runAsync(() async {
          adapter.failNextPost = true;
          await expectLater(
            submission.submit('day-19', 4),
            throwsA(isA<DioException>()),
          );
        });
        expect(adapter.submitPosts.length, 1);

        final managerCubit = ManagerShiftCubit(repo)
          ..managerShift = _makeTodayShift();
        final dailyCubit = FinalDailyCloseCubit(repo);
        final endManagerCubit = EndAndUpdateManagerShiftCubit(repo);
        addTearDown(managerCubit.close);
        addTearDown(dailyCubit.close);
        addTearDown(endManagerCubit.close);

        await dailyCubit.getDailyClose(managerWorkdayId: 'day-19');

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: managerCubit),
              BlocProvider.value(value: dailyCubit),
              BlocProvider.value(value: endManagerCubit),
            ],
            child: _wrapTestApp(
              locale: const Locale('en'),
              scrollable: false,
              child: const UpdateManagerFinalDailyCloseScreen(
                branchName: 'Assab Main Branch',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Case A: Fresh GET returns open with changed revision (4 -> 5) -> 0 extra POSTs.
        getRevision = 5;
        await tester.ensureVisible(find.text('Refresh Daily Close Status'));
        await tester.tap(find.text('Refresh Daily Close Status'));
        await tester.pumpAndSettle();

        expect(adapter.submitPosts.length, 1);
        expect(submission.hasUnresolved('day-19'), true);
        expect(
          find.text(
            'Result is unconfirmed. Contact the accountant or system administrator before taking any further action.',
          ),
          findsOneWidget,
        );

        ScaffoldMessenger.of(
          tester.element(find.text('Refresh Daily Close Status')),
        ).clearSnackBars();
        await tester.pumpAndSettle();

        // Case B: Fresh GET fails -> 0 extra POSTs, verification-failed message shown.
        failGet = true;
        await tester.ensureVisible(find.text('Refresh Daily Close Status'));
        await tester.tap(find.text('Refresh Daily Close Status'));
        await tester.pumpAndSettle();

        expect(adapter.submitPosts.length, 1);
        expect(submission.hasUnresolved('day-19'), true);
        expect(
          find.text('Could not verify the workday status from the server.'),
          findsWidgets,
        );
      },
    );

    for (final lang in ['en', 'ar']) {
      testWidgets(
        'Decisive Replay Order Guard ($lang): timed-out Nov 19 cannot replay on Refresh while Nov 16 is pending or history fails (0 extra POSTs), then replays once after Nov 16 closes',
        (tester) async {
          SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
          final adapter = _TrackingAdapter();
          final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
            ..httpClientAdapter = adapter;

          var closed16 = false;
          var failHistory = false;
          var day19Submitted = false;

          final remote = _TestRemoteDataSource();
          remote.onGetWorkdayHistory = ({int? perPage, int? page}) async {
            if (failHistory) {
              throw DioException.connectionError(
                requestOptions: RequestOptions(
                  path: 'branch-manager/workday/history',
                ),
                reason: 'history-down',
              );
            }
            return {
              'data': [
                _historyRow(
                  id: 'day-19',
                  date: '2026-11-19',
                  managerId: 'mgr-1',
                  submitted: day19Submitted,
                  revision: 4,
                ),
                _historyRow(
                  id: 'day-16',
                  date: '2026-11-16',
                  managerId: 'mgr-1',
                  submitted: closed16,
                  revision: 1,
                ),
              ],
              'meta': {'current_page': 1, 'last_page': 1},
            };
          };
          remote.onGetDailyClose = ({String? managerWorkdayId, String? workday}) async {
            return _dailyClosePayload(
              workdayId: 'day-19',
              businessDate: '2026-11-19',
              managerId: 'mgr-1',
              branchId: 'branch-1',
              revision: 4,
              submitted: day19Submitted,
            );
          };

          final repo = ShiftManagementRepositoryImp(remote);
          getIt.registerSingleton<Dio>(dio);
          getIt.registerSingleton<ShiftManagementRepositoryImp>(repo);

          final prefs = await SharedPreferences.getInstance();
          final submission = DailyCloseSubmission(
            dio,
            prefs,
            actorId: 'mgr-1',
            branchId: 'branch-1',
          );
          await tester.runAsync(() async {
            adapter.failNextPost = true;
            await expectLater(
              submission.submit('day-19', 4),
              throwsA(isA<DioException>()),
            );
          });
          expect(adapter.submitPosts.length, 1);
          final originalKey =
              adapter.submitPosts.single.headers['Idempotency-Key'];

          final managerCubit = ManagerShiftCubit(repo)
            ..managerShift = _makeTodayShift();
          final dailyCubit = FinalDailyCloseCubit(repo);
          final endManagerCubit = EndAndUpdateManagerShiftCubit(repo);
          addTearDown(managerCubit.close);
          addTearDown(dailyCubit.close);
          addTearDown(endManagerCubit.close);

          await dailyCubit.getDailyClose(managerWorkdayId: 'day-19');

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapTestApp(
                appKey: ValueKey('replay-order-$lang'),
                locale: Locale(lang),
                scrollable: false,
                child: const UpdateManagerFinalDailyCloseScreen(
                  key: ValueKey('replay-order-screen'),
                  branchName: 'Assab Main Branch',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final refreshLabel = lang == 'en'
              ? 'Refresh Daily Close Status'
              : 'تحديث حالة اليومية';

          // 1) Nov 16 is still open -> Refresh checks fresh GET + history, sends 0 extra POSTs!
          await tester.ensureVisible(find.text(refreshLabel));
          await tester.tap(find.text(refreshLabel));
          await tester.pumpAndSettle();

          expect(adapter.submitPosts.length, 1);
          expect(submission.hasUnresolved('day-19'), true);
          expect(find.textContaining('2026-11-16'), findsWidgets);

          ScaffoldMessenger.of(
            tester.element(find.text(refreshLabel)),
          ).clearSnackBars();
          await tester.pumpAndSettle();

          // 2) History fails -> Refresh refuses replay (0 extra POSTs) and keeps intent.
          failHistory = true;
          await tester.ensureVisible(find.text(refreshLabel));
          await tester.tap(find.text(refreshLabel));
          await tester.pumpAndSettle();

          expect(adapter.submitPosts.length, 1);
          expect(submission.hasUnresolved('day-19'), true);
          expect(
            find.textContaining(
              lang == 'en'
                  ? 'Could not verify pending daily closures.'
                  : 'تعذر التحقق من الإقفالات اليومية المعلقة.',
            ),
            findsWidgets,
          );

          ScaffoldMessenger.of(
            tester.element(find.text(refreshLabel)),
          ).clearSnackBars();
          await tester.pumpAndSettle();

          // 3) Once Nov 16 is closed and history recovers -> Refresh replays ONCE with exact original key!
          failHistory = false;
          closed16 = true;
          adapter.onPost = (_) {
            day19Submitted = true;
          };
          await tester.ensureVisible(find.text(refreshLabel));
          await tester.tap(find.text(refreshLabel));
          await tester.pumpAndSettle();

          expect(adapter.submitPosts.length, 2);
          expect(
            adapter.submitPosts.last.data['branch_manager_shift_id'],
            'day-19',
          );
          expect(adapter.submitPosts.last.data['expected_revision'], 4);
          expect(
            adapter.submitPosts.last.headers['Idempotency-Key'],
            originalKey,
          );
          expect(submission.hasUnresolved('day-19'), false);
        },
      );
    }
  });
}
