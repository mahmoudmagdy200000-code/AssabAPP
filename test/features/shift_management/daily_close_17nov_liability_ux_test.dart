import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/daily_close_submission.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_handover.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/shift_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/timestamps_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/pending_daily_closure_item.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/update_manager_final_daily_close_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/final_handover_widgets/pending_daily_closures_section_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubRemote implements ShiftManagementRemoteDataSource {
  Future<dynamic> Function({int? perPage, int? page})? onHistory;
  Future<dynamic> Function({String? managerWorkdayId, String? workday})?
      onDailyClose;

  @override
  Future<dynamic> getWorkdayHistory({
    String? date,
    String? dateFrom,
    String? dateTo,
    int? perPage,
    int? page,
  }) async {
    if (onHistory != null) {
      return onHistory!(perPage: perPage, page: page);
    }
    return {'data': [], 'meta': {'current_page': 1, 'last_page': 1}};
  }

  @override
  Future<FinalDailyCloseResponse> getDailyClose({
    String? managerWorkdayId,
    String? workday,
  }) async {
    final raw = await onDailyClose!(
      managerWorkdayId: managerWorkdayId,
      workday: workday,
    );
    return FinalDailyCloseResponse.fromJson(
      raw is Map<String, dynamic> ? raw : Map<String, dynamic>.from(raw as Map),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubHttpAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  ResponseBody Function(RequestOptions options)? handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (handler != null) {
      return handler!(options);
    }
    return ResponseBody.fromString(
      jsonEncode({'success': true, 'message': 'OK'}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Widget _wrapScreen({
  required Widget child,
  required Locale locale,
  Size size = const Size(430, 932),
  bool wrapInScaffold = false,
}) {
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
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Builder(
        builder: (context) {
          AppResponsive.init(
            context,
            designWidth: size.width,
            designHeight: size.height,
          );
          if (wrapInScaffold) {
            return Scaffold(body: SingleChildScrollView(child: child));
          }
          return child;
        },
      ),
    ),
  );
}

Map<String, dynamic> _nov17DailyClosePayload({
  required bool submitted,
  required String liabilityStatus,
  int? liabilityVersion = 1,
  bool hasSelfShare = true,
}) {
  return {
    'success': true,
    'message': 'OK',
    'data': {
      'manager_workday_id': 'workday-nov-17',
      'business_date': '2026-11-17',
      'server_time': '2026-11-17 22:00:00',
      'timezone': 'Asia/Riyadh',
      'workday_dates': {'today': '2026-11-17'},
      'shift': {
        'id': 'workday-nov-17',
        'status': 'completed',
        'shift_details': {
          'manager_id': 'mgr-1',
          'branch_id': 'branch-1116',
          'store_branch': 'Assab Demo Branch 1116',
        },
        'daily_close': {
          'is_submitted': submitted,
          'report_revision': 1,
        },
      },
      'cashier_breakdown': [
        {
          'cashier_id': 'mgr-1',
          'cashier_shift_id': 'cs-nov-16',
          'expected_revision': 1,
          'cashier_name': 'Demo Manager',
          'cash_collected': 100.0,
          'card_payments': 100.0,
          'delivery_app_payments': 0.0,
          'variance': 0.0,
          'sales': 200.0,
          'liability_approval_status': 'not_required',
          'liability_allocation_version': null,
          'liability_has_manager_self_share': false,
        },
        {
          'cashier_id': 'mgr-1',
          'cashier_shift_id': 'cs-nov-17',
          'expected_revision': 1,
          'cashier_name': 'Demo Manager',
          'cash_collected': 95.0,
          'card_payments': 100.0,
          'delivery_app_payments': 5.0,
          'variance': -5.0,
          'sales': 200.0,
          'liability_approval_status': liabilityStatus,
          'liability_allocation_version': liabilityVersion,
          'liability_has_manager_self_share': hasSelfShare,
        },
      ],
      'totals': {
        'total_cash_collected': 195.0,
        'total_card_payments': 200.0,
        'total_delivery_apps': 5.0,
        'total_variance': -5.0,
        'total_sales': 400.0,
      },
      'aggregators': [],
    },
  };
}

CurrentShiftEntity _makeTodayEntity() {
  return CurrentShiftEntity(
    shift: ManagerShiftEntity(
      id: 'workday-nov-19',
      shiftDate: '2026-11-19',
      status: ShiftStatusType.inProgress,
      canSubmitDailyReport: false,
      shiftDetails: ManagerShiftDetailsEntity(
        assignedTo: 'Me',
        assignedBy: 'Owner',
        storeBranch: 'Assab Demo Branch 1116',
        branchId: 'branch-1116',
        startTime: '08:00',
        endTime: '23:00',
        finalApprovalBy: 'Accountant',
        managerName: 'Demo Manager',
      ),
      finalHandover: FinalHandoverEntity(
        handoverAmount: 0,
        status: FinalHandOverStatus.notSubmitted,
        handoverFrom: 'Demo Manager',
        handoverTo: 'Accountant',
        handoverDate: '2026-11-19',
        handoverTime: '23:00:00',
        currentTime: '2026-11-19 22:00:00',
        currentTimeSetting: HandoverTiming.today,
        handoverNotes: null,
        openingBalance: 0,
        closingBalance: 0,
        expectedBalance: 0,
        variance: 0,
        varianceType: 'None',
        lastDeposit: 0,
        pettyCash: 0,
      ),
      timestamps: TimestampsEntity(actualStart: null, actualEnd: null),
    ),
    progress: ProgressEntity(
      title: 'Workday',
      description: 'Daily operations',
      status: 'In Progress',
      startTime: '08:00',
      endTime: '23:00',
      progressPercentage: 50,
    ),
    handover: const [],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await getIt.reset();
    await UserTypeService.clearUserType();
  });

  group('F01-F04: 17 Nov Daily Close Liability UX & Canonical Totals', () {
    test('DailyCloseServerError prevents duplicate CODE (CODE) and maps LIABILITY_APPROVAL_REQUIRED', () {
      const err = DailyCloseServerError(
        statusCode: 409,
        code: 'LIABILITY_APPROVAL_REQUIRED',
        message: 'LIABILITY_APPROVAL_REQUIRED',
      );

      expect(err.isLiabilityApprovalRequired, isTrue);
      expect(
        err.formatted(fallback: 'Rejected'),
        'LIABILITY_APPROVAL_REQUIRED',
      );
      expect(
        err.localizedMessage(
          liabilityApprovalMessage:
              'Final daily close is blocked until the shift shortage responsibility is approved. Review the pending liability and try again.',
          fallback: 'Rejected',
        ),
        'Final daily close is blocked until the shift shortage responsibility is approved. Review the pending liability and try again.',
      );

      // Non-duplicate custom server message keeps standard formatting
      const other = DailyCloseServerError(
        statusCode: 409,
        code: 'STALE_REPORT_REVISION',
        message: 'Revision changed on server',
      );
      expect(other.isLiabilityApprovalRequired, isFalse);
      expect(
        other.formatted(fallback: 'Rejected'),
        'Revision changed on server (STALE_REPORT_REVISION)',
      );
    });

    for (final locale in [const Locale('en'), const Locale('ar')]) {
      testWidgets(
        'F01 + F02 (${locale.languageCode}): LIABILITY_APPROVAL_REQUIRED shows friendly localized inline alert without duplicate SnackBar, allows authorized manager approval, and succeeds on submit',
        (tester) async {
          SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
          UserTypeService.setUserType(
            strategy: BranchManagerUserStrategy(),
            userType: UserType.branchManager,
          );

          var liabilityApproved = false;
          var submitted = false;

          final adapter = _StubHttpAdapter();
          adapter.handler = (options) {
            if (options.uri.path.endsWith('/liability/approve')) {
              liabilityApproved = true;
              return ResponseBody.fromString(
                jsonEncode({
                  'success': true,
                  'data': {'manager_approval_status': 'approved'},
                }),
                200,
                headers: {
                  Headers.contentTypeHeader: [Headers.jsonContentType],
                },
              );
            }
            if (options.uri.path.endsWith('/daily-close/submit')) {
              if (!liabilityApproved) {
                return ResponseBody.fromString(
                  jsonEncode({
                    'success': false,
                    'code': 'LIABILITY_APPROVAL_REQUIRED',
                    'message': 'LIABILITY_APPROVAL_REQUIRED',
                  }),
                  409,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              submitted = true;
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'message': 'Submitted'}),
                200,
                headers: {
                  Headers.contentTypeHeader: [Headers.jsonContentType],
                },
              );
            }
            return ResponseBody.fromString(
              '{}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          };

          final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
            ..httpClientAdapter = adapter;

          final remote = _StubRemote();
          remote.onHistory = ({int? perPage, int? page}) async => {
                'data': [
                  {
                    'id': 'workday-nov-17',
                    'shift_date': '2026-11-17',
                    'status': 'completed',
                    'shift_details': {
                      'manager_id': 'mgr-1',
                      'manager_name': 'Demo Manager',
                      'branch_id': 'branch-1116',
                      'store_branch': 'Assab Demo Branch 1116',
                    },
                    'final_handover': {
                      'status': submitted ? 'Completed' : 'Not Submitted',
                      'handover_amount': 190,
                    },
                    'daily_close': {
                      'is_submitted': submitted,
                      'report_revision': 1,
                      'approved_at': null,
                    },
                    'financial_summary': {
                      'total_sales': 400.0,
                      'cash_collected': 195.0,
                    },
                  },
                ],
                'meta': {'current_page': 1, 'last_page': 1},
              };
          remote.onDailyClose = ({String? managerWorkdayId, String? workday}) async =>
              _nov17DailyClosePayload(
                submitted: submitted,
                liabilityStatus: liabilityApproved ? 'approved' : 'pending',
              );

          final repo = ShiftManagementRepositoryImp(remote);
          getIt.registerSingleton<Dio>(dio);
          getIt.registerSingleton<ShiftManagementRepositoryImp>(repo);

          final managerCubit = ManagerShiftCubit(repo)
            ..managerShift = _makeTodayEntity();
          final dailyCubit = FinalDailyCloseCubit(repo);
          final endManagerCubit = EndAndUpdateManagerShiftCubit(repo);
          addTearDown(managerCubit.close);
          addTearDown(dailyCubit.close);
          addTearDown(endManagerCubit.close);

          await dailyCubit.getDailyClose(managerWorkdayId: 'workday-nov-17');

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: managerCubit),
                BlocProvider.value(value: dailyCubit),
                BlocProvider.value(value: endManagerCubit),
              ],
              child: _wrapScreen(
                locale: locale,
                child: const UpdateManagerFinalDailyCloseScreen(
                  branchName: 'Assab Demo Branch 1116',
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final expectedMsg = locale.languageCode == 'en'
              ? 'Final daily close is blocked until the shift shortage responsibility is approved. Review the pending liability and try again.'
              : 'لا يمكن إرسال الإغلاق النهائي قبل اعتماد مسؤولية العجز. راجع توزيع العجز المعلّق واعتمده ثم أعد المحاولة.';
          final submitBtnLabel = locale.languageCode == 'en'
              ? 'Final Daily Close Submission'
              : 'إرسال اليومية نهائياً';
          final sendLabel = locale.languageCode == 'en' ? 'Send' : 'إرسال';
          final reviewBtnLabel = locale.languageCode == 'en'
              ? 'Review & Approve Pending Liability'
              : 'مراجعة واعتماد مسؤولية العجز';
          final approveLabel = locale.languageCode == 'en' ? 'Approve' : 'اعتماد';

          // F01: Trigger submit while liability is pending -> server returns 409 LIABILITY_APPROVAL_REQUIRED
          await tester.ensureVisible(find.text(submitBtnLabel));
          await tester.tap(find.text(submitBtnLabel));
          await tester.pumpAndSettle();
          await tester.tap(find.text(sendLabel));
          await tester.pumpAndSettle();

          // Exact friendly message shown ONCE inline; ZERO raw duplicate string; ZERO duplicate SnackBar!
          expect(find.text(expectedMsg), findsOneWidget);
          expect(find.textContaining('LIABILITY_APPROVAL_REQUIRED'), findsNothing);
          expect(find.byType(SnackBar), findsNothing);
          expect(submitted, isFalse);

          // Authorized manager sees explicit review/approval button (never auto-approved)
          expect(find.text(reviewBtnLabel), findsOneWidget);
          await tester.ensureVisible(find.text(reviewBtnLabel));
          await tester.tap(find.text(reviewBtnLabel));
          await tester.pumpAndSettle();

          // Confirmation dialog shown with self-share note before any POST
          expect(
            adapter.requests.where((r) => r.uri.path.endsWith('/liability/approve')),
            isEmpty,
          );
          await tester.tap(find.text(approveLabel));
          await tester.pumpAndSettle();

          // Existing S1-07/S1-10 endpoint called once with Idempotency-Key and explicit_self_share
          final approveReq = adapter.requests
              .where((r) => r.uri.path.endsWith('/liability/approve'))
              .single;
          expect(
            approveReq.uri.path,
            '/api/v1/branch-manager/shifts/cs-nov-17/liability/approve',
          );
          expect(approveReq.data, {
            'version': 1,
            'expected_revision': 1,
            'explicit_self_share': true,
          });
          expect(
            approveReq.headers['Idempotency-Key'],
            matches(RegExp(r'^[0-9a-f-]{36}$')),
          );

          // F02: After approval and refresh, submit daily close now succeeds cleanly!
          ScaffoldMessenger.of(
            tester.element(find.text(submitBtnLabel)),
          ).clearSnackBars();
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(submitBtnLabel));
          await tester.tap(find.text(submitBtnLabel));
          await tester.pumpAndSettle();
          await tester.tap(find.text(sendLabel));
          await tester.pumpAndSettle();

          expect(submitted, isTrue);
          expect(
            find.text(
              locale.languageCode == 'en'
                  ? 'Final daily close submitted for review'
                  : 'تم إرسال اليومية النهائية للمراجعة',
            ),
            findsOneWidget,
          );
        },
      );
    }

    testWidgets(
      'F03: Non-manager role never sees privileged liability approval action',
      (tester) async {
        SharedPreferences.setMockInitialValues({'u_id': 'mgr-1'});
        // Simulate a cashier (non-manager) session
        UserTypeService.setUserType(
          strategy: CashierUserStrategy(),
          userType: UserType.cashier,
        );

        final adapter = _StubHttpAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
          ..httpClientAdapter = adapter;
        final remote = _StubRemote();
        remote.onHistory = ({int? perPage, int? page}) async => {
              'data': [],
              'meta': {'current_page': 1, 'last_page': 1},
            };
        remote.onDailyClose = ({String? managerWorkdayId, String? workday}) async =>
            _nov17DailyClosePayload(
              submitted: false,
              liabilityStatus: 'pending',
            );

        final repo = ShiftManagementRepositoryImp(remote);
        getIt.registerSingleton<Dio>(dio);
        getIt.registerSingleton<ShiftManagementRepositoryImp>(repo);

        final managerCubit = ManagerShiftCubit(repo)
          ..managerShift = _makeTodayEntity();
        final dailyCubit = FinalDailyCloseCubit(repo);
        final endManagerCubit = EndAndUpdateManagerShiftCubit(repo);
        addTearDown(managerCubit.close);
        addTearDown(dailyCubit.close);
        addTearDown(endManagerCubit.close);

        await dailyCubit.getDailyClose(managerWorkdayId: 'workday-nov-17');

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: managerCubit),
              BlocProvider.value(value: dailyCubit),
              BlocProvider.value(value: endManagerCubit),
            ],
            child: _wrapScreen(
              locale: const Locale('en'),
              child: const UpdateManagerFinalDailyCloseScreen(
                branchName: 'Assab Demo Branch 1116',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Friendly human message is shown, but NO privileged approval button is rendered
        expect(
          find.text(
            'Final daily close is blocked until the shift shortage responsibility is approved. Review the pending liability and try again.',
          ),
          findsOneWidget,
        );
        expect(find.text('Review & Approve Pending Liability'), findsNothing);
        expect(
          adapter.requests.where((r) => r.uri.path.endsWith('/liability/approve')),
          isEmpty,
        );
      },
    );

    testWidgets(
      'F04: PendingDailyClosuresSectionWidget displays backend canonical 400.00/195.00 totals faithfully without synthetic summation in EN LTR and AR RTL',
      (tester) async {
        for (final locale in [const Locale('en'), const Locale('ar')]) {
          final item = PendingDailyClosureItem.fromHistoryJson({
            'id': 'workday-nov-17',
            'shift_date': '2026-11-17',
            'status': 'completed',
            'shift_details': {
              'manager_id': 'mgr-1',
              'manager_name': 'Demo Manager',
              'branch_id': 'branch-1116',
              'store_branch': 'Assab Demo Branch 1116',
            },
            'final_handover': {
              'status': 'Not Submitted',
              'handover_amount': 190.0,
            },
            'daily_close': {
              'is_submitted': false,
              'report_revision': 1,
              'approved_at': null,
            },
            'financial_summary': {
              'total_sales': 400.0,
              'cash_collected': 195.0,
            },
          });

          await tester.pumpWidget(
            _wrapScreen(
              locale: locale,
              wrapInScaffold: true,
              child: PendingDailyClosuresSectionWidget(
                currentManagerShift: _makeTodayEntity(),
                loadPending: () async => ApiResult.success([item]),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('2026-11-17'), findsOneWidget);
          expect(
            find.text(
              locale.languageCode == 'en'
                  ? 'Sales: 400.00 SAR'
                  : 'المبيعات: 400.00 ر.س',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              locale.languageCode == 'en'
                  ? 'Cash: 195.00 SAR'
                  : 'الكاش: 195.00 ر.س',
            ),
            findsOneWidget,
          );
        }
      },
    );
  });
}
