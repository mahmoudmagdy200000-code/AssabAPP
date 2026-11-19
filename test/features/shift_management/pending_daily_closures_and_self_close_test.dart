import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_handover.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/shift_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/timestamps_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/pending_daily_closure_item.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/final_handover_widgets/pending_daily_closures_section_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubRepo extends ShiftManagementRepositoryImp {
  _StubRepo() : super(_FakeRemoteDataSource());
}

CurrentShiftEntity _makeCurrentShift() {
  return CurrentShiftEntity(
    shift: ManagerShiftEntity(
      id: 'workday-nov-19',
      shiftDate: '2026-11-19',
      status: ShiftStatusType.completed,
      canSubmitDailyReport: true,
      shiftDetails: ManagerShiftDetailsEntity(
        assignedTo: 'Me',
        assignedBy: 'Owner',
        storeBranch: 'Assab Demo Branch 1116',
        branchId: 'branch-1',
        startTime: '08:00',
        endTime: '23:00',
        finalApprovalBy: 'Accountant',
        managerName: 'Demo Manager',
      ),
      finalHandover: FinalHandoverEntity(
        handoverAmount: 360,
        status: FinalHandOverStatus.pending,
        handoverFrom: 'Demo Manager',
        handoverTo: 'Accountant',
        handoverDate: '2026-11-19',
        handoverTime: '23:00:00',
        currentTime: '2026-11-19 23:00:00',
        currentTimeSetting: HandoverTiming.today,
        handoverNotes: null,
        openingBalance: 0,
        closingBalance: 360,
        expectedBalance: 378,
        variance: 18,
        varianceType: 'Over',
        lastDeposit: 360,
        pettyCash: 360,
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

Widget _wrapWidget({
  required Widget child,
  required Size size,
  required Locale locale,
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
      child: Scaffold(
        body: Builder(
          builder: (context) {
            AppResponsive.init(
              context,
              designWidth: size.width,
              designHeight: size.height,
            );
            return SingleChildScrollView(child: child);
          },
        ),
      ),
    ),
  );
}

void main() {
  group('APP-DC02: PendingDailyClosureItem & PendingDailyClosuresSectionWidget', () {
    test('filters to completed, unsubmitted, non-final, actor-owned workdays ordered oldest first', () {
      final raw = [
        {
          'id': 'day-18',
          'shift_date': '2026-11-18',
          'status': 'completed',
          'shift_details': {'manager_id': 'mgr-1', 'branch_id': 'br-1', 'store_branch': 'Branch 1'},
          'final_handover': {'status': 'Pending', 'handover_amount': 200},
          'daily_close': {'is_submitted': false, 'report_revision': 1, 'approved_at': null},
          'financial_summary': {'total_sales': 500, 'cash_collected': 200},
        },
        {
          'id': 'day-16',
          'shift_date': '2026-11-16',
          'status': 'completed',
          'shift_details': {'manager_id': 'mgr-1', 'branch_id': 'br-1', 'store_branch': 'Branch 1'},
          'final_handover': {'status': 'Pending', 'handover_amount': 300},
          'daily_close': {'is_submitted': false, 'report_revision': 1, 'approved_at': null},
          'financial_summary': {'total_sales': 700, 'cash_collected': 300},
        },
        {
          'id': 'day-15-submitted',
          'shift_date': '2026-11-15',
          'status': 'completed',
          'shift_details': {'manager_id': 'mgr-1', 'branch_id': 'br-1', 'store_branch': 'Branch 1'},
          'final_handover': {'status': 'Completed', 'handover_amount': 100},
          'daily_close': {'is_submitted': true, 'report_revision': 1, 'approved_at': null},
          'financial_summary': {'total_sales': 100, 'cash_collected': 100},
        },
        {
          'id': 'day-17-other-mgr',
          'shift_date': '2026-11-17',
          'status': 'completed',
          'shift_details': {'manager_id': 'mgr-2', 'branch_id': 'br-1', 'store_branch': 'Branch 1'},
          'final_handover': {'status': 'Pending', 'handover_amount': 100},
          'daily_close': {'is_submitted': false, 'report_revision': 1, 'approved_at': null},
          'financial_summary': {'total_sales': 100, 'cash_collected': 100},
        },
        {
          'id': 'day-19-current',
          'shift_date': '2026-11-19',
          'status': 'completed',
          'shift_details': {'manager_id': 'mgr-1', 'branch_id': 'br-1', 'store_branch': 'Branch 1'},
          'final_handover': {'status': 'Pending', 'handover_amount': 360},
          'daily_close': {'is_submitted': false, 'report_revision': 1, 'approved_at': null},
          'financial_summary': {'total_sales': 1000, 'cash_collected': 378},
        },
      ];

      final parsed = raw.map(PendingDailyClosureItem.fromHistoryJson).toList();
      final pending = PendingDailyClosureItem.filterAndOrderPending(
        parsed,
        currentActorId: 'mgr-1',
        currentBranchId: 'br-1',
        excludeWorkdayId: 'day-19-current',
      );

      expect(pending.map((e) => e.id).toList(), ['day-16', 'day-18']);
    });

    for (final config in [
      (size: const Size(390, 844), locale: const Locale('en'), label: '390px EN LTR'),
      (size: const Size(820, 1180), locale: const Locale('ar'), label: '820px AR RTL'),
    ]) {
      testWidgets(
        'PendingDailyClosuresSectionWidget enables only oldest workday and passes exact ID (${config.label})',
        (tester) async {
          tester.view.physicalSize = Size(config.size.width * 2, config.size.height * 2);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          PendingDailyClosureItem? opened;
          final pendingItems = [
            const PendingDailyClosureItem(
              id: 'workday-nov-16',
              shiftDate: '2026-11-16',
              status: 'completed',
              managerId: 'mgr-1',
              managerName: 'Demo Manager',
              branchId: 'branch-1',
              branchName: 'Assab Demo Branch 1116',
              dailyReportSubmitted: false,
              isHeadFinalApproved: false,
              handoverStatus: 'Pending',
              handoverAmount: 250,
              totalSales: 600,
              cashCollected: 250,
              reportRevision: 1,
            ),
            const PendingDailyClosureItem(
              id: 'workday-nov-18',
              shiftDate: '2026-11-18',
              status: 'completed',
              managerId: 'mgr-1',
              managerName: 'Demo Manager',
              branchId: 'branch-1',
              branchName: 'Assab Demo Branch 1116',
              dailyReportSubmitted: false,
              isHeadFinalApproved: false,
              handoverStatus: 'Pending',
              handoverAmount: 300,
              totalSales: 800,
              cashCollected: 300,
              reportRevision: 1,
            ),
          ];

          await tester.pumpWidget(
            _wrapWidget(
              size: config.size,
              locale: config.locale,
              child: PendingDailyClosuresSectionWidget(
                currentManagerShift: _makeCurrentShift(),
                loadPending: () async => ApiResult.success(pendingItems),
                onOpenClosure: (item) async {
                  opened = item;
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('2026-11-16'), findsOneWidget);
          expect(find.text('2026-11-18'), findsOneWidget);

          final submitLabel = config.locale.languageCode == 'ar'
              ? 'إرسال اليومية نهائياً'
              : 'Final Daily Close Submission';
          final buttons = find.text(submitLabel);
          expect(buttons, findsNWidgets(2));

          // Tapping newer Nov 18 must do nothing (disabled until oldest Nov 16 is closed)
          await tester.tap(buttons.at(1));
          await tester.pump();
          expect(opened, isNull);

          // Tapping oldest Nov 16 opens exact workday-nov-16 ID
          await tester.tap(buttons.at(0));
          await tester.pump();
          expect(opened?.id, 'workday-nov-16');
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  group('APP-DC03: EndShiftCubit own-shift manager shortage reason', () {
    test('does not require manager shortage reason when manager closes own shift, but requires it for another cashier', () {
      final previousRole = UserTypeService.selectedUserType;
      UserTypeService.selectedUserType = UserType.branchManager;
      addTearDown(() => UserTypeService.selectedUserType = previousRole);

      final ownShift = ShiftEntity(
        id: 'shift-own',
        shiftDateFormatted: '19 Nov 2026',
        shiftDate: '2026-11-19',
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '08:00:00',
          endTime: '16:00:00',
        ),
        openingBalance: 0,
        closingBalance: 0,
        vatAmount: 0,
        cashCollected: 0,
        handoverAmount: 0,
        status: ShiftStatusType.inProgress,
        cashier: ShiftCashierEntity(id: 'mgr-1', name: 'Manager'),
      );
      final otherShift = ShiftEntity(
        id: 'shift-other',
        shiftDateFormatted: '19 Nov 2026',
        shiftDate: '2026-11-19',
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '08:00:00',
          endTime: '16:00:00',
        ),
        openingBalance: 0,
        closingBalance: 0,
        vatAmount: 0,
        cashCollected: 0,
        handoverAmount: 0,
        status: ShiftStatusType.inProgress,
        cashier: ShiftCashierEntity(id: 'cashier-2', name: 'Other Cashier'),
      );

      final cubitOwn = EndShiftCubit(_StubRepo(), 'shift-own', ownShift)
        ..setActorIdForTesting('mgr-1');
      expect(cubitOwn.isOwnManagerShift, true);
      expect(cubitOwn.requiresShortageAllocationReason, false);

      final cubitOther = EndShiftCubit(_StubRepo(), 'shift-other', otherShift)
        ..setActorIdForTesting('mgr-1');
      expect(cubitOther.isOwnManagerShift, false);
      expect(cubitOther.requiresShortageAllocationReason, true);
    });
  });
}
