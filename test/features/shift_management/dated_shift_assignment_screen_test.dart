import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/dated_shift_assignment_screen.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: LightTheme.extension,
      primaryColor: const Color(0xFF1E88E5),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    ),
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Builder(
      builder: (context) {
        AppResponsive.init(context, designWidth: 390, designHeight: 844);
        return child;
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('P4a — DatedShiftAssignmentScreen Widget & Usability Tests', () {
    testWidgets('renders dated assignment screen with accountant policy and templates (390px mobile)',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildTestApp(
          const DatedShiftAssignmentScreen(
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify title and accountant governance banner
      expect(find.byKey(const Key('txt_screen_title')), findsOneWidget);
      expect(find.text('تعيين مؤرّخ'), findsOneWidget);
      expect(
        find.byKey(const Key('txt_accountant_governance_notice')),
        findsOneWidget,
      );
      expect(
        find.text('إعداد القوالب والمواعيد يظل ضمن صلاحيات المحاسب'),
        findsOneWidget,
      );

      // 2. Verify date range
      expect(find.byKey(const Key('txt_date_range')), findsOneWidget);
      expect(find.text('2026-11-15 — 2026-11-21'), findsOneWidget);

      // 3. Verify templates rendered with cashiers and hours
      expect(find.byKey(const Key('card_template_tpl-1')), findsOneWidget);
      expect(find.byKey(const Key('card_template_tpl-2')), findsOneWidget);
      expect(find.text('محمد أحمد السعيد'), findsOneWidget);
      expect(find.text('عبدالله إبراهيم محمود'), findsOneWidget);
      expect(find.text('08:00 - 16:00'), findsOneWidget);
      expect(find.text('16:00 - 00:00'), findsOneWidget);

      // 4. Verify no RenderFlex overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('executes atomic cashier swap between two templates successfully',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? swappedA;
      String? swappedB;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onSwapCompleted: (a, b) {
              swappedA = a;
              swappedB = b;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state:
      // tpl-1 -> محمد أحمد السعيد
      // tpl-2 -> عبدالله إبراهيم محمود
      expect(find.byKey(const Key('txt_cashier_name_tpl-1')), findsOneWidget);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'محمد أحمد السعيد',
      );
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      // Tap swap on template 1
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();

      expect(find.text('إلغاء'), findsOneWidget);

      // Scroll to ensure template 2 is in view
      await tester.scrollUntilVisible(
        find.byKey(const Key('btn_swap_tpl-2')),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('إتمام التبديل'), findsOneWidget);

      // Tap swap on template 2 to complete swap
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      // Drag back up to bring template 1 into view
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      // Drag down to bring template 2 into view
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'محمد أحمد السعيد',
      );

      expect(swappedA, 'tpl-1');
      expect(swappedB, 'tpl-2');
      expect(find.textContaining('تم تبديل الكاشيرين بنجاح'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('preserves protection when shift has financial evidence or is in progress',
        (tester) async {
      tester.view.physicalSize = const Size(360 * 2.0, 800 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      const protectedTemplates = [
        DatedTemplateSlot(
          templateId: 'tpl-protected-1',
          templateName: 'وردية الصباح المحمية',
          startTime: '08:00',
          endTime: '16:00',
          cashierId: 'csh-p1',
          cashierName: 'كاشير نشط في الوردية',
          status: 'in_progress',
          hasFinancialEvidence: false,
        ),
        DatedTemplateSlot(
          templateId: 'tpl-protected-2',
          templateName: 'وردية المساء ذات القيود المالية',
          startTime: '16:00',
          endTime: '00:00',
          cashierId: 'csh-p2',
          cashierName: 'كاشير لديه مبيعات ومتحصلات',
          status: 'not_started',
          hasFinancialEvidence: true,
        ),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          const DatedShiftAssignmentScreen(
            initialTemplates: protectedTemplates,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Protected shifts should NOT have swap button
      expect(find.byKey(const Key('btn_swap_tpl-protected-1')), findsNothing);
      expect(find.byKey(const Key('btn_swap_tpl-protected-2')), findsNothing);

      // Protected badge labels visible
      expect(find.text('وردية بدأت بالفعل'), findsOneWidget);
      expect(find.text('محمي بدليل مالي'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}
