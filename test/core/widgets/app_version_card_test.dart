import 'package:assab/core/theme/custom_colors.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/core/widgets/app_version_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.erp.assab/in_app_updates');

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'shows installed version and update action in ${locale.languageCode} ${brightness.name} mode',
        (tester) async {
          tester.view.physicalSize = const Size(360, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, (call) async {
                if (call.method != 'getConfiguration') return null;
                return <String, Object>{
                  'channel': 'production',
                  'manifestUrl': '',
                  'packageName': 'com.erp.assab',
                  'versionCode': 41,
                  'versionName': '2.7.4',
                  'distributionAllowed': true,
                  'playStoreManaged': false,
                };
              });
          addTearDown(
            () => TestDefaultBinaryMessengerBinding
                .instance
                .defaultBinaryMessenger
                .setMockMethodCallHandler(channel, null),
          );

          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: _theme(Brightness.light),
              darkTheme: _theme(Brightness.dark),
              themeMode: brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const AppResponsiveBuilder(builder: _buildCard),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(AppVersionCard), findsOneWidget);
          expect(
            find.text(
              locale.languageCode == 'ar' ? 'الإصدار 2.7.4' : 'Version 2.7.4',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              locale.languageCode == 'ar' ? 'رقم البناء 41' : 'Build 41',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              locale.languageCode == 'ar'
                  ? 'تحقق من التحديثات'
                  : 'Check for updates',
            ),
            findsOneWidget,
          );
          expect(
            Directionality.of(tester.element(find.byType(AppVersionCard))),
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          );
          expect(
            Theme.of(tester.element(find.byType(AppVersionCard))).brightness,
            brightness,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

Widget _buildCard(BuildContext context) =>
    const Scaffold(body: SingleChildScrollView(child: AppVersionCard()));

ThemeData _theme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B3FC6),
      brightness: brightness,
    ),
    extensions: <ThemeExtension<CustomColors>>[
      CustomColors(
        text1: isDark ? Colors.white : const Color(0xFF222431),
        text2: isDark ? const Color(0xFF222431) : const Color(0xFFF2F2F5),
        text3: isDark ? const Color(0xFFB9BBC6) : const Color(0xFF666875),
        text4: isDark ? const Color(0xFFD2D3DA) : const Color(0xFF777986),
        text5: isDark ? const Color(0xFFE7E8EC) : const Color(0xFF888A95),
        text6: isDark ? Colors.white : Colors.black,
        reversedTextColor: isDark
            ? const Color(0xFF191B27)
            : Colors.white,
        error: Colors.red,
        border: isDark ? const Color(0xFF484B5A) : const Color(0xFFE0E0E6),
        dark: isDark ? Colors.white : Colors.black,
      ),
    ],
  );
}
