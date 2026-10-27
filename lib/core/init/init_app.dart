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
      await Firebase.initializeApp();
    }
  } catch (e) {
    AppLogger.log(
      'Firebase not configured in this build — continuing without Firebase ($e).',
      tag: 'initializeApp',
    );
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnvSafely();

  await Future.wait([
    _initializeFirebaseSafely(),
    setPortraitOrientation(),
    configureDependencies(),
    NotificationService.init(),
  ]);

  await Future.wait([
    AuthService.isLoggedIn(),
    getIt<RealtimeService>().connect(),
  ]);
}
