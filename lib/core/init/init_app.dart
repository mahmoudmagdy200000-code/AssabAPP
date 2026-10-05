import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../di/dependency_injection.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/realtime_service/realtime_service.dart';
import 'set_portrait_orientation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    setPortraitOrientation(),
    configureDependencies(),
    NotificationService.init(),
  ]);

  await Future.wait([
    AuthService.isLoggedIn(),
    getIt<RealtimeService>().connect(),
  ]);
}
