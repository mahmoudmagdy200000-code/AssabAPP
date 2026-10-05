import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static bool get _enabled => kDebugMode;

  static void log(String message, {String tag = 'LOG'}) {
    if (!_enabled) return;
    logMessage('[$tag] $message');
  }

  static void logMessage(String message) {
    dev.log(message, name: 'AppLogger');
  }
}
