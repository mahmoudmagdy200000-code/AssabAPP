import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_default_card.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/cashier_shifts_status_impl.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/cashier_start_shift_button.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStartCashierShiftCubit extends Cubit<StartCashierShiftState>
    implements StartCashierShiftCubit {
  _FakeStartCashierShiftCubit() : super(StartCashierShiftInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Widget _buildTestWrapper({
  required Widget child,
  Locale locale = const Locale('ar', 'EG'),
  StartCashierShiftCubit? cubit,
}) {
  final widget = cubit != null
      ? BlocProvider<StartCashierShiftCubit>.value(
          value: cubit,
          child: child,
        )
      : child;

  return AppResponsiveBuilder(
    builder: (_) => MaterialApp(
      theme: ThemeData(
        extensions: LightTheme.extension,
        primaryColor: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('ar'),
        Locale('en'),
      ],
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}

void main() {
  group('ShiftStartWindowHelper Unit Tests', () {
    test('Standard shift (10:00 - 12:00) 2-hour window boundary tests', () {
      final shiftDate = DateTime(2026, 11, 12);

      // 1. Before window (07:59)
      final early = DateTime(2026, 11, 12, 7, 59);
      final earlyStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: early,
      );
      expect(earlyStatus.canStart, isFalse);
      expect(earlyStatus.disabledReason, contains('08:00'));

      // 2. Exactly at window open (08:00)
      final atOpen = DateTime(2026, 11, 12, 8, 0);
      final openStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: atOpen,
      );
      expect(openStatus.canStart, isTrue);
      expect(openStatus.disabledReason, isNull);

      // 3. During shift (11:00)
      final during = DateTime(2026, 11, 12, 11, 0);
      final duringStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: during,
      );
      expect(duringStatus.canStart, isTrue);

      // 4. Exactly at window close (14:00)
      final atClose = DateTime(2026, 11, 12, 14, 0);
      final closeStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: atClose,
      );
      expect(closeStatus.canStart, isTrue);

      // 5. After window closed (14:01)
      final after = DateTime(2026, 11, 12, 14, 1);
      final afterStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: after,
      );
      expect(afterStatus.canStart, isFalse);
      expect(afterStatus.disabledReason, contains('14:00'));
    });

    test('Midnight crossing shift (22:00 - 06:00) extends to following day correctly', () {
      final shiftDate = DateTime(2026, 11, 12);

      // 1. Before window on shift day (19:59 Nov 12)
      final early = DateTime(2026, 11, 12, 19, 59);
      final earlyStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        now: early,
      );
      expect(earlyStatus.canStart, isFalse);
      expect(earlyStatus.disabledReason, contains('20:00'));

      // 2. Window opens (20:00 Nov 12)
      final open = DateTime(2026, 11, 12, 20, 0);
      expect(ShiftStartWindowHelper.evaluate(shiftDate: shiftDate, startTime: '22:00', endTime: '06:00', now: open).canStart, isTrue);

      // 3. In the middle of night across midnight (03:00 Nov 13)
      final night = DateTime(2026, 11, 13, 3, 0);
      expect(ShiftStartWindowHelper.evaluate(shiftDate: shiftDate, startTime: '22:00', endTime: '06:00', now: night).canStart, isTrue);

      // 4. Near close next morning (07:59 Nov 13)
      final nearClose = DateTime(2026, 11, 13, 7, 59);
      expect(ShiftStartWindowHelper.evaluate(shiftDate: shiftDate, startTime: '22:00', endTime: '06:00', now: nearClose).canStart, isTrue);

      // 5. Window closed next morning (08:01 Nov 13)
      final closed = DateTime(2026, 11, 13, 8, 1);
      final closedStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        now: closed,
      );
      expect(closedStatus.canStart, isFalse);
      expect(closedStatus.disabledReason, contains('08:00'));
    });

    test('Past shift from Nov 10 evaluated on Nov 12 is strictly closed', () {
      final pastDate = DateTime(2026, 11, 10);
      final now = DateTime(2026, 11, 12, 10, 0);

      final status = ShiftStartWindowHelper.evaluate(
        shiftDate: pastDate,
        startTime: '10:00',
        endTime: '12:00',
        now: now,
      );
      expect(status.canStart, isFalse);
      expect(status.disabledReason, contains('انتهت نافذة بدء الوردية'));
    });
  });

  group('CashierStartShiftButton Widget Tests', () {
    testWidgets('Button is enabled and clickable when canStart is true', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));

      await tester.pumpWidget(
        _buildTestWrapper(
          cubit: _FakeStartCashierShiftCubit(),
          child: Row(
            children: [
              CashierStartShiftButton(
                shiftId: 'shift-1001',
                selectedShiftsStatus: CashierShiftsPendingStatus(),
                canStart: true,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);
      final appButton = tester.widget<AppButton>(buttonFinder);
      expect(appButton.enabled, isTrue);
      expect(appButton.isTransparent, isFalse);
    });

    testWidgets('Button is disabled with reason when canStart is false', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));

      const reason = 'تفتح نافذة البدء الساعة 08:00';
      await tester.pumpWidget(
        _buildTestWrapper(
          cubit: _FakeStartCashierShiftCubit(),
          child: Row(
            children: [
              CashierStartShiftButton(
                shiftId: 'shift-1002',
                selectedShiftsStatus: CashierShiftsPendingStatus(),
                canStart: false,
                disabledReason: reason,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);
      final appButton = tester.widget<AppButton>(buttonFinder);
      expect(appButton.enabled, isFalse);
      expect(appButton.isTransparent, isTrue);

      expect(find.text(reason), findsOneWidget);
    });
  });

  group('CashierMyPendingShiftsDefaultCard Start Window Tests', () {
    testWidgets('Card displays disabled reason for future shift outside window', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));

      // Tomorrow shift (outside start window today)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final shift = CashierShiftEntity(
        id: 'shift-csh-tomorrow',
        date: tomorrow,
        status: MyShiftStatusType.pending,
        startTime: '10:00:00',
        endTime: '18:00:00',
        openingBalance: 0,
        cashGiven: 0,
        variance: 0,
      );

      await tester.pumpWidget(
        _buildTestWrapper(
          child: CashierMyPendingShiftsDefaultCard(shift: shift),
        ),
      );
      await tester.pumpAndSettle();

      final startButtonFinder = find.widgetWithText(AppButton, 'بدء الوردية');
      expect(startButtonFinder, findsOneWidget);
      final appButton = tester.widget<AppButton>(startButtonFinder);
      expect(appButton.enabled, isFalse);
      expect(find.textContaining('تفتح نافذة البدء'), findsOneWidget);
    });
  });
}
