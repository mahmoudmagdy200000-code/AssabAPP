import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'core/network/api_endpoints.dart';
import 'shift_demo/demo_controller.dart';
import 'shift_demo/demo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (!ApiEndpoint.isDemoBuild) {
      throw StateError(
        'Build this entrypoint with --dart-define=DEMO_MODE=true',
      );
    }
    final url = ApiEndpoint.normalizeBaseUrl(ApiEndpoint.baseUrl, demo: true);
    final controller = DemoController(
      Dio(
        BaseOptions(
          baseUrl: url,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Accept': 'application/json'},
          contentType: 'application/json',
          followRedirects: false,
        ),
      ),
    );
    runApp(ShiftDemoApp(controller: controller, server: Uri.parse(url).host));
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Demo configuration error\n$e'),
            ),
          ),
        ),
      ),
    );
  }
}
