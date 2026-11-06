import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/cash_shortage_allocation_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestApp(Widget child, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(
      extensions: LightTheme.extension,
    ),
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
  final sampleCandidates = [
    const ShortageAllocationCandidate(
      id: '101',
      name: 'أحمد الكاشير',
      type: 'cashier',
      role: 'كاشير',
    ),
    const ShortageAllocationCandidate(
      id: '102',
      name: 'خالد الكاشير الثاني',
      type: 'cashier',
      role: 'كاشير',
    ),
  ];

  group('CashShortageAllocationWidget Tests', () {
    testWidgets('Renders balanced / no shortage message when shortageAmount <= 0',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CashShortageAllocationWidget(
            shortageAmount: 0.0,
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('لا يوجد عجز نقدي يستدعي توزيع المسؤولية.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Renders shortage allocation form, adds actors, and reaches zero remaining balance',
        (tester) async {
      List<CashShortageAllocation> latestAllocations = [];
      String? latestReason;

      await tester.pumpWidget(
        buildTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              return CashShortageAllocationWidget(
                shortageAmount: 100.0,
                initialAllocations: latestAllocations,
                candidates: sampleCandidates,
                onAllocationsChanged: (allocs) {
                  setState(() {
                    latestAllocations = allocs;
                  });
                },
                onReasonChanged: (reason) {
                  latestReason = reason;
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial shortage and remaining display
      expect(find.textContaining('100.00'), findsWidgets);

      // 1. Select first candidate (Ahmed) from dropdown
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('أحمد الكاشير (ID: 101)').last);
      await tester.pumpAndSettle();

      // Enter amount 60.00
      final amountField = find.byType(TextField).first;
      await tester.enterText(amountField, '60.00');
      await tester.pumpAndSettle();

      // Tap 'أضف' button
      await tester.tap(find.text('أضف'));
      await tester.pumpAndSettle();

      // Check allocation added
      expect(latestAllocations.length, equals(1));
      expect(latestAllocations.first.responsibleId, equals('101'));
      expect(latestAllocations.first.amount, equals(60.0));
      expect(find.textContaining('أحمد الكاشير'), findsWidgets);
      expect(find.textContaining('40.00'), findsWidgets); // remaining is 40.00

      // 2. Select second candidate (Khaled) from dropdown
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('خالد الكاشير الثاني (ID: 102)').last);
      await tester.pumpAndSettle();

      // Enter amount 40.00
      await tester.enterText(amountField, '40.00');
      await tester.pumpAndSettle();

      await tester.tap(find.text('أضف'));
      await tester.pumpAndSettle();

      // Check balanced completion
      expect(latestAllocations.length, equals(2));
      expect(latestAllocations[1].responsibleId, equals('102'));
      expect(latestAllocations[1].amount, equals(40.0));
      expect(find.textContaining('0.00'), findsWidgets); // remaining is 0.00
      expect(find.text('مكتملة'), findsOneWidget);

      // 3. Remove first allocation
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsNWidgets(2));
      await tester.tap(closeButtons.first);
      await tester.pumpAndSettle();

      expect(latestAllocations.length, equals(1));
      expect(latestAllocations.first.responsibleId, equals('102'));

      // Test reason field update (second TextField)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2)); // Amount, Reason
      await tester.enterText(textFields.last, 'End-of-shift register discrepancy');
      await tester.pumpAndSettle();
      expect(latestReason, equals('End-of-shift register discrepancy'));
    });

    testWidgets('Validates input errors: empty candidate, exceeding amount, duplicate candidate',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CashShortageAllocationWidget(
            shortageAmount: 50.0,
            candidates: sampleCandidates,
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final addButton = find.text('أضف');
      final amountField = find.byType(TextField).first;

      // 1. Tap add without candidate selection -> Error snackbar
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('يرجى اختيار المسؤول من القائمة'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 2. Select candidate, tap add with empty amount -> Error snackbar
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('أحمد الكاشير (ID: 101)').last);
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('يرجى إدخال مبلغ صحيح أكبر من الصفر'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 3. Enter amount exceeding remaining (75 > 50) -> Error snackbar
      await tester.enterText(amountField, '75.00');
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('مبلغ التوزيع يتجاوز المتبقي من العجز'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 4. Enter valid partial 20.00 -> Success
      await tester.enterText(amountField, '20.00');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // 5. Try adding same candidate again -> Error snackbar for duplicate
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('أحمد الكاشير (ID: 101)').last);
      await tester.pumpAndSettle();

      await tester.enterText(amountField, '10.00');
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('تمت إضافة هذا المسؤول مسبقاً'), findsOneWidget);
    });
  });
}
