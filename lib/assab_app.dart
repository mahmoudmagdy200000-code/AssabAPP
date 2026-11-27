import 'dart:async';

import 'package:assab/core/cubits/locale/locale_cubit.dart';
import 'package:assab/core/cubits/theme/theme_cubit.dart';
import 'package:assab/core/cubits/password/show_password_cubit.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/request_route_observer.dart';
import 'core/services/in_app_update_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_responsive_builder.dart';
import 'core/widgets/in_app_update_dialog.dart';
import 'generated/l10n.dart';

class AssabApp extends StatefulWidget {
  const AssabApp({super.key});

  @override
  State<AssabApp> createState() => _AssabAppState();
}

class _AssabAppState extends State<AssabApp> with WidgetsBindingObserver {
  final InAppUpdateService _updateService = InAppUpdateService.instance;
  bool _checkingForUpdate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkForUpdate());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_checkForUpdate());
  }

  Future<void> _checkForUpdate() async {
    if (!mounted || _checkingForUpdate) return;
    _checkingForUpdate = true;
    try {
      final navigator = NavigationService.I.navigatorKey.currentState;
      final context = navigator?.context;
      if (context == null) return;
      final release = await checkForAppUpdates(
        context: context,
        service: _updateService,
      );
      if (!mounted || release == null) return;
    } catch (error, stack) {
      AppLogger.log(
        'In-app update check failed safely: $error\n$stack',
        tag: 'InAppUpdate',
      );
    } finally {
      _checkingForUpdate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.log('Is Logged In: ${AuthService.isLoggedInVal}');

    return AppResponsiveBuilder(
      designWidth: 375,
      designHeight: 833,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<ShowPasswordCubit>()),
            BlocProvider(create: (_) => getIt<LocaleCubit>()),
            BlocProvider.value(value: getIt<ThemeCubit>()),
          ],
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                  locale: locale,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  navigatorObservers: [getIt<RequestRouteObserver>()],
                  navigatorKey: NavigationService.I.navigatorKey,
                  initialRoute: AppRouteName.start,
                  onGenerateRoute: AppRouter.generateRoute,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: TextScaler.noScaling),
                      child: child!,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
