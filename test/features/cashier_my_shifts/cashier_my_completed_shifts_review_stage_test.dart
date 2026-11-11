import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/completed/cashier_completed_shifts_response_model.dart';
import 'package:assab/features/cashier_my_shifts/data/repository/cashier_my_shifts_repo.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_handover_status_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/cashier_my_shifts_handover_status.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart';
import 'package:assab/features/cashier_my_shifts/presentation/strategies/cashier_my_shifts_cards_strategy/cashier_shifts_status_strategies/cashier_my_completed_shifts_strategy.dart';
import 'package:assab/generated/l10n.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCashierMyShiftsRepo implements CashierMyShiftsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  Future<ApiResult<CashierCompletedShiftsResponseModel>> Function({int? page})?
      onGetCompletedShifts;

  @override
  Future<ApiResult<CashierCompletedShiftsResponseModel>> getCashierMyCompletedShifts({
    int? page,
  }) async {
    if (onGetCompletedShifts != null) {
      return onGetCompletedShifts!(page: page);
    }
    return ApiResult.success(
      CashierCompletedShiftsResponseModel(
        success: true,
        message: 'Success',
        data: [],
        meta: MetaModel(
          currentPage: 1,
          lastPage: 1,
          total: 0,
        ),
      ),
    );
  }
}

Widget buildTestWidget(Widget child, {Locale locale = const Locale('ar')}) {
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
  group('MT-25: Shift State Refresh & Review Stage Preservation', () {
    testWidgets(
      'shift with pending handover status renders review stage label ("قيد المراجعة") and not "مكتملة"',
      (tester) async {
        final reviewShift = CashierShiftEntity(
          id: 'shift_101',
          date: DateTime(2026, 11, 11),
          status: MyShiftStatusType.completed,
          startTime: '08:00',
          endTime: '16:00',
          handoverStatus: const CashierHandoverStatusEntity(
            status: CashierMyShiftsHandoverStatus.pending,
            reviewedBy: null,
          ),
        );

        final strategy = CashierMyCompletedShiftsStrategy();
        final card = strategy.buildCard(reviewShift);

        await tester.pumpWidget(buildTestWidget(card, locale: const Locale('ar')));
        await tester.pumpAndSettle();

        // Must display pending review label, NEVER "مكتملة"
        expect(find.text('قيد المراجعة'), findsOneWidget);
        expect(find.text('مكتملة'), findsNothing);
      },
    );

    testWidgets(
      'shift with accepted handover status renders "مكتملة"',
      (tester) async {
        final acceptedShift = CashierShiftEntity(
          id: 'shift_102',
          date: DateTime(2026, 11, 11),
          status: MyShiftStatusType.completed,
          startTime: '08:00',
          endTime: '16:00',
          handoverStatus: const CashierHandoverStatusEntity(
            status: CashierMyShiftsHandoverStatus.accepted,
            reviewedBy: 'Manager Ahmed',
          ),
        );

        final strategy = CashierMyCompletedShiftsStrategy();
        final card = strategy.buildCard(acceptedShift);

        await tester.pumpWidget(buildTestWidget(card, locale: const Locale('ar')));
        await tester.pumpAndSettle();

        expect(find.text('مكتملة'), findsOneWidget);
        expect(find.text('قيد المراجعة'), findsNothing);
      },
    );

    test('CashierMyShiftsCubit getCompletedShifts refreshes canonical shift IDs and distinct statuses from server', () async {
      final repo = MockCashierMyShiftsRepo();
      final cubit = CashierMyShiftsCubit(repo);

      repo.onGetCompletedShifts = ({int? page}) async {
        return ApiResult.success(
          CashierCompletedShiftsResponseModel.fromJson({
            'success': true,
            'message': 'Success',
            'data': [
              {
                'id': 'shift_101',
                'shift_date': '2026-11-11',
                'shift_name': 'Morning Shift',
                'start_time': '08:00',
                'end_time': '16:00',
                'status': 'completed',
                'closing_balance': 100,
                'total_sales': 500,
                'variance': 0,
                'variance_type': 'none',
                'handover_status': {
                  'status': 'pending',
                  'reviewed_by': null,
                },
                'branch_name': 'Branch 1',
                'branch_id': 'b_1',
              },
              {
                'id': 'shift_102',
                'shift_date': '2026-11-10',
                'shift_name': 'Evening Shift',
                'start_time': '16:00',
                'end_time': '00:00',
                'status': 'completed',
                'closing_balance': 200,
                'total_sales': 800,
                'variance': 0,
                'variance_type': 'none',
                'handover_status': {
                  'status': 'accepted',
                  'reviewed_by': 'Manager Ahmed',
                },
                'branch_name': 'Branch 1',
                'branch_id': 'b_1',
              },
            ],
            'meta': {
              'current_page': 1,
              'last_page': 1,
              'total': 2,
            },
          }),
        );
      };

      await cubit.getCompletedShifts();

      expect(cubit.state.completed.items.length, 2);
      final shift1 = cubit.state.completed.items.firstWhere((s) => s.id == 'shift_101');
      final shift2 = cubit.state.completed.items.firstWhere((s) => s.id == 'shift_102');

      expect(shift1.id, 'shift_101');
      expect(shift1.handoverStatus?.status, CashierMyShiftsHandoverStatus.pending);

      expect(shift2.id, 'shift_102');
      expect(shift2.handoverStatus?.status, CashierMyShiftsHandoverStatus.accepted);

      await cubit.close();
    });
  });
}
