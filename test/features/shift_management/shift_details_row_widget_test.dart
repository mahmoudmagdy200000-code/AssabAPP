import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/shift_details_row_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildRowTestApp({
  required Widget child,
  double screenWidth = 360,
  double screenHeight = 640,
  TextScaler textScaler = TextScaler.noScaling,
  Locale locale = const Locale('ar'),
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: Size(screenWidth, screenHeight),
      textScaler: textScaler,
    ),
    child: AppResponsiveBuilder(
      designWidth: 375,
      designHeight: 812,
      builder: (context) {
        return MaterialApp(
          navigatorKey: NavigationService.I.navigatorKey,
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
            body: Center(
              child: SizedBox(
                width: screenWidth - 32, // simulates 16px padding on container
                child: child,
              ),
            ),
          ),
        );
      },
    ),
  );
}

void main() {
  group('ShiftDetailsRowWidget Responsive & Overflow Verification', () {
    testWidgets('1. Narrow mobile width (320px) does not overflow with long Arabic label and amount',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const title = 'المبيعات الإجمالية للوردية المسجلة لدى الكاشير';
      const amount = '1,250,999.50 SAR';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 320,
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: title,
            value: amount,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'Must not trigger RenderFlex overflow');
      expect(find.text(title), findsOneWidget);
      expect(find.text(amount), findsOneWidget);
    });

    testWidgets('2. Standard mobile width (360px) renders without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const title = 'المبيعات الإجمالية للوردية المسجلة لدى الكاشير';
      const amount = '1,250,999.50 SAR';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: title,
            value: amount,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(title), findsOneWidget);
      expect(find.text(amount), findsOneWidget);
    });

    testWidgets('3. Accessibility scaling (TextScaler 1.5x) does not overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const title = 'الموظف المسؤول عن مراجعة الوردية واعتمادها';
      const amount = '987,654.32 SAR';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          textScaler: const TextScaler.linear(1.5),
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: title,
            value: amount,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'Must not overflow with 1.5x text scaling');
      expect(find.text(title), findsOneWidget);
      expect(find.text(amount), findsOneWidget);
    });

    testWidgets('4. Custom multi-line valueWidget does not overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const title = 'تم التعيين بواسطة';
      const managerName = 'محمود مجدي عبد الرحمن إبراهيم';
      const managerRole = '(مدير الفرع العام)';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: title,
            valueWidget: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(managerName),
                Text(managerRole),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(title), findsOneWidget);
      expect(find.text(managerName), findsOneWidget);
      expect(find.text(managerRole), findsOneWidget);
    });

    testWidgets('5. Preserves full SAR decimals without truncation',
        (tester) async {
      const title = 'المبلغ المستلم';
      const exactAmount = '123,456.78 SAR';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.cash,
            title: title,
            value: exactAmount,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final textFinder = find.text(exactAmount);
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.data, exactAmount);
      expect(textWidget.data!.endsWith('.78 SAR'), isTrue,
          reason: 'Decimals must be fully preserved in the widget data');
    });

    testWidgets('6. RTL layout positions label and value on correct sides',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const title = 'وقت البدء';
      const value = '08:00 AM';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          locale: const Locale('ar'),
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.clockSvg,
            title: title,
            value: value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final titleTopLeft = tester.getTopLeft(find.text(title));
      final valueTopLeft = tester.getTopLeft(find.text(value));

      // In RTL (Arabic), title starts on the right (higher X coordinate), value ends on the left (lower X coordinate)
      expect(titleTopLeft.dx, greaterThan(valueTopLeft.dx),
          reason: 'In RTL, title should be on the right side and value on the left side');
    });

    testWidgets('7. LTR layout positions label and value on correct sides',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const title = 'Start Time';
      const value = '08:00 AM';

      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          locale: const Locale('en'),
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.clockSvg,
            title: title,
            value: value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final titleTopLeft = tester.getTopLeft(find.text(title));
      final valueTopLeft = tester.getTopLeft(find.text(value));

      // In LTR (English), title starts on the left (lower X coordinate), value ends on the right (higher X coordinate)
      expect(titleTopLeft.dx, lessThan(valueTopLeft.dx),
          reason: 'In LTR, title should be on the left side and value on the right side');
    });

    testWidgets('8. Gracefully handles null value when valueWidget is also null',
        (tester) async {
      await tester.pumpWidget(
        _buildRowTestApp(
          screenWidth: 360,
          child: const ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: 'كاشير بدون بيانات',
            value: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('كاشير بدون بيانات'), findsOneWidget);
    });
  });
}
