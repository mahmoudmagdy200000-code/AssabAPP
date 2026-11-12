import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/cashier_shifts_status_impl.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/cashier_shifts_app_bar.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/pending_shift_card_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

Widget _buildTestWrapper({
  required Widget child,
  Locale locale = const Locale('ar', 'EG'),
}) {
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
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Cashier Shifts & Pending Card Date Parsing Tests', () {
    test('isShiftTodayOrBefore parses YYYY-MM-DD cleanly in ar_EG and en without FormatException', () {
      final widget = PendingShiftCardWidget(selectedShiftsStatus: CashierShiftsPendingStatus());

      for (final testLocale in ['ar_EG', 'ar', 'en_US', 'en']) {
        Intl.defaultLocale = testLocale;

        // Specific reported failure case: 2026-11-10
        expect(() => widget.isShiftTodayOrBefore('2026-11-10'), returnsNormally);

        // Past date must return true
        final pastDate = DateTime.now().subtract(const Duration(days: 3));
        final pastDateStr =
            "${pastDate.year}-${pastDate.month.toString().padLeft(2, '0')}-${pastDate.day.toString().padLeft(2, '0')}";
        expect(widget.isShiftTodayOrBefore(pastDateStr), isTrue);

        // Future date must return false
        final futureDate = DateTime.now().add(const Duration(days: 3));
        final futureDateStr =
            "${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}";
        expect(widget.isShiftTodayOrBefore(futureDateStr), isFalse);

        // Invalid or empty dates must return false safely without throwing FormatException
        expect(widget.isShiftTodayOrBefore(''), isFalse);
        expect(widget.isShiftTodayOrBefore('invalid-date'), isFalse);
        expect(widget.isShiftTodayOrBefore('2026/11/10'), isFalse);
      }
    });

    testWidgets('PendingShiftCardWidget renders future shift card without crashing in ar_EG', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Intl.defaultLocale = 'ar_EG';
      final futureDate = DateTime.now().add(const Duration(days: 5));
      final futureDateStr =
          "${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}";

      final shift = ShiftEntity(
        id: 'shift-pending-1',
        shiftDate: futureDateStr,
        shiftDateFormatted: futureDateStr,
        shiftTimeDetails: ShiftTimeDetailsEntity(
          startTime: '08:00:00',
          endTime: '16:00:00',
        ),
        openingBalance: 0,
        closingBalance: 0,
        vatAmount: 0,
        cashCollected: 0,
        handoverAmount: 0,
        status: ShiftStatusType.pending,
        cashier: ShiftCashierEntity(id: 'c-1', name: 'يوسف الدوسري'),
      );

      final cardWidget = PendingShiftCardWidget(selectedShiftsStatus: CashierShiftsPendingStatus());

      await tester.pumpWidget(
        _buildTestWrapper(
          child: SingleChildScrollView(
            child: Builder(builder: (ctx) => cardWidget.buildCard(ctx, shift)),
          ),
          locale: const Locale('ar', 'EG'),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('يوسف الدوسري'), findsOneWidget);
    });

    testWidgets('PendingShiftCardWidget handles past shift 2026-11-10 cleanly in ar_EG and en without FormatException', (tester) async {
      for (final locale in ['ar_EG', 'en_US']) {
        Intl.defaultLocale = locale;

        final cardWidget = PendingShiftCardWidget(selectedShiftsStatus: CashierShiftsPendingStatus());

        // Verify isShiftTodayOrBefore on the exact reported date: 2026-11-10
        expect(cardWidget.isShiftTodayOrBefore('2026-11-10'), isTrue);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('CashierShiftsAppBar Responsive & Overflow Tests', () {
    const longCashierName = 'يوسف بن محمد الدوسري التميمي المنصوري';
    const longSubtitle = 'ورديات أمين الصندوق - فرع الملقا الرئيسي بالرياض';

    for (final viewport in [
      const Size(390, 844), // Mobile (iPhone 12 / common Android)
      const Size(820, 1180), // Tablet (iPad Air / Android Tablet)
    ]) {
      for (final locale in [
        const Locale('ar', 'EG'), // Arabic RTL
        const Locale('en', 'US'), // English LTR
      ]) {
        testWidgets(
            'CashierShiftsAppBar fits width ${viewport.width.toInt()}px in ${locale.languageCode} without horizontal overflow',
            (tester) async {
          tester.view.physicalSize = viewport;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            _buildTestWrapper(
              locale: locale,
              child: const Column(
                children: [
                  CashierShiftsAppBar(
                    title: longCashierName,
                    subTitle: longSubtitle,
                    showBackButton: true,
                    showInfoButton: true,
                  ),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Crucial: no exception thrown, zero horizontal overflow!
          expect(tester.takeException(), isNull);

          // Both Back button and Info button must remain present and accessible
          expect(find.byType(AppBackButton), findsOneWidget);
          expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

          // Title is displayed
          expect(find.text(longCashierName), findsOneWidget);
        });
      }
    }
  });
}
