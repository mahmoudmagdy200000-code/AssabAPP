import 'dart:async';

import 'package:assab/assab_app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/helpers/app_bloc_observer.dart';
import 'core/init/init_app.dart';
import 'core/utils/app_logger.dart';
import 'core/widgets/app_startup_error_widget.dart';

const bool _enableDevicePreview = bool.fromEnvironment(
  'ENABLE_DEVICE_PREVIEW',
  defaultValue: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  try {
    // Enforce 6-second max boundary on total pre-runApp startup so app never hangs indefinitely on splash
    await initializeApp().timeout(
      const Duration(seconds: 6),
      onTimeout: () {
        throw TimeoutException('مهلة تهيئة خدمات النظام انتهت قبل اكتمال الإقلاع');
      },
    );

    runApp(
      DevicePreview(
        enabled: kDebugMode && _enableDevicePreview,
        builder: (context) => const AssabApp(),
      ),
    );
  } catch (e, stack) {
    AppLogger.log('Critical startup error: $e\n$stack', tag: 'main_development');
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
}
