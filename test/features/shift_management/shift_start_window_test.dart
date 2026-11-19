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
  setUp(() {
    ShiftStartWindowHelper.resetSync();
  });

  tearDown(() {
    ShiftStartWindowHelper.resetSync();
  });

  group('ShiftStartWindowHelper Unit Tests', () {
    test('Standard shift (10:00 - 12:00) approved ±2h normal window [08:00, 12:00] and late/expired phases', () {
      final shiftDate = DateTime(2026, 11, 12);

      // 1. Before window (07:59:59)
      final early = DateTime(2026, 11, 12, 7, 59, 59);
      final earlyStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: early,
      );
      expect(earlyStatus.canStart, isFalse);
      expect(earlyStatus.windowPhase, ShiftWindowPhase.beforeOpen);
      expect(earlyStatus.disabledReason, contains('08:00'));

      // 2. Exactly at window open (08:00:00)
      final atOpen = DateTime(2026, 11, 12, 8, 0, 0);
      final openStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: atOpen,
      );
      expect(openStatus.canStart, isTrue);
      expect(openStatus.windowPhase, ShiftWindowPhase.normal);
      expect(openStatus.disabledReason, isNull);

      // 3. During normal window (11:00:00)
      final during = DateTime(2026, 11, 12, 11, 0, 0);
      final duringStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: during,
      );
      expect(duringStatus.canStart, isTrue);
      expect(duringStatus.windowPhase, ShiftWindowPhase.normal);

      // 4. Exactly at normal close boundary (12:00:00) -> inclusive on-time boundary
      final atNormalClose = DateTime(2026, 11, 12, 12, 0, 0);
      final atNormalCloseStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: atNormalClose,
      );
      expect(atNormalCloseStatus.canStart, isTrue);
      expect(atNormalCloseStatus.windowPhase, ShiftWindowPhase.normal);

      // 5. After normal close (12:00:01 & 12:01:00) -> late start recovery phase
      final afterNormalClose = DateTime(2026, 11, 12, 12, 0, 1);
      final lateStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: afterNormalClose,
      );
      expect(lateStatus.canStart, isFalse);
      expect(lateStatus.isLateStart, isTrue);
      expect(lateStatus.canLateStart, isTrue);
      expect(lateStatus.windowPhase, ShiftWindowPhase.late);
      expect(lateStatus.disabledReason, contains('12:00'));

      // 6. After business-day late cutoff (00:00 next day) -> expired
      final afterCutoff = DateTime(2026, 11, 13, 0, 0, 0);
      final expiredStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
        now: afterCutoff,
      );
      expect(expiredStatus.canStart, isFalse);
      expect(expiredStatus.canLateStart, isFalse);
      expect(expiredStatus.windowPhase, ShiftWindowPhase.expired);
    });

    test('Midnight crossing shift (22:00 - 06:00) normal [20:00, 00:00], late recovery until 08:00:00', () {
      final shiftDate = DateTime(2026, 11, 12);

      // 1. Before window on shift day (19:59:59 Nov 12)
      final early = DateTime(2026, 11, 12, 19, 59, 59);
      final earlyStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        now: early,
      );
      expect(earlyStatus.canStart, isFalse);
      expect(earlyStatus.disabledReason, contains('20:00'));

      // 2. Window opens (20:00:00 Nov 12)
      final open = DateTime(2026, 11, 12, 20, 0, 0);
      expect(ShiftStartWindowHelper.evaluate(shiftDate: shiftDate, startTime: '22:00', endTime: '06:00', now: open).canStart, isTrue);

      // 3. Exactly at +2h boundary across midnight (00:00:00 Nov 13) -> still normal
      final atMidnightBoundary = DateTime(2026, 11, 13, 0, 0, 0);
      expect(ShiftStartWindowHelper.evaluate(shiftDate: shiftDate, startTime: '22:00', endTime: '06:00', now: atMidnightBoundary).canStart, isTrue);

      // 4. Overnight late phase (03:00:00 Nov 13) -> late start recovery available
      final night = DateTime(2026, 11, 13, 3, 0, 0);
      final nightLate = ShiftStartWindowHelper.evaluate(shiftDate: shiftDate, startTime: '22:00', endTime: '06:00', now: night);
      expect(nightLate.canStart, isFalse);
      expect(nightLate.canLateStart, isTrue);

      // 5. Exactly at close next morning (08:00:00 Nov 13) -> strictly expired!
      final atClose = DateTime(2026, 11, 13, 8, 0, 0);
      final atCloseStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        now: atClose,
      );
      expect(atCloseStatus.canStart, isFalse);
      expect(atCloseStatus.canLateStart, isFalse);
      expect(atCloseStatus.windowPhase, ShiftWindowPhase.expired);
      expect(atCloseStatus.disabledReason, contains('08:00'));

      // 6. Window closed next morning (08:01:00 Nov 13)
      final closed = DateTime(2026, 11, 13, 8, 1, 0);
      final closedStatus = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        now: closed,
      );
      expect(closedStatus.canStart, isFalse);
      expect(closedStatus.canLateStart, isFalse);
    });

    test('Server time synchronization overrides local client clock skew', () {
      final shiftDate = DateTime(2026, 11, 12);

      // Server says it is 12:05 (past 10:00 + 2h normal close)
      final serverTime = DateTime.parse('2026-11-12T12:05:00+03:00');
      ShiftStartWindowHelper.syncServerTime(serverTime);

      expect(ShiftStartWindowHelper.isSyncedWithServer, isTrue);

      // Evaluate using default synchronized server time (now = null)
      final status = ShiftStartWindowHelper.evaluate(
        shiftDate: shiftDate,
        startTime: '10:00',
        endTime: '12:00',
      );

      // Because server time is past 12:00, normal start is disabled despite client clock!
      expect(status.canStart, isFalse);
      expect(status.windowPhase, ShiftWindowPhase.late);
      expect(status.disabledReason, contains('12:00'));
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

    test('7-day rolling window: strictly includes today through today+6 inclusive, excludes past and future', () {
      final now = DateTime(2026, 11, 12, 14, 30); // Thursday Nov 12, 2026

      // Past dates: Nov 10, Nov 11 -> must be FALSE
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-10', referenceNow: now), isFalse);
      expect(ShiftStartWindowHelper.isWithin7DayWindow(DateTime(2026, 11, 10), referenceNow: now), isFalse);
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-11', referenceNow: now), isFalse);
      expect(ShiftStartWindowHelper.isWithin7DayWindow(DateTime(2026, 11, 11), referenceNow: now), isFalse);

      // Current 7-day window (Nov 12 to Nov 18 inclusive) -> must be TRUE
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-12', referenceNow: now), isTrue); // Today (Day 0)
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-13', referenceNow: now), isTrue); // Day 1
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-14', referenceNow: now), isTrue); // Day 2
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-15', referenceNow: now), isTrue); // Day 3
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-16', referenceNow: now), isTrue); // Day 4
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-17', referenceNow: now), isTrue); // Day 5
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-18', referenceNow: now), isTrue); // Day 6 (end of window)

      // Distant future (> day 6): Nov 19 -> must be FALSE
      expect(ShiftStartWindowHelper.isWithin7DayWindow('2026-11-19', referenceNow: now), isFalse);
      expect(ShiftStartWindowHelper.isWithin7DayWindow(DateTime(2026, 11, 19), referenceNow: now), isFalse);
    });

    test('compareShiftsChronologically orders by date ASC then startTime ASC', () {
      // Different dates
      expect(
        ShiftStartWindowHelper.compareShiftsChronologically(
          dateA: '2026-11-12',
          startTimeA: '14:00',
          dateB: '2026-11-13',
          startTimeB: '10:00',
        ),
        lessThan(0),
      );

      // Same date, different times
      expect(
        ShiftStartWindowHelper.compareShiftsChronologically(
          dateA: '2026-11-12',
          startTimeA: '10:00',
          dateB: '2026-11-12',
          startTimeB: '14:00',
        ),
        lessThan(0),
      );
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

    testWidgets('Button auto-updates from enabled to disabled when clock passes 12:00:00 normal close', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));

      final shiftDate = DateTime(2026, 11, 12);
      // Sync server time to 11:59:58 (inside normal ±2h window for 10:00 start)
      ShiftStartWindowHelper.syncServerTime(DateTime.parse('2026-11-12T11:59:58+03:00'));

      await tester.pumpWidget(
        _buildTestWrapper(
          cubit: _FakeStartCashierShiftCubit(),
          child: Row(
            children: [
              CashierStartShiftButton(
                shiftId: 'shift-1003',
                selectedShiftsStatus: CashierShiftsPendingStatus(),
                shiftDate: shiftDate,
                startTime: '10:00',
                endTime: '12:00',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);
      expect(tester.widget<AppButton>(buttonFinder).enabled, isTrue);

      // Now clock ticks forward to 12:00:01 (after normal +2h window)
      ShiftStartWindowHelper.syncServerTime(DateTime.parse('2026-11-12T12:00:01+03:00'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(tester.widget<AppButton>(buttonFinder).enabled, isFalse);
      expect(find.textContaining('12:00'), findsOneWidget);
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
        isNextShift: true,
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
