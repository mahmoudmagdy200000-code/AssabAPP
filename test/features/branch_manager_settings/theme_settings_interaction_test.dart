import 'package:assab/core/cubits/locale/locale_cubit.dart';
import 'package:assab/core/cubits/logout/logout_cubit.dart';
import 'package:assab/core/cubits/theme/theme_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_settings/presentation/widgets/branch_manager_settings_system_settings_section.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in const [Locale('ar'), Locale('en')]) {
    testWidgets('Settings theme control changes and persists ${locale.languageCode} mode',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      tester.view.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.platformDispatcher.clearPlatformBrightnessTestValue);

      SharedPreferences.setMockInitialValues({'languageCode': locale.languageCode});
      final prefs = SharedPreferencesHelper(Logger(level: Level.off));
      await prefs.init();
      final themeCubit = ThemeCubit(prefs);
      final localeCubit = LocaleCubit(prefs);
      await getIt.reset();
      getIt.registerFactory<LogoutCubit>(LogoutCubit.new);
      addTearDown(() async {
        await getIt.reset();
        await themeCubit.close();
        await localeCubit.close();
      });

      await tester.pumpWidget(AppResponsiveBuilder(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: themeCubit),
            BlocProvider.value(value: localeCubit),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, mode) => MaterialApp(
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: mode,
              locale: locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: BranchManagerSettingsSystemSettingsSection(),
                ),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(themeCubit.state, ThemeMode.system);
      expect(
        Theme.of(tester.element(find.byType(BranchManagerSettingsSystemSettingsSection))).brightness,
        Brightness.dark,
      );

      final strings = S.of(tester.element(find.byType(BranchManagerSettingsSystemSettingsSection)));
      await tester.tap(find.text(strings.systemPreference).first);
      await tester.pumpAndSettle();
      expect(find.text(strings.darkMode), findsOneWidget);
      await tester.tap(find.text(strings.darkMode));
      await tester.pumpAndSettle();
      expect(themeCubit.state, ThemeMode.dark);
      expect(prefs.getTheme(), 'dark');

      await tester.tap(find.text(strings.darkMode).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings.systemPreference).last);
      await tester.pumpAndSettle();
      expect(themeCubit.state, ThemeMode.system);
      expect(ThemeCubit(prefs).state, ThemeMode.system);

      tester.view.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(BranchManagerSettingsSystemSettingsSection))).brightness,
        Brightness.light,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
