import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/pending_start_button_section.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/cashier_shifts_status_impl.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/cashier_start_shift_button.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/pending_shift_card_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubStartCashierShiftCubit extends Cubit<StartCashierShiftState>
    implements StartCashierShiftCubit {
  _StubStartCashierShiftCubit() : super(StartCashierShiftInitial());

  @override
  Future<void> startShift({
    required String shiftId,
    UserType? actorRole,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Widget _wrap({
  required Widget child,
  Locale locale = const Locale('en'),
  StartCashierShiftCubit? cubit,
}) {
  final body = cubit == null
      ? child
      : BlocProvider<StartCashierShiftCubit>.value(
          value: cubit,
          child: child,
        );

  return MediaQuery(
    data: const MediaQueryData(size: Size(390, 844)),
    child: AppResponsiveBuilder(
      designWidth: 375,
      designHeight: 812,
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
        home: Scaffold(body: SingleChildScrollView(child: body)),
      ),
    ),
  );
}

void main() {
  setUp(() {
    ShiftStartWindowHelper.resetSync();
    UserTypeService.selectedUserType = UserType.cashier;
  });

  tearDown(() {
    ShiftStartWindowHelper.resetSync();
    UserTypeService.selectedUserType = null;
  });

  group('TEST 11 & 14: My Shifts list, Management card, and Shift Details consistency', () {
    testWidgets('Nov 19 scenario: SHIFT B is enabled across List, Management Card, and Details identically', (tester) async {
      // Server clock: Nov 19 2026 08:30 AM Riyadh
      ShiftStartWindowHelper.syncServerTime(DateTime.parse('2026-11-19T08:30:00+03:00'));

      final listShiftB = CashierShiftEntity(
        id: 'shift-b',
        date: DateTime(2026, 11, 19),
        status: MyShiftStatusType.pending,
        startTime: '08:00',
        endTime: '16:00',
        isNextShift: true,
        canStart: true,
        canStartNormal: true,
        isLateStart: false,
        windowPhase: 'normal',
      );

      final detailShiftB = ShiftEntity(
        id: 'shift-b',
        shiftDate: '2026-11-19',
        shiftDateFormatted: '19 Nov, 2026',
        shiftTimeDetails: ShiftTimeDetailsEntity(startTime: '08:00', endTime: '16:00'),
        openingBalance: 0,
        closingBalance: 0,
        vatAmount: 0,
        cashCollected: 0,
        handoverAmount: 0,
        status: ShiftStatusType.pending,
        cashier: ShiftCashierEntity(id: 'c1', name: 'Demo Cashier A 1119'),
        canStart: true,
        canStartNormal: true,
        isLateStart: false,
        isNextShift: true,
        windowPhase: 'normal',
      );

      final cubit = _StubStartCashierShiftCubit();

      await tester.pumpWidget(
        _wrap(
          cubit: cubit,
          child: Builder(
            builder: (context) => Column(
              children: [
                PendingStartButtonSection(
                  shift: listShiftB,
                  onStartPressed: () {},
                ),
                PendingShiftCardWidget(
                  selectedShiftsStatus: CashierShiftsPendingStatus(),
                ).buildCard(context, detailShiftB),
                detailShiftB.status.shiftDetailsAppButton(
                  context,
                  shiftId: detailShiftB.id,
                  shift: detailShiftB,
                  isCashier: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final startButtons = tester.widgetList<AppButton>(
        find.widgetWithText(AppButton, S.current.start_shift),
      );
      expect(startButtons, hasLength(3));
      expect(startButtons.map((b) => b.enabled), everyElement(isTrue));
    });

    testWidgets('SHIFT A (late phase) shows identical disabled state and manager-auth message across List, Card, and Details for cashier', (tester) async {
      ShiftStartWindowHelper.syncServerTime(DateTime.parse('2026-11-19T08:30:00+03:00'));

      final listShiftA = CashierShiftEntity(
        id: 'shift-a',
        date: DateTime(2026, 11, 19),
        status: MyShiftStatusType.pending,
        startTime: '00:00',
        endTime: '01:00',
        isNextShift: false,
        canStart: false,
        isLateStart: true,
        requiresManagerAuthorization: true,
        windowPhase: 'late',
        startDisabledCode: 'LATE_START_REQUIRES_MANAGER',
      );

      final detailShiftA = ShiftEntity(
        id: 'shift-a',
        shiftDate: '2026-11-19',
        shiftDateFormatted: '19 Nov, 2026',
        shiftTimeDetails: ShiftTimeDetailsEntity(startTime: '00:00', endTime: '01:00'),
        openingBalance: 0,
        closingBalance: 0,
        vatAmount: 0,
        cashCollected: 0,
        handoverAmount: 0,
        status: ShiftStatusType.pending,
        cashier: ShiftCashierEntity(id: 'c1', name: 'Demo Cashier A 1119'),
        canStart: false,
        isLateStart: true,
        requiresManagerAuthorization: true,
        isNextShift: false,
        windowPhase: 'late',
        startDisabledCode: 'LATE_START_REQUIRES_MANAGER',
      );

      final cubit = _StubStartCashierShiftCubit();

      await tester.pumpWidget(
        _wrap(
          cubit: cubit,
          child: Builder(
            builder: (context) => Column(
              children: [
                PendingStartButtonSection(
                  shift: listShiftA,
                  onStartPressed: () {},
                ),
                PendingShiftCardWidget(
                  selectedShiftsStatus: CashierShiftsPendingStatus(),
                ).buildCard(context, detailShiftA),
                detailShiftA.status.shiftDetailsAppButton(
                  context,
                  shiftId: detailShiftA.id,
                  shift: detailShiftA,
                  isCashier: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final startButtons = tester.widgetList<AppButton>(
        find.widgetWithText(AppButton, S.current.start_shift),
      );
      expect(startButtons, hasLength(3));
      expect(startButtons.map((b) => b.enabled), everyElement(isFalse));
      expect(
        find.text('Starting after the scheduled window. Manager authorization may be required.'),
        findsNWidgets(3),
      );
    });

    testWidgets('Branch Manager sees enabled Late Start action for shift in late recovery phase', (tester) async {
      UserTypeService.selectedUserType = UserType.branchManager;
      ShiftStartWindowHelper.syncServerTime(DateTime.parse('2026-11-19T13:30:00+03:00'));

      final cubit = _StubStartCashierShiftCubit();
      await tester.pumpWidget(
        _wrap(
          cubit: cubit,
          child: Row(
            children: [
              CashierStartShiftButton(
                shiftId: 'shift-late-mgr',
                selectedShiftsStatus: CashierShiftsPendingStatus(),
                actorRole: UserType.branchManager,
                canStart: true,
                serverCanStart: true,
                canStartLate: true,
                isLateStart: true,
                windowPhase: 'late',
                shiftDate: '2026-11-19',
                startTime: '10:00',
                endTime: '18:00',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final btn = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Late Start'));
      expect(btn.enabled, isTrue);
    });
  });
}
