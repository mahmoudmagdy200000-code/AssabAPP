import 'package:assab/core/cubits/locale/locale_cubit.dart';
import 'package:assab/core/cubits/password/show_password_cubit.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/request_route_observer.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_responsive_builder.dart';
import 'generated/l10n.dart';

class AssabApp extends StatelessWidget {
  const AssabApp({super.key});

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
          ],
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                theme: AppTheme.light,
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
              );
            },
          ),
        );
      },
    );
  }
}
