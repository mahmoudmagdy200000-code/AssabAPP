import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
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
  const sampleCandidates = [
    ShortageAllocationCandidate(
      id: '101',
      name: 'Ahmed',
      type: 'cashier',
      role: 'أمين الصندوق',
    ),
    ShortageAllocationCandidate(
      id: '202',
      name: 'Khaled',
      type: 'branch_manager',
      role: 'مدير الفرع',
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
                candidates: sampleCandidates,
                initialAllocations: latestAllocations,
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

      // Verify initial shortage display
      expect(find.textContaining('100.00'), findsWidgets);

      // 1. Select First allocation: Cashier Ahmed 60.00
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ahmed (ID: 101)').last);
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, '60.00'); // Amount
      await tester.pumpAndSettle();

      // Tap Add button
      final addButton = find.widgetWithText(ElevatedButton, 'أضف');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check allocation added
      expect(latestAllocations.length, equals(1));
      expect(latestAllocations.first.responsibleId, equals('101'));
      expect(latestAllocations.first.amount, equals(60.0));
      expect(find.textContaining('Ahmed'), findsOneWidget);
      expect(find.textContaining('40.00'), findsWidgets); // remaining is 40.00

      // 2. Select Second allocation: Manager Khaled 40.00
      // Switch type to branch_manager
      await tester.tap(find.text('أمين الصندوق').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('مدير الفرع').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Khaled (ID: 202)').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '40.00');
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check balanced completion
      expect(latestAllocations.length, equals(2));
      expect(latestAllocations[1].responsibleId, equals('202'));
      expect(latestAllocations[1].amount, equals(40.0));
      expect(find.textContaining('0.00'), findsWidgets); // remaining is 0.00
      expect(find.text('مكتملة'), findsOneWidget);

      // 3. Remove first allocation
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsNWidgets(2));
      await tester.tap(closeButtons.first);
      await tester.pumpAndSettle();

      expect(latestAllocations.length, equals(1));
      expect(latestAllocations.first.responsibleId, equals('202'));

      // Test reason field update
      final reasonField = find.byType(TextField).last;
      await tester.enterText(reasonField, 'End-of-shift register discrepancy');
      await tester.pumpAndSettle();
      expect(latestReason, equals('End-of-shift register discrepancy'));
    });

    testWidgets('Validates input errors: empty ID, exceeding amount, duplicate ID',
        (tester) async {
      List<CashShortageAllocation> latestAllocations = [];

      await tester.pumpWidget(
        buildTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              return CashShortageAllocationWidget(
                shortageAmount: 50.0,
                candidates: sampleCandidates,
                initialAllocations: latestAllocations,
                onAllocationsChanged: (allocs) {
                  setState(() {
                    latestAllocations = allocs;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final addButton = find.widgetWithText(ElevatedButton, 'أضف');

      // 1. Tap add without candidate -> Error snackbar
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('يرجى اختيار المسؤول من القائمة'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 2. Select candidate, tap add with empty amount -> Error snackbar for Amount
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ahmed (ID: 101)').last);
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('يرجى إدخال مبلغ صحيح أكبر من الصفر'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 3. Enter amount exceeding remaining (75 > 50) -> Error snackbar for exceeding
      final amountField = find.byType(TextField).first;
      await tester.enterText(amountField, '75.00');
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('مبلغ التوزيع يتجاوز المتبقي من العجز'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 4. Enter valid partial 20.00 -> Success
      await tester.enterText(amountField, '20.00');
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(latestAllocations.length, 1);

      // 5. Try adding same candidate again -> Error snackbar for duplicate
      await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ahmed (ID: 101)').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '10.00');
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('تمت إضافة هذا المسؤول مسبقاً'), findsOneWidget);
    });
  });
}