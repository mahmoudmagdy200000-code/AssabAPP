import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/brand_owner_financial_reporting/presentation/widgets/brand_owner_financial_reporting_choose_date_bottom_sheet.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final width in const [320.0, 800.0]) {
      testWidgets('owner report month picker uses ${locale.languageCode} labels at ${width.toInt()}px',
          (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

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
            home: BrandOwnerFinancialReportingChooseDateBottomSheet(
              onApply: (_, __) {},
            ),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 250));

        final context = tester.element(find.byType(BrandOwnerFinancialReportingChooseDateBottomSheet));
        final strings = S.of(context);
        expect(find.text(strings.followupAugust), findsOneWidget);
        expect(find.text(strings.followupSeptember), findsOneWidget);
        final layoutError = tester.takeException();
        if (layoutError != null) fail(layoutError.toString());
      });
    }
  }
}
