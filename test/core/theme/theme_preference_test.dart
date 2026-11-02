import 'package:assab/core/cubits/theme/theme_cubit.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('system preference persists and supplies a dark theme', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = SharedPreferencesHelper(Logger(level: Level.off));
    await prefs.init();
    final cubit = ThemeCubit(prefs);

    expect(cubit.state, ThemeMode.system);
    await cubit.toggle(ThemeMode.dark);
    expect(cubit.state, ThemeMode.dark);
    expect(prefs.getTheme(), 'dark');
    await cubit.toggle(ThemeMode.system);
    expect(ThemeCubit(prefs).state, ThemeMode.system);
    await cubit.close();
  });

  testWidgets('system preference follows device brightness', (tester) async {
    tester.view.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.view.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(AppResponsiveBuilder(
      builder: (_) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: Builder(builder: (context) {
          return Text(Theme.of(context).brightness.name);
        }),
      ),
    ));
    expect(find.text('dark'), findsOneWidget);
  });
}
