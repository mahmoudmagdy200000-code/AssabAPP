import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/cash_shortage_allocation_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildResponsiveTestApp({
  required Widget child,
  required Size viewportSize,
  double bottomInset = 0,
  Locale locale = const Locale('ar'),
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
      data: MediaQueryData(
        size: viewportSize,
        viewInsets: EdgeInsets.only(bottom: bottomInset),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Builder(
          builder: (context) {
            AppResponsive.init(
              context,
              designWidth: viewportSize.width,
              designHeight: viewportSize.height,
            );
            return child;
          },
        ),
      ),
    ),
  );
}

void main() {
  const sampleCandidates = [
    ShortageAllocationCandidate(
      id: '10',
      name: 'علي الكاشير',
      type: 'cashier',
      role: 'كاشير',
    ),
    ShortageAllocationCandidate(
      id: '20',
      name: 'سعد مدير الفرع',
      type: 'branch_manager',
      role: 'مدير فرع',
    ),
  ];

  group('MT-26: Small Screens (320x640 & 360x740) & Keyboard Insets Overflow Tests', () {
    testWidgets(
      'at 320x640 with 280px keyboard open: can scroll, select candidate, enter amount, and add without overflow',
      (tester) async {
        final List<FlutterErrorDetails> errors = [];
        FlutterError.onError = (details) => errors.add(details);

        List<CashShortageAllocation> emitted = [];

        tester.view.physicalSize = const Size(320 * 2, 640 * 2);
        tester.view.devicePixelRatio = 2.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 280 * 2);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.view.resetViewInsets();
        });

        await tester.pumpWidget(
          buildResponsiveTestApp(
            viewportSize: const Size(320, 640),
            bottomInset: 280,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text('End Shift Summary Placeholder'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: CashShortageAllocationWidget(
                      shortageAmount: 30.0,
                      candidates: sampleCandidates,
                      onAllocationsChanged: (allocs) {
                        emitted = allocs;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Must find the title
        expect(find.text('توزيع العجز النقدي'), findsOneWidget);

        // Scroll down to reveal candidate dropdown and inputs in the allocation scrollable
        final allocScrollable = find.byType(Scrollable).last;
        await tester.scrollUntilVisible(
          find.text('اختر المسؤول (الاسم ومعرف النظام)'),
          100.0,
          scrollable: allocScrollable,
        );
        await tester.pumpAndSettle();

        // Select candidate
        await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('علي الكاشير (ID: 10)').last);
        await tester.pumpAndSettle();

        // Scroll to amount input
        await tester.scrollUntilVisible(
          find.byType(TextField).first,
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pumpAndSettle();

        // Enter amount
        await tester.enterText(find.byType(TextField).first, '30.0');
        await tester.pumpAndSettle();

        // Tap Add
        await tester.tap(find.text('أضف'));
        await tester.pumpAndSettle();

        expect(emitted.length, 1);
        expect(emitted.first.responsibleId, '10');
        expect(emitted.first.amount, 30.0);
        expect(find.text('مكتملة'), findsOneWidget);

        // Verify zero RenderFlex overflows
        final overflowErrors = errors.where(
          (e) => e.toString().contains('A RenderFlex overflowed'),
        );
        expect(overflowErrors, isEmpty, reason: 'Expected no RenderFlex overflow on 320x640 with keyboard');
      },
    );

    testWidgets(
      'at 360x740 with 280px keyboard open: can scroll, select candidate, enter amount, and add without overflow',
      (tester) async {
        final List<FlutterErrorDetails> errors = [];
        FlutterError.onError = (details) => errors.add(details);

        List<CashShortageAllocation> emitted = [];

        tester.view.physicalSize = const Size(360 * 2, 740 * 2);
        tester.view.devicePixelRatio = 2.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 280 * 2);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.view.resetViewInsets();
        });

        await tester.pumpWidget(
          buildResponsiveTestApp(
            viewportSize: const Size(360, 740),
            bottomInset: 280,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text('End Shift Summary Placeholder'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: CashShortageAllocationWidget(
                      shortageAmount: 50.0,
                      candidates: sampleCandidates,
                      onAllocationsChanged: (allocs) {
                        emitted = allocs;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('توزيع العجز النقدي'), findsOneWidget);

        final allocScrollable = find.byType(Scrollable).last;
        await tester.scrollUntilVisible(
          find.text('اختر المسؤول (الاسم ومعرف النظام)'),
          100.0,
          scrollable: allocScrollable,
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('علي الكاشير (ID: 10)').last);
        await tester.pumpAndSettle();

        // Scroll to amount input
        await tester.scrollUntilVisible(
          find.byType(TextField).first,
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, '50.0');
        await tester.pumpAndSettle();

        await tester.tap(find.text('أضف'));
        await tester.pumpAndSettle();

        expect(emitted.length, 1);
        expect(emitted.first.responsibleId, '10');
        expect(emitted.first.amount, 50.0);
        expect(find.text('مكتملة'), findsOneWidget);

        final overflowErrors = errors.where(
          (e) => e.toString().contains('A RenderFlex overflowed'),
        );
        expect(overflowErrors, isEmpty, reason: 'Expected no RenderFlex overflow on 360x740 with keyboard');
      },
    );
  });
}
