import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/formatter/cashier_shift_time_formatter.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_cards/pending_cards/cashier_my_pending_shifts_default_card.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final width in const [320.0, 800.0]) {
      for (final time in const ['12:00', '12:00:00', 'N/A']) {
        testWidgets('pending shift renders $time in ${locale.languageCode} at ${width.toInt()}px',
            (tester) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          final shift = CashierShiftEntity(
            id: 'shift-1',
            date: DateTime(2026, 11, 2),
            status: MyShiftStatusType.pending,
            startTime: time,
            endTime: '23:59',
            openingBalance: 0,
          );
          await tester.pumpWidget(AppResponsiveBuilder(
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
              home: Scaffold(
                body: SingleChildScrollView(
                  child: CashierMyPendingShiftsDefaultCard(shift: shift),
                ),
              ),
            ),
          ));
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          final context = tester.element(find.byType(CashierMyPendingShiftsDefaultCard));
          final shown = time == 'N/A'
              ? S.of(context).invalidShiftTime
              : CashierShiftTimeFormatter.format(time);
          expect(find.text(shown), findsOneWidget);
        });
      }
    }
  }
}
