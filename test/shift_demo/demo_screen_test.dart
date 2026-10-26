import 'package:assab/shift_demo/demo_controller.dart';
import 'package:assab/shift_demo/demo_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'demo_controller_test.dart' show previewBody;

void main() {
  testWidgets('login form is real-backend labeled and password is obscured', (
    tester,
  ) async {
    final c = DemoController(Dio());
    await tester.pumpWidget(
      ShiftDemoApp(controller: c, server: 'staging.example'),
    );
    expect(find.text('دخول الكاشير'), findsOneWidget);
    expect(find.textContaining('staging.example'), findsOneWidget);
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .where((w) => w.obscureText)
          .length,
      1,
    );
    expect(find.byKey(const Key('close-shift')), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('server shortage blocks closure until exact allocation', (
    tester,
  ) async {
    final c = DemoController(Dio())..loggedIn = true;
    c.shift = {'id': 's1', 'status': 'in_progress'};
    c.preview = DemoPreview(previewBody());
    await tester.pumpWidget(
      ShiftDemoApp(controller: c, server: 'staging.example'),
    );
    await tester.scrollUntilVisible(
      find.text('النقد المتوقع: 50'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('النقد المتوقع: 50'), findsOneWidget);
    expect(find.text('الفرق بإشارته: -20'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('close-shift')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('close-shift')))
          .onPressed,
      isNull,
    );
    c.allocate([const DemoAllocation('cashier', 'c1', '20')]);
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('close-shift')))
          .onPressed,
      isNotNull,
    );
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('completed server status does not expose closure controls', (
    tester,
  ) async {
    final c = DemoController(Dio())..loggedIn = true;
    c.shift = {'id': 's1', 'status': 'completed'};
    await tester.pumpWidget(
      ShiftDemoApp(controller: c, server: 'staging.example'),
    );
    expect(find.text('الحالة من السيرفر: completed'), findsOneWidget);
    expect(find.byKey(const Key('close-shift')), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
