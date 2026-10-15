import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/cash_shortage_allocation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      extensions: LightTheme.extension,
    ),
    home: Builder(
      builder: (context) {
        AppResponsive.init(context, designWidth: 375, designHeight: 812);
        return Scaffold(
          body: SingleChildScrollView(child: child),
        );
      },
    ),
  );
}

void main() {
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

      // Find the ID, Name, and Amount text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4)); // ID, Name, Amount, Reason

      // 1. Enter First allocation: Cashier Ahmed 60.00
      await tester.enterText(textFields.at(0), '101'); // ID
      await tester.enterText(textFields.at(1), 'Ahmed'); // Name
      await tester.enterText(textFields.at(2), '60.00'); // Amount
      await tester.pumpAndSettle();

      // Tap Add button
      final addButton = find.widgetWithText(ElevatedButton, 'إضافة');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check allocation added
      expect(latestAllocations.length, equals(1));
      expect(latestAllocations.first.responsibleId, equals('101'));
      expect(latestAllocations.first.amount, equals(60.0));
      expect(find.textContaining('Ahmed'), findsOneWidget);
      expect(find.textContaining('40.00'), findsWidgets); // remaining is 40.00

      // 2. Enter Second allocation: Manager Khaled 40.00
      await tester.enterText(textFields.at(0), '202'); // ID
      await tester.enterText(textFields.at(1), 'Khaled'); // Name
      await tester.enterText(textFields.at(2), '40.00'); // Amount
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check balanced completion
      expect(latestAllocations.length, equals(2));
      expect(latestAllocations[1].responsibleId, equals('202'));
      expect(latestAllocations[1].amount, equals(40.0));
      expect(find.textContaining('0.00'), findsWidgets); // remaining is 0.00
      expect(find.text('مكتمل'), findsOneWidget);

      // 3. Remove first allocation
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsNWidgets(2));
      await tester.tap(closeButtons.first);
      await tester.pumpAndSettle();

      expect(latestAllocations.length, equals(1));
      expect(latestAllocations.first.responsibleId, equals('202'));

      // Test reason field update
      await tester.enterText(textFields.at(3), 'End-of-shift register discrepancy');
      await tester.pumpAndSettle();
      expect(latestReason, equals('End-of-shift register discrepancy'));
    });

    testWidgets('Validates input errors: empty ID, exceeding amount, duplicate ID',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CashShortageAllocationWidget(
            shortageAmount: 50.0,
            onAllocationsChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final addButton = find.widgetWithText(ElevatedButton, 'إضافة');
      final textFields = find.byType(TextField);

      // 1. Tap add with empty fields -> Error snackbar for ID
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('يرجى إدخال معرّف المسؤول'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 2. Enter ID, tap add with empty amount -> Error snackbar for Amount
      await tester.enterText(textFields.at(0), '101');
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('يرجى إدخال مبلغ صحيح أكبر من الصفر'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 3. Enter amount exceeding remaining (75 > 50) -> Error snackbar for exceeding
      await tester.enterText(textFields.at(2), '75.00');
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('مبلغ التوزيع يتجاوز المتبقي من العجز'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold))).clearSnackBars();
      await tester.pumpAndSettle();

      // 4. Enter valid partial 20.00 -> Success
      await tester.enterText(textFields.at(2), '20.00');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // 5. Try adding same ID again -> Error snackbar for duplicate
      await tester.enterText(textFields.at(0), '101');
      await tester.enterText(textFields.at(2), '10.00');
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('تمت إضافة هذا المسؤول مسبقاً'), findsOneWidget);
    });
  });
}
