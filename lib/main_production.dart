import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assab_app.dart';
import 'core/helpers/app_bloc_observer.dart';
import 'core/init/init_app.dart';
import 'core/utils/app_logger.dart';
import 'core/utils/app_overlay.dart';
import 'core/widgets/app_error_production_screen.dart';
import 'core/widgets/app_startup_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  runZonedGuarded<Future<void>>(
    () async {
      try {
        await initializeApp().timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            throw TimeoutException('مهلة تهيئة خدمات النظام انتهت قبل اكتمال الإقلاع');
          },
        );

        if (kReleaseMode) {
          ErrorWidget.builder = (details) =>
              AppErrorProductionScreen(message: details.exceptionAsString());
        }

        FlutterError.onError = (details) async {
          if (Firebase.apps.isNotEmpty) {
            await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
          }

          if (kReleaseMode) {
            AppOverlay.showErrorOverlay();
          } else {
            FlutterError.dumpErrorToConsole(details);
          }
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          if (Firebase.apps.isNotEmpty) {
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          }

          AppOverlay.showErrorOverlay();

          return true;
        };

        runApp(const AssabApp());
      } catch (e, stack) {
        AppLogger.log('Production startup error: $e\n$stack', tag: 'main_production');
        runApp(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AppStartupErrorWidget(
              errorMessage: e.toString(),
              onRetry: () => main(),
            ),
          ),
        );
      }
    },
    (error, stack) async {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          fatal: true,
        );
      }

      AppOverlay.showErrorOverlay();
    },
  );
}
