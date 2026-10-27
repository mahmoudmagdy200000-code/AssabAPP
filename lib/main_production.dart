import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assab_app.dart';
import 'core/helpers/app_bloc_observer.dart';
import 'core/init/init_app.dart';
import 'core/utils/app_overlay.dart';
import 'core/widgets/app_error_production_screen.dart';

void main() async {
  Bloc.observer = AppBlocObserver();

  runZonedGuarded<Future<void>>(
    () async {
      await initializeApp();

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
