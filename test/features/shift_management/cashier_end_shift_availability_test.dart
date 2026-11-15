import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/in_progress_cards/cashier_my_in_progress_shifts_default_card.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/handover_option/end_shift_option_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/end_shift_options_bottom_sheet.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  test('An overnight shift reaches its end on the next Riyadh date', () {
    final shiftDate = DateTime.utc(2026, 11, 14);
    expect(
      ShiftStartWindowHelper.hasReachedScheduledEnd(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        riyadhNow: DateTime.utc(2026, 11, 15, 5, 59, 59),
      ),
      isFalse,
    );
    expect(
      ShiftStartWindowHelper.hasReachedScheduledEnd(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: '06:00',
        riyadhNow: DateTime.utc(2026, 11, 15, 6),
      ),
      isTrue,
    );
    expect(
      ShiftStartWindowHelper.hasReachedScheduledEnd(
        shiftDate: shiftDate,
        startTime: '22:00',
        endTime: 'N/A',
        riyadhNow: DateTime.utc(2026, 11, 16),
      ),
      isFalse,
    );
  });

  testWidgets('My Shifts and Details enable End Shift together', (
    tester,
  ) async {
    const viewport = Size(390, 844);
    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    ShiftStartWindowHelper.syncServerTime(DateTime.utc(2026, 11, 14, 17, 29));
    addTearDown(ShiftStartWindowHelper.resetSync);
    getIt.registerFactory<EndShiftOptionCubit>(EndShiftOptionCubit.new);
    addTearDown(() => getIt.unregister<EndShiftOptionCubit>());

    const shiftId = 'shift-1';
    final listShift = CashierShiftEntity(
      id: shiftId,
      date: DateTime(2026, 11, 14),
      status: MyShiftStatusType.inProgress,
      startTime: '18:00',
      endTime: '20:30',
    );
    final detailShift = ShiftEntity(
      id: shiftId,
      shiftDate: '2026-11-14',
      shiftDateFormatted: '14 November',
      shiftTimeDetails: ShiftTimeDetailsEntity(
        startTime: '18:00',
        endTime: '20:30',
      ),
      openingBalance: 0,
      closingBalance: 0,
      vatAmount: 0,
      cashCollected: 0,
      handoverAmount: null,
      status: ShiftStatusType.inProgress,
      cashier: ShiftCashierEntity(id: 'cashier-1', name: 'Yousef'),
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: viewport),
        child: AppResponsiveBuilder(
          designWidth: 375,
          designHeight: 812,
          builder: (_) => MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: const [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
            home: Scaffold(
              body: ListView(
                children: [
                  CashierMyInProgressShiftsDefaultCard(shift: listShift),
                  Builder(
                    builder: (context) =>
                        detailShift.status.shiftDetailsAppButton(
                          context,
                          shiftId: shiftId,
                          shift: detailShift,
                          isCashier: true,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final endButtons = find.widgetWithText(ElevatedButton, S.current.end_shift);
    expect(endButtons, findsNWidgets(2));
    expect(
      tester.widgetList<ElevatedButton>(endButtons).map((b) => b.onPressed),
      everyElement(isNull),
    );

    ShiftStartWindowHelper.syncServerTime(
      DateTime.utc(2026, 11, 14, 17, 30, 1),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(
      tester.widgetList<ElevatedButton>(endButtons).map((b) => b.onPressed),
      everyElement(isNotNull),
    );

    await tester.tap(endButtons.first);
    await tester.pumpAndSettle();
    final sheet = find.byType(EndShiftOptionsBottomSheet);
    expect(sheet, findsOneWidget);
    final handoverOption = find.text(S.current.endShiftAndHandover);
    await tester.ensureVisible(handoverOption);
    await tester.tap(handoverOption);
    await tester.pump();
    final continueButton = find.descendant(
      of: sheet,
      matching: find.byType(ElevatedButton),
    );
    expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
