import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/assab_app.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/routing/app_router.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/realtime_service/realtime_event.dart';
import 'package:assab/core/services/realtime_service/realtime_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_startup_error_widget.dart';
import 'package:assab/features/login/presentation/screens/login_with_email_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestTokenStorage extends TokenStorageService {
  String? _token;

  _TestTokenStorage({String? initialToken})
      : _token = initialToken,
        super(const FlutterSecureStorage());

  @override
  Future<void> saveAccessToken(String token) async => _token = token;

  @override
  Future<void> saveRefreshToken(String token) async {}

  @override
  Future<String?> getAccessToken() async => _token;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> clearTokens() async => _token = null;

  @override
  Future<void> deleteAll() async => _token = null;
}

class _NoopRealtimeService implements RealtimeService {
  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Stream<RealtimeEvent<T>> subscribe<T>({
    required String channel,
    required T Function(Map<String, dynamic> json) mapper,
  }) => const Stream.empty();

  @override
  Future<void> unsubscribe(String channel) async {}
}

class _MockHttpAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode({
        'success': true,
        'message': 'OK',
        'data': {'token': 'test-token'},
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<void> _bootLoginDependencies({String? baseUrl}) async {
  await getIt.reset();
  getIt.allowReassignment = true;
  SharedPreferences.setMockInitialValues({});
  ApiEndpoint.debugTestBaseUrl = baseUrl;

  await configureDependencies();

  if (baseUrl != null && baseUrl.isNotEmpty) {
    getIt<Dio>().httpClientAdapter = _MockHttpAdapter();
  }
  getIt.registerSingleton<TokenStorageService>(_TestTokenStorage());
  getIt.registerSingleton<RealtimeService>(_NoopRealtimeService());

  UserTypeService.selectedUserType = null;
  UserTypeService.selectedUserTypeStrategy = null;
  await AuthService.isLoggedIn();
}

Future<void> _pumpTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(milliseconds: 250));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    ApiEndpoint.debugTestBaseUrl = null;
    UserTypeService.selectedUserType = null;
    UserTypeService.selectedUserTypeStrategy = null;
    await getIt.reset();
  });

  group('Login Screen Layout & API Base URL Handling Tests', () {
    testWidgets(
      'Displays AppStartupErrorWidget gracefully when API_BASE_URL is missing',
      (tester) async {
        await _bootLoginDependencies(baseUrl: ''); // Missing/empty base URL

        tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        final route = AppRouter.generateRoute(
          const RouteSettings(name: AppRouteName.loginWithEmailScreen),
        );

        expect(route, isNotNull);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => (route as MaterialPageRoute).builder(context),
            ),
          ),
        );
        await _pumpTransition(tester);

        // Verify that AppStartupErrorWidget renders gracefully rather than Flutter ErrorWidget
        expect(find.byType(AppStartupErrorWidget), findsOneWidget);
        expect(find.textContaining('API_BASE_URL'), findsOneWidget);
        expect(find.byKey(const Key('btn_retry_startup')), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '390px Mobile: Renders LoginWithEmailScreen with zero RenderFlex overflow and accessible login button',
      (tester) async {
        await _bootLoginDependencies(
          baseUrl: 'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/',
        );

        tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const AssabApp());
        await _pumpTransition(tester);

        NavigationService.I.replaceWithNamed(AppRouteName.loginWithEmailScreen);
        await _pumpTransition(tester);

        expect(find.byType(LoginWithEmailScreen), findsOneWidget);
        expect(find.byType(AppButton), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '390px Mobile with Keyboard open (bottom inset 300px): Zero RenderFlex overflow and scrollable to button',
      (tester) async {
        await _bootLoginDependencies(
          baseUrl: 'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/',
        );

        tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const AssabApp());
        await _pumpTransition(tester);

        NavigationService.I.replaceWithNamed(AppRouteName.loginWithEmailScreen);
        await _pumpTransition(tester);

        expect(find.byType(LoginWithEmailScreen), findsOneWidget);

        // Simulate software keyboard opening with 300px bottom inset
        tester.view.viewInsets = const FakeViewPadding(bottom: 300 * 2.0);
        addTearDown(tester.view.resetViewInsets);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Expect zero RenderFlex overflow
        expect(tester.takeException(), isNull);

        // Ensure login button is findable
        expect(find.byType(AppButton), findsWidgets);
      },
    );

    testWidgets(
      '820px Tablet: Renders LoginWithEmailScreen with zero RenderFlex overflow and accessible login button',
      (tester) async {
        await _bootLoginDependencies(
          baseUrl: 'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/',
        );

        tester.view.physicalSize = const Size(820 * 2.0, 1180 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const AssabApp());
        await _pumpTransition(tester);

        NavigationService.I.replaceWithNamed(AppRouteName.loginWithEmailScreen);
        await _pumpTransition(tester);

        expect(find.byType(LoginWithEmailScreen), findsOneWidget);
        expect(find.byType(AppButton), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
