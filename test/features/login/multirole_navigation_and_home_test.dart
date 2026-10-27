import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/assab_app.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/services/realtime_service/realtime_event.dart';
import 'package:assab/core/services/realtime_service/realtime_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_logout_button.dart';
import 'package:assab/features/brach_manager_main/presentation/screens/branch_manager_main_screen.dart';
import 'package:assab/features/brand_owner_main/presentation/screens/brand_owner_main_screen.dart';
import 'package:assab/features/cashier_main/presentation/screens/cashier_main_screen.dart';
import 'package:assab/features/choose_user_type/presentation/screens/choose_user_type_screen.dart';
import 'package:assab/features/login/presentation/screens/login_with_email_screen.dart';
import 'package:assab/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:assab/features/supplier_main/presentation/screens/supplier_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _AppFlowHttpAdapter implements HttpClientAdapter {
  final List<String> hitPaths = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path;
    hitPaths.add('${options.method} $path');

    if (options.method == 'POST' && path.endsWith('/auth/login')) {
      return ResponseBody.fromString(
        jsonEncode({
          'success': true,
          'message': 'Authenticated',
          'data': {
            'token': 'staging-mock-token',
            'user': {
              'id': '12',
              'name': 'Staging Demo Operator',
              'email': 'operator@fixture.invalid',
              'phone': '+966501234567',
            },
          },
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (options.method == 'POST' && path.endsWith('/logout')) {
      return ResponseBody.fromString(
        jsonEncode({'success': true, 'message': 'Logged out successfully'}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return ResponseBody.fromString(
      jsonEncode({
        'success': false,
        'message': 'Endpoint unavailable in mocked navigation test',
      }),
      404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<_AppFlowHttpAdapter> _bootTestDependencies({
  Map<String, Object> initialPrefs = const {},
  String? initialToken,
}) async {
  await getIt.reset();
  getIt.allowReassignment = true;
  SharedPreferences.setMockInitialValues(initialPrefs);
  ApiEndpoint.debugTestBaseUrl =
      'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/';

  await configureDependencies();

  final adapter = _AppFlowHttpAdapter();
  getIt<Dio>().httpClientAdapter = adapter;
  getIt.registerSingleton<TokenStorageService>(
    _TestTokenStorage(initialToken: initialToken),
  );
  getIt.registerSingleton<RealtimeService>(_NoopRealtimeService());

  // Reset static in-memory fields without deleting seeded SharedPreferences keys
  UserTypeService.selectedUserType = null;
  UserTypeService.selectedUserTypeStrategy = null;
  await AuthService.isLoggedIn();
  return adapter;
}

Future<void> _pumpTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(milliseconds: 250));
}

void _ignoreTestAhemOverflowErrors() {
  final originalOnError = FlutterError.onError;
  addTearDown(() => FlutterError.onError = originalOnError);
  FlutterError.onError = (FlutterErrorDetails details) {
    final msg = details.exceptionAsString();
    if (msg.contains('A RenderFlex overflowed by')) {
      // flutter_test uses square Ahem glyph metrics on pre-existing screens;
      // ignore layout overflow noise while still failing on all real exceptions.
      return;
    }
    originalOnError?.call(details);
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    ApiEndpoint.debugTestBaseUrl = null;
    UserTypeService.selectedUserType = null;
    UserTypeService.selectedUserTypeStrategy = null;
    await getIt.reset();
  });

  testWidgets(
    'Phase A: Cold start unauthenticated renders ChooseUserTypeScreen with strictly the 4 supported mobile roles',
    (tester) async {
      _ignoreTestAhemOverflowErrors();
      await tester.binding.setSurfaceSize(const Size(430, 960));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await _bootTestDependencies();
      await tester.pumpWidget(const AssabApp());
      await _pumpTransition(tester);

      expect(find.byType(ChooseUserTypeScreen), findsOneWidget);
      expect(find.text('Branch Manager'), findsOneWidget);
      expect(find.text('Cashier'), findsOneWidget);
      expect(find.text('Supplier'), findsOneWidget);
      expect(find.text('Brand Owner'), findsOneWidget);

      expect(find.text('Company Admin'), findsNothing);
      expect(find.text('Accountant'), findsNothing);
      expect(find.text('Head Accountant'), findsNothing);
      expect(find.text('Procurement'), findsNothing);
    },
  );

  final roleNavigationCases = <({
    String roleTitle,
    UserType userType,
    String email,
    String expectedLoginHit,
    String expectedLogoutHit,
    Type expectedMainScreen,
    int settingsTabIndex,
  })>[
    (
      roleTitle: 'Branch Manager',
      userType: UserType.branchManager,
      email: 'assab-ui-qa-20261018.branch-manager@fixture.invalid',
      expectedLoginHit: 'POST /api/v1/branch-manager/auth/login',
      expectedLogoutHit: 'POST /api/v1/branch-manager/auth/logout',
      expectedMainScreen: BranchManagerMainScreen,
      settingsTabIndex: 4,
    ),
    (
      roleTitle: 'Cashier',
      userType: UserType.cashier,
      email: 'assab-ui-qa-20261018.cashier@fixture.invalid',
      expectedLoginHit: 'POST /api/v1/cashier/auth/login',
      expectedLogoutHit: 'POST /api/v1/cashier/logout',
      expectedMainScreen: CashierMainScreen,
      settingsTabIndex: 4,
    ),
    (
      roleTitle: 'Supplier',
      userType: UserType.supplier,
      email: 'supplier.demo@fixture.invalid',
      expectedLoginHit: 'POST /api/v1/supplier/auth/login',
      expectedLogoutHit: 'POST /api/v1/supplier/auth/logout',
      expectedMainScreen: SupplierMainScreen,
      settingsTabIndex: 2,
    ),
    (
      roleTitle: 'Brand Owner',
      userType: UserType.brandOwner,
      email: 'brand-owner.demo@fixture.invalid',
      expectedLoginHit: 'POST /api/v1/brand-owner/auth/login',
      expectedLogoutHit: 'POST /api/v1/brand-owner/auth/logout',
      expectedMainScreen: BrandOwnerMainScreen,
      settingsTabIndex: 4,
    ),
  ];

  for (final tc in roleNavigationCases) {
    testWidgets(
      'Phase B & C (Local Mocked UI): ${tc.roleTitle} selects role -> Login -> navigates to ${tc.expectedMainScreen} -> Logout returns to ChooseUserTypeScreen',
      (tester) async {
        _ignoreTestAhemOverflowErrors();
        await tester.binding.setSurfaceSize(const Size(430, 960));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final adapter = await _bootTestDependencies();
        await tester.pumpWidget(const AssabApp());
        await _pumpTransition(tester);

        expect(find.byType(ChooseUserTypeScreen), findsOneWidget);
        await tester.tap(find.text(tc.roleTitle));
        await _pumpTransition(tester);

        final confirmBtn = find.byType(AppButton).last;
        await tester.tap(confirmBtn);
        await _pumpTransition(tester);

        expect(find.byType(OnboardingScreen), findsOneWidget);
        await tester.tap(find.widgetWithText(AppButton, 'Login'));
        await _pumpTransition(tester);

        expect(find.byType(LoginWithEmailScreen), findsOneWidget);
        final fields = find.byType(TextFormField);
        expect(fields, findsNWidgets(2));
        await tester.enterText(fields.at(0), tc.email);
        await tester.enterText(fields.at(1), 'harness-pass_2026');
        await _pumpTransition(tester);

        final loginSubmit = find.byType(AppButton).first;
        await tester.ensureVisible(loginSubmit);
        await tester.tap(loginSubmit);
        await _pumpTransition(tester);

        expect(adapter.hitPaths, contains(tc.expectedLoginHit));
        expect(AuthService.isLoggedInVal, isTrue);
        expect(UserTypeService.getSavedUserType(), equals(tc.userType));
        expect(find.byType(tc.expectedMainScreen), findsOneWidget);

        final mainContext = tester.element(find.byType(tc.expectedMainScreen));
        mainContext.read<PagingCubit>().goToStep(tc.settingsTabIndex);
        await _pumpTransition(tester);

        final logoutWidget = find.byType(AppLogoutButton);
        expect(logoutWidget, findsOneWidget);
        await tester.ensureVisible(logoutWidget);
        final logoutAppBtn = find.descendant(
          of: logoutWidget,
          matching: find.byType(AppButton),
        );
        await tester.tap(logoutAppBtn);
        await _pumpTransition(tester);

        expect(adapter.hitPaths, contains(tc.expectedLogoutHit));
        expect(AuthService.isLoggedInVal, isFalse);
        expect(find.byType(ChooseUserTypeScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Cold-start session restoration routes ${tc.roleTitle} directly to ${tc.expectedMainScreen}',
      (tester) async {
        _ignoreTestAhemOverflowErrors();
        await tester.binding.setSurfaceSize(const Size(430, 960));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await _bootTestDependencies(
          initialPrefs: {
            'selected_user_type': tc.userType.value,
            'u_name': 'Restored ${tc.roleTitle}',
            'u_id': '88',
          },
          initialToken: 'persisted-token-${tc.userType.value}',
        );

        await tester.pumpWidget(const AssabApp());
        await _pumpTransition(tester);

        expect(AuthService.isLoggedInVal, isTrue);
        expect(UserTypeService.selectedUserType, equals(tc.userType));
        expect(UserTypeService.selectedUserTypeStrategy, isNotNull);
        expect(find.byType(tc.expectedMainScreen), findsOneWidget);
      },
    );
  }
}
