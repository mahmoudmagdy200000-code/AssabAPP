import 'package:assab/assab_app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/helpers/app_bloc_observer.dart';
import 'core/init/init_app.dart';

const bool _enableDevicePreview = bool.fromEnvironment(
  'ENABLE_DEVICE_PREVIEW',
  defaultValue: false,
);

void main() async {
  Bloc.observer = AppBlocObserver();

  await initializeApp();

  runApp(
    DevicePreview(
      enabled: kDebugMode && _enableDevicePreview,
      builder: (context) => const AssabApp(),
    ),
  );
}
