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

    testWidgets('server rejection (422) displays error and does not swap UI state',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool swapCalled = false;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onExecuteSwap: (cashierAId, shiftAId, cashierBId, shiftBId, date, forFullWeek) async {
              swapCalled = true;
              throw Exception('تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap swap on template 1
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();

      // Tap swap on template 2 (triggering rejected execution)
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      expect(swapCalled, isTrue);

      // Verify server rejection message is displayed
      expect(
        find.textContaining('تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.'),
        findsOneWidget,
      );

      // Verify NO false success message
      expect(find.textContaining('تم تبديل الكاشيرين بنجاح'), findsNothing);

      // Verify UI state was NOT swapped
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

      expect(tester.takeException(), isNull);
    });

    testWidgets('screen retains persisted state from backend across reopening/refreshing',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Simulated remote backend repository
      List<DatedTemplateSlot> backendRoster = [
        const DatedTemplateSlot(
          templateId: 'tpl-1',
          templateName: 'وردية الصباح الأولى',
          startTime: '08:00',
          endTime: '16:00',
          cashierId: 'csh-1',
          cashierName: 'محمد أحمد السعيد',
          status: 'not_started',
        ),
        const DatedTemplateSlot(
          templateId: 'tpl-2',
          templateName: 'وردية المساء الثانية',
          startTime: '16:00',
          endTime: '00:00',
          cashierId: 'csh-2',
          cashierName: 'عبدالله إبراهيم محمود',
          status: 'not_started',
        ),
      ];

      Future<List<DatedTemplateSlot>> fetchRoster(String start, String end) async {
        return List.from(backendRoster);
      }

      Future<void> executeSwap(
        String cA,
        String sA,
        String cB,
        String sB,
        String date,
        bool fullWeek,
      ) async {
        // Backend updates persisted state
        final idxA = backendRoster.indexWhere((t) => t.templateId == sA);
        final idxB = backendRoster.indexWhere((t) => t.templateId == sB);
        final itemA = backendRoster[idxA];
        final itemB = backendRoster[idxB];

        backendRoster[idxA] = itemA.copyWith(
          cashierId: itemB.cashierId,
          cashierName: itemB.cashierName,
        );
        backendRoster[idxB] = itemB.copyWith(
          cashierId: itemA.cashierId,
          cashierName: itemA.cashierName,
        );
      }

      // 1. Initial screen opening
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: fetchRoster,
            onExecuteSwap: executeSwap,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'محمد أحمد السعيد',
      );

      // 2. Perform atomic swap
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      expect(find.textContaining('تم تبديل الكاشيرين بنجاح'), findsOneWidget);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      // 3. Reopen screen (simulating navigating away and back to datedShiftAssignmentScreen)
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: fetchRoster,
            onExecuteSwap: executeSwap,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // State is retained from backend
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'عبدالله إبراهيم محمود',
      );
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'محمد أحمد السعيد',
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('date range navigation buttons update range and trigger reload',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? requestedStart;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: (start, end) async {
              requestedStart = start;
              return [];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-15');

      // Click next week button
      await tester.tap(find.byKey(const Key('btn_next_week')));
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-22');
      expect(find.textContaining('2026-11-22'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}
