import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../di/dependency_injection.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/realtime_service/realtime_service.dart';
import '../utils/app_logger.dart';
import 'set_portrait_orientation.dart';

Future<void> _loadEnvSafely() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    AppLogger.log(
      'Optional .env asset not loaded ($e); using --dart-define configuration.',
      tag: 'initializeApp',
    );
  }
}

Future<void> _initializeFirebaseSafely() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          AppLogger.log('Firebase.initializeApp timed out — continuing.', tag: 'initializeApp');
          return Firebase.app();
        },
      );
    }
  } catch (e) {
    AppLogger.log(
      'Firebase not configured in this build — continuing without Firebase ($e).',
      tag: 'initializeApp',
    );
  }
}

Future<void> _initializeOptionalService(
  String name,
  Future<void> Function() initFn, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  try {
    await initFn().timeout(
      timeout,
      onTimeout: () {
        AppLogger.log(
          'Optional service "$name" initialization timed out — continuing.',
          tag: 'initializeApp',
        );
      },
    );
  } catch (e) {
    AppLogger.log(
      'Optional service "$name" initialization failed ($e) — continuing.',
      tag: 'initializeApp',
    );
  }
}

Future<void> _connectRealtimeSafely() async {
  try {
    if (getIt.isRegistered<RealtimeService>()) {
      await getIt<RealtimeService>().connect().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          AppLogger.log(
            'RealtimeService connection timed out in background.',
            tag: 'RealtimeService',
          );
        },
      );
    }
  } catch (e) {
    AppLogger.log(
      'RealtimeService background connect failed ($e) — realtime will reconnect on demand.',
      tag: 'RealtimeService',
    );
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnvSafely();

  // 1. Orientation lock (safe, non-blocking on failure)
  try {
    await setPortraitOrientation();
  } catch (e) {
    AppLogger.log('Orientation setup failed ($e) — continuing.', tag: 'initializeApp');
  }

  // 2. Dependency injection: essential core setup
  await configureDependencies();

  // 3. Optional services and fast local auth check with individual timeouts
  await Future.wait([
    _initializeOptionalService('Firebase', _initializeFirebaseSafely),
    _initializeOptionalService('NotificationService', NotificationService.init),
    _initializeOptionalService('AuthService', AuthService.isLoggedIn),
  ]);

  // 4. Background services: MUST NOT delay runApp / UI render
  unawaited(_connectRealtimeSafely());
}
