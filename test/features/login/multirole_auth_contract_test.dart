import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/core/network/dio_client.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/services/realtime_service/realtime_event.dart';
import 'package:assab/core/services/realtime_service/realtime_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/app_reg_exp.dart';
import 'package:assab/features/active_account/data/data_source/active_account_remote_data_source.dart';
import 'package:assab/features/active_account/data/repository/active_account_repository_impl.dart';
import 'package:assab/features/active_account/domain/usecases/first_login_usecase.dart';
import 'package:assab/features/active_account/domain/usecases/reset_password_first_login_usecase.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account/active_account_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account/active_account_state.dart';
import 'package:assab/features/login/data/data_source/login_remote_data_source.dart';
import 'package:assab/features/login/data/repository/login_repository.dart';
import 'package:assab/features/login/domain/usecases/branch_manager_login_usecase.dart';
import 'package:assab/features/login/domain/usecases/brand_owner_login_usecase.dart';
import 'package:assab/features/login/domain/usecases/cashier_login_usecase.dart';
import 'package:assab/features/login/domain/usecases/supplier_login_usecase.dart';
import 'package:assab/features/login/presentation/cubits/login/login_cubit.dart';
import 'package:assab/features/login/presentation/cubits/login/login_state.dart';
import 'package:assab/features/login/presentation/cubits/login_form/login_form_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _InMemoryTokenStorage extends TokenStorageService {
  String? _access;
  String? _refresh;

  _InMemoryTokenStorage() : super(const FlutterSecureStorage());

  @override
  Future<void> saveAccessToken(String token) async => _access = token;

  @override
  Future<void> saveRefreshToken(String token) async => _refresh = token;

  @override
  Future<String?> getAccessToken() async => _access;

  @override
  Future<String?> getRefreshToken() async => _refresh;

  @override
  Future<void> clearTokens() async {
    _access = null;
    _refresh = null;
  }

  @override
  Future<void> deleteAll() async => clearTokens();
}

class _FakeRealtimeService implements RealtimeService {
  int disconnectCalls = 0;

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {
    disconnectCalls++;
  }

  @override
  Stream<RealtimeEvent<T>> subscribe<T>({
    required String channel,
    required T Function(Map<String, dynamic> json) mapper,
  }) => const Stream.empty();

  @override
  Future<void> unsubscribe(String channel) async {}
}

class _RecordedRequest {
  final String method;
  final Uri uri;
  final Map<String, dynamic> headers;
  final Map<String, dynamic>? jsonBody;

  _RecordedRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.jsonBody,
  });
}

typedef _StubHandler = ResponseBody Function(
  RequestOptions options,
  Map<String, dynamic>? body,
);

class _MockHttpAdapter implements HttpClientAdapter {
  final List<_RecordedRequest> requests = [];
  _StubHandler handler;

  _MockHttpAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Map<String, dynamic>? decodedBody;
    if (requestStream != null) {
      final bytes = <int>[];
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
      if (bytes.isNotEmpty) {
        final raw = utf8.decode(bytes);
        final parsed = jsonDecode(raw);
        if (parsed is Map<String, dynamic>) {
          decodedBody = parsed;
        }
      }
    }
    requests.add(
      _RecordedRequest(
        method: options.method,
        uri: options.uri,
        headers: Map<String, dynamic>.from(options.headers),
        jsonBody: decodedBody,
      ),
    );
    return handler(options, decodedBody);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(int statusCode, Object payload) {
  final str = payload is String ? payload : jsonEncode(payload);
  return ResponseBody.fromString(
    str,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [
        payload is String
            ? Headers.textPlainContentType
            : Headers.jsonContentType,
      ],
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const stagingBaseUrl =
      'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/';

  late _InMemoryTokenStorage tokenStorage;
  late _FakeRealtimeService realtimeService;
  late SharedPreferencesHelper prefsHelper;
  late Dio dio;
  late _MockHttpAdapter adapter;
  late LoginCubit loginCubit;
  late ActiveAccountCubit activeAccountCubit;

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    ApiEndpoint.debugTestBaseUrl = stagingBaseUrl;

    tokenStorage = _InMemoryTokenStorage();
    realtimeService = _FakeRealtimeService();
    prefsHelper = SharedPreferencesHelper(Logger(level: Level.off));
    await prefsHelper.init();

    getIt.registerSingleton<TokenStorageService>(tokenStorage);
    getIt.registerSingleton<RealtimeService>(realtimeService);
    getIt.registerSingleton<SharedPreferencesHelper>(prefsHelper);
    getIt.registerSingleton<UserTypeStrategy>(
      BranchManagerUserStrategy(),
      instanceName: UserType.branchManager.value,
    );
    getIt.registerSingleton<UserTypeStrategy>(
      CashierUserStrategy(),
      instanceName: UserType.cashier.value,
    );
    getIt.registerSingleton<UserTypeStrategy>(
      SupplierUserStrategy(),
      instanceName: UserType.supplier.value,
    );
    getIt.registerSingleton<UserTypeStrategy>(
      BrandOwnerUserStrategy(),
      instanceName: UserType.brandOwner.value,
    );

    dio = DioClient.create(customBaseUrl: stagingBaseUrl);
    adapter = _MockHttpAdapter(
      (_, _) => _jsonResponse(200, {'success': true, 'message': 'OK'}),
    );
    dio.httpClientAdapter = adapter;
    getIt.registerSingleton<Dio>(dio);

    final loginDs = LoginRemoteDataSource(dio);
    final loginRepo = LoginRepositoryImpl(loginDs);
    loginCubit = LoginCubit(
      BranchManagerLoginUseCase(loginRepo),
      SupplierLoginUseCase(loginRepo),
      CashierLoginUseCase(loginRepo),
      BrandOwnerLoginUseCase(loginRepo),
    );

    final activeDs = ActiveAccountRemoteDataSource(dio);
    final activeRepo = ActiveAccountRepositoryImpl(activeDs);
    activeAccountCubit = ActiveAccountCubit(
      FirstLoginUseCase(activeRepo),
      ResetPasswordFirstLoginUseCase(activeRepo),
    );

    UserTypeService.clearUserType();
    await AuthService.isLoggedIn();
  });

  tearDown(() async {
    await loginCubit.close();
    await activeAccountCubit.close();
    ApiEndpoint.debugTestBaseUrl = null;
    await getIt.reset();
  });

  group('Multi-role Login API Contract Tests (Local Mocked HTTP)', () {
    final roleSpecs = <({
      String label,
      UserType userType,
      String expectedPath,
      String email,
      Future<void> Function(LoginCubit, String, String) invoke,
    })>[
      (
        label: 'Branch Manager',
        userType: UserType.branchManager,
        expectedPath: '/api/v1/branch-manager/auth/login',
        email: 'assab-ui-qa-20261018.branch-manager@fixture.invalid',
        invoke: (c, id, pw) => c.branchManagerLogin(identifier: id, password: pw),
      ),
      (
        label: 'Cashier',
        userType: UserType.cashier,
        expectedPath: '/api/v1/cashier/auth/login',
        email: 'assab-ui-qa-20261018.cashier@fixture.invalid',
        invoke: (c, id, pw) => c.cashierLogin(identifier: id, password: pw),
      ),
      (
        label: 'Supplier',
        userType: UserType.supplier,
        expectedPath: '/api/v1/supplier/auth/login',
        email: 'supplier.staging@fixture.invalid',
        invoke: (c, id, pw) => c.supplierLogin(identifier: id, password: pw),
      ),
      (
        label: 'Brand Owner',
        userType: UserType.brandOwner,
        expectedPath: '/api/v1/brand-owner/auth/login',
        email: 'brand-owner.staging@fixture.invalid',
        invoke: (c, id, pw) => c.brandOwnerLogin(identifier: id, password: pw),
      ),
    ];

    for (final spec in roleSpecs) {
      test(
        '${spec.label}: sends POST ${spec.expectedPath} with {identifier, password} and parses Laravel response envelope',
        () async {
          adapter.handler = (options, body) {
            return _jsonResponse(200, {
              'success': true,
              'message': '${spec.label} logged in successfully',
              'data': {
                'token': '101|sanctum-${spec.userType.value}-token',
                'user': {
                  'id': 42,
                  'name': '${spec.label} Staging User',
                  'email': spec.userType == UserType.cashier ? null : spec.email,
                  'phone': '+966501234567',
                  'image': null,
                  'created_at': null,
                },
              },
            });
          };

          await spec.invoke(loginCubit, spec.email, 'harness-pass_2026-ok');

          expect(adapter.requests, hasLength(1));
          final req = adapter.requests.single;
          expect(req.method, equals('POST'));
          expect(req.uri.path, equals(spec.expectedPath));
          expect(
            req.uri.host,
            equals('szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io'),
          );
          expect(
            req.jsonBody,
            equals({
              'identifier': spec.email,
              'password': 'harness-pass_2026-ok',
            }),
          );

          expect(loginCubit.state, isA<LoginSuccess>());
          final entity = (loginCubit.state as LoginSuccess).entity;
          expect(entity.id, equals('42'));
          expect(entity.name, equals('${spec.label} Staging User'));
          expect(
            entity.token,
            equals('101|sanctum-${spec.userType.value}-token'),
          );
          if (spec.userType == UserType.cashier) {
            expect(entity.email, isEmpty);
          } else {
            expect(entity.email, equals(spec.email));
          }
        },
      );
    }
  });

  group('First-Login & Activation Contract Tests (All 4 Mobile Roles)', () {
    test(
      'Cashier first-login hits cashier/auth/first-login and parses requires_password_reset',
      () async {
        adapter.handler = (options, body) {
          return _jsonResponse(200, {
            'success': true,
            'message': 'First login verified',
            'data': {
              'token': '202|cashier-first-login-token',
              'requires_password_reset': false,
              'user': {
                'id': '77',
                'name': 'Staging Cashier',
                'email': 'assab-ui-qa-20261018.cashier@fixture.invalid',
              },
            },
          });
        };

        await activeAccountCubit.cashierFirstLogin(
          email: 'assab-ui-qa-20261018.cashier@fixture.invalid',
          password: 'temp-default-password',
        );

        expect(
          adapter.requests.single.uri.path,
          equals('/api/v1/cashier/auth/first-login'),
        );
        expect(activeAccountCubit.state, isA<ActiveAccountSuccess>());
        final state = activeAccountCubit.state as ActiveAccountSuccess;
        expect(
          state.firstLoginResponseModel.data.requiresPasswordReset,
          isFalse,
        );
        expect(
          state.firstLoginResponseModel.data.token,
          equals('202|cashier-first-login-token'),
        );
      },
    );

    test(
      'Cashier reset-password-first-login hits cashier/auth/reset-password-first-login',
      () async {
        await tokenStorage.saveAccessToken('202|cashier-first-login-token');
        adapter.handler = (options, body) {
          return _jsonResponse(200, {
            'success': true,
            'message': 'Password reset completed',
          });
        };

        await activeAccountCubit.cashierResetPasswordFirstLogin(
          password: 'NewPassword_2026!',
          passwordConfirmation: 'NewPassword_2026!',
        );

        final req = adapter.requests.single;
        expect(
          req.uri.path,
          equals('/api/v1/cashier/auth/reset-password-first-login'),
        );
        expect(
          req.headers['Authorization'],
          equals('Bearer 202|cashier-first-login-token'),
        );
        expect(
          activeAccountCubit.state,
          isA<ResetPasswordActiveAccountSuccess>(),
        );
      },
    );
  });

  group('Login Form & Identifier Validation Tests', () {
    test(
      'Accepts synthetic .invalid harness emails, hyphenated domains, and 9-digit local phones',
      () {
        expect(
          AppRegExp.emailValidator(
            'assab-ui-qa-20261018.branch-manager@fixture.invalid',
          ),
          isTrue,
        );
        expect(
          AppRegExp.emailValidator(
            'assab-ui-qa-20261018.cashier@fixture.invalid',
          ),
          isTrue,
        );
        expect(AppRegExp.emailValidator('ops@assab-erp.staging.io'), isTrue);
        expect(AppRegExp.phoneValidator('501234567'), isTrue);
        expect(AppRegExp.emailValidator('not-an-email'), isFalse);
      },
    );

    test(
      'LoginFormCubit enables submit for valid staging email and any non-empty backend password',
      () {
        final formCubit = LoginFormCubit();
        formCubit.updateIdentifier(
          '  assab-ui-qa-20261018.branch-manager@fixture.invalid  ',
        );
        expect(formCubit.state.isIdentifierValid, isTrue);
        expect(formCubit.state.isFormValid, isFalse);

        formCubit.updatePassword('assab-harness_password-2026');
        expect(formCubit.state.isPasswordValid, isTrue);
        expect(formCubit.state.isFormValid, isTrue);

        formCubit.updatePassword('');
        expect(formCubit.state.isFormValid, isFalse);
        formCubit.close();
      },
    );
  });

  group('Login Error, Guard Separation, Session Expiry & Logout Tests', () {
    test(
      '401 Invalid credentials maps to AuthFailure without triggering session-expiry wipe',
      () async {
        await tokenStorage.saveAccessToken('preexisting-token');
        adapter.handler = (_, _) => _jsonResponse(401, {
          'success': false,
          'message': 'Invalid credentials',
        });

        await loginCubit.branchManagerLogin(
          identifier: 'assab-ui-qa-20261018.branch-manager@fixture.invalid',
          password: 'wrong-password',
        );

        expect(loginCubit.state, isA<LoginFailure>());
        final failure = (loginCubit.state as LoginFailure).failure;
        expect(failure, isA<AuthFailure>());
        expect(failure.statusCode, equals(401));
        expect(failure.error.message, equals('Invalid credentials'));
        expect(await tokenStorage.getAccessToken(), equals('preexisting-token'));
      },
    );

    test(
      '403 First login required or inactive account maps to AuthFailure (statusCode 403)',
      () async {
        adapter.handler = (_, _) => _jsonResponse(403, {
          'success': false,
          'message': 'First login required. Please use first-login endpoint.',
        });

        await loginCubit.cashierLogin(
          identifier: 'assab-ui-qa-20261018.cashier@fixture.invalid',
          password: 'temp-password',
        );

        expect(loginCubit.state, isA<LoginFailure>());
        final failure = (loginCubit.state as LoginFailure).failure;
        expect(failure, isA<AuthFailure>());
        expect(failure.statusCode, equals(403));
        expect(failure.error.message, contains('First login required'));
      },
    );

    test(
      'Supplier HTTP 500 Invalid credentials maps cleanly to AuthFailure instead of generic server crash',
      () async {
        adapter.handler = (_, _) => _jsonResponse(500, {
          'success': false,
          'message': 'Invalid credentials',
        });

        await loginCubit.supplierLogin(
          identifier: 'supplier@fixture.invalid',
          password: 'wrong-password',
        );

        expect(loginCubit.state, isA<LoginFailure>());
        final failure = (loginCubit.state as LoginFailure).failure;
        expect(failure, isA<AuthFailure>());
        expect(failure.error.message, equals('Invalid credentials'));
      },
    );

    test(
      'Non-JSON 502 gateway response maps cleanly to ServerFailure without TypeError',
      () async {
        adapter.handler = (_, _) => _jsonResponse(502, 'Bad Gateway');

        await loginCubit.brandOwnerLogin(
          identifier: 'owner@fixture.invalid',
          password: 'secret',
        );

        expect(loginCubit.state, isA<LoginFailure>());
        final failure = (loginCubit.state as LoginFailure).failure;
        expect(failure, isA<ServerFailure>());
      },
    );

    test(
      '403 on cross-guard business endpoint preserves session while 401 on business endpoint clears session locally',
      () async {
        await tokenStorage.saveAccessToken('valid-cashier-token');
        await prefsHelper.storeString('u_name', 'Staging Cashier');
        await UserTypeService.saveSelectedUserType(UserType.cashier);
        AuthService.markLoggedIn();

        adapter.handler = (_, _) => _jsonResponse(403, {
          'success': false,
          'message': 'Unauthorized. Cashier access required.',
        });
        await expectLater(
          dio.get('branch-manager/expenses'),
          throwsA(isA<DioException>()),
        );
        expect(AuthService.isLoggedInVal, isTrue);
        expect(
          await tokenStorage.getAccessToken(),
          equals('valid-cashier-token'),
        );

        adapter.requests.clear();
        adapter.handler = (_, _) => _jsonResponse(401, {
          'message': 'Unauthenticated.',
        });
        await expectLater(
          dio.get('cashier/my-info'),
          throwsA(isA<DioException>()),
        );

        expect(AuthService.isLoggedInVal, isFalse);
        expect(await tokenStorage.getAccessToken(), isNull);
        expect(UserTypeService.getSavedUserType(), isNull);
        expect(prefsHelper.getString('u_name'), isNull);
        expect(
          adapter.requests.map((r) => r.uri.path).toList(),
          equals(['/api/v1/cashier/my-info']),
        );
      },
    );

    test(
      'AuthService.logout revokes token on each role exact backend logout route and clears session',
      () async {
        final expectedLogoutPaths = <UserType, String>{
          UserType.branchManager: '/api/v1/branch-manager/auth/logout',
          UserType.cashier: '/api/v1/cashier/logout',
          UserType.supplier: '/api/v1/supplier/auth/logout',
          UserType.brandOwner: '/api/v1/brand-owner/auth/logout',
        };

        for (final entry in expectedLogoutPaths.entries) {
          adapter.requests.clear();
          await tokenStorage.saveAccessToken('tok-${entry.key.value}');
          await prefsHelper.storeString('u_name', 'User ${entry.key.value}');
          await prefsHelper.storeString('u_id', '99');
          UserTypeService.setUserType(
            strategy: UserTypeService.strategyFor(entry.key),
            userType: entry.key,
          );
          await UserTypeService.saveSelectedUserType(entry.key);
          AuthService.markLoggedIn();

          await AuthService.logout();

          expect(adapter.requests, hasLength(1));
          expect(adapter.requests.single.method, equals('POST'));
          expect(adapter.requests.single.uri.path, equals(entry.value));
          expect(
            adapter.requests.single.headers['Authorization'],
            equals('Bearer tok-${entry.key.value}'),
          );
          expect(AuthService.isLoggedInVal, isFalse);
          expect(await tokenStorage.getAccessToken(), isNull);
          expect(UserTypeService.getSavedUserType(), isNull);
          expect(UserTypeService.selectedUserType, isNull);
          expect(prefsHelper.getString('u_name'), isNull);
        }
      },
    );
  });
}
