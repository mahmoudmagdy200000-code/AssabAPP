import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/network/auth_interceptor.dart';
import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values[key];

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.clear();
  }
}

class _InMemoryAdapter implements HttpClientAdapter {
  Future<ResponseBody> Function(RequestOptions options)? onFetch;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    if (requestStream != null) await requestStream.drain<void>();
    final response = onFetch?.call(options) ?? Future.value(
      ResponseBody.fromString(jsonEncode({'ok': true}), 200),
    );
    if (cancelFuture == null) return response;
    return Future.any([
      response,
      cancelFuture.then<ResponseBody>((_) => throw DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
          )),
    ]);
  }

  @override
  void close({bool force = false}) {}
}

class _IntentOwnerHarness with UserIntentOwner {
  Future<T?> submit<T>(Future<T> Function() operation) =>
      runUserIntent<T>('same-financial-action', operation);
}

Future<ResponseBody> _timeout(RequestOptions options) async {
  throw DioException(
    requestOptions: options,
    type: DioExceptionType.connectionTimeout,
  );
}

void main() {
  group('Stage 0 focused session lifecycle R3', () {
    late _InMemoryAdapter adapter;
    late Dio dio;

    setUp(() {
      IdempotencyScopeManager.resetAll();
      UserTypeService.selectedUserType = UserType.branchManager;
      if (getIt.isRegistered<TokenStorageService>()) {
        getIt.unregister<TokenStorageService>();
      }
      adapter = _InMemoryAdapter();
      dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(IdempotencyInterceptor());
    });

    tearDown(() {
      if (getIt.isRegistered<TokenStorageService>()) {
        getIt.unregister<TokenStorageService>();
      }
      UserTypeService.selectedUserType = null;
      IdempotencyScopeManager.resetAll();
    });

    test('A: timeout then same-session access-token rotation retains retry key', () async {
      final secure = _MemorySecureStorage();
      final storage = TokenStorageService(secure);
      await storage.startAuthenticatedSession(
        token: 'credential-a', principalType: 'branch_manager', principalId: 'acct-a',
      );
      getIt.registerSingleton<TokenStorageService>(storage);
      final authenticatedDio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
      authenticatedDio.httpClientAdapter = adapter;
      authenticatedDio.interceptors.addAll([AuthInterceptor(), IdempotencyInterceptor()]);
      adapter.onFetch = _timeout;
      await expectLater(authenticatedDio.post('purchase/orders', data: {'x': 1}), throwsA(isA<DioException>()));
      final originalKey = adapter.seen.single.headers['Idempotency-Key'];

      await storage.saveAccessToken('rotated-credential-a');
      adapter.onFetch = null;
      final result = await authenticatedDio.fetch(RequestOptions(
        path: 'purchase/orders', method: 'POST', data: {'x': 1},
        extra: {'retry_idempotency_key': originalKey},
      ));
      expect(result.requestOptions.headers['Idempotency-Key'], originalKey);
    });

    test('B: explicit account switch isolates previous retry identities', () async {
      final storage = TokenStorageService(_MemorySecureStorage());
      await storage.startAuthenticatedSession(
        token: 'credential-a', principalType: 'branch_manager', principalId: 'acct-a',
      );
      adapter.onFetch = _timeout;
      await expectLater(dio.post('purchase/orders', data: {'x': 1}), throwsA(isA<DioException>()));
      final oldKey = adapter.seen.single.headers['Idempotency-Key'];
      await storage.startAuthenticatedSession(
        token: 'credential-b', principalType: 'branch_manager', principalId: 'acct-b',
      );

      adapter.onFetch = null;
      await dio.post('purchase/orders', data: {'x': 1});
      expect(adapter.seen.last.headers['Idempotency-Key'], isNot(oldKey));
      expect(IdempotencyScopeManager.hasKeyActive(oldKey as String), isFalse);
    });

    test('C: production AuthService.logout clears credentials and invalidates session', () async {
      final secure = _MemorySecureStorage();
      final storage = TokenStorageService(secure);
      getIt.registerSingleton<TokenStorageService>(storage);
      await storage.startAuthenticatedSession(
        token: 'credential-a', principalType: 'branch_manager', principalId: 'acct-a',
      );
      adapter.onFetch = _timeout;
      await expectLater(dio.post('purchase/orders', data: {'x': 1}), throwsA(isA<DioException>()));
      final oldKey = adapter.seen.single.headers['Idempotency-Key'] as String;
      final epochBeforeLogout = IdempotencyScopeManager.sessionEpoch;

      await AuthService.logout(revokeRemote: false);

      expect(await storage.getAccessToken(), isNull);
      expect(IdempotencyScopeManager.sessionEpoch, greaterThan(epochBeforeLogout));
      expect(IdempotencyScopeManager.hasKeyActive(oldKey), isFalse);
    });

    test('D: logout and same-account login create a new boundary that fences old callbacks', () async {
      final secure = _MemorySecureStorage();
      final storage = TokenStorageService(secure);
      getIt.registerSingleton<TokenStorageService>(storage);
      await storage.startAuthenticatedSession(
        token: 'credential-a1', principalType: 'branch_manager', principalId: 'acct-a',
      );
      final gateOld = Completer<void>();
      final gateNew = Completer<void>();
      final oldStarted = Completer<void>();
      final newStarted = Completer<void>();
      var call = 0;
      adapter.onFetch = (options) async {
        call++;
        if (call == 1) {
          oldStarted.complete();
          await gateOld.future;
          return ResponseBody.fromString('{"ok":true}', 200);
        }
        if (call == 2) {
          newStarted.complete();
          await gateNew.future;
          return _timeout(options);
        }
        return ResponseBody.fromString('{"ok":true}', 200);
      };
      final oldRequest = dio.post('purchase/orders', data: {'x': 1});
      await oldStarted.future;
      final oldKey = adapter.seen.single.headers['Idempotency-Key'] as String;

      await AuthService.logout(revokeRemote: false);
      await storage.startAuthenticatedSession(
        token: 'credential-a2', principalType: 'branch_manager', principalId: 'acct-a',
      );
      final newRequest = dio.post('purchase/orders', data: {'x': 1});
      await newStarted.future;
      final newKey = adapter.seen.last.headers['Idempotency-Key'] as String;
      expect(newKey, isNot(oldKey));
      gateOld.complete();
      await oldRequest;
      expect(IdempotencyScopeManager.hasKeyActive(newKey), isTrue);
      gateNew.complete();
      await expectLater(newRequest, throwsA(isA<DioException>()));
      adapter.onFetch = null;
      final retry = await dio.fetch(RequestOptions(
        path: 'purchase/orders', method: 'POST', data: {'x': 1},
        extra: {'retry_idempotency_key': newKey},
      ));
      expect(retry.requestOptions.headers['Idempotency-Key'], newKey);
    });

    test('E: cancellation of A does not clear B with the same payload', () async {
      final bothStarted = Completer<void>();
      final gateB = Completer<void>();
      var call = 0;
      adapter.onFetch = (options) async {
        call++;
        if (call == 2 && !bothStarted.isCompleted) bothStarted.complete();
        if (call == 1) return Completer<ResponseBody>().future;
        await gateB.future;
        return _timeout(options);
      };
      final cancelA = CancelToken();
      final a = dio.post('purchase/orders', data: {'x': 1}, cancelToken: cancelA);
      final b = dio.post('purchase/orders', data: {'x': 1});
      await bothStarted.future;
      final keyA = adapter.seen[0].headers['Idempotency-Key'] as String;
      final keyB = adapter.seen[1].headers['Idempotency-Key'] as String;
      cancelA.cancel('cancel A');
      await expectLater(a, throwsA(isA<DioException>()));
      gateB.complete();
      await expectLater(b, throwsA(isA<DioException>()));

      adapter.onFetch = null;
      final retry = await dio.fetch(RequestOptions(
        path: 'purchase/orders', method: 'POST', data: {'x': 1},
        extra: {'retry_idempotency_key': keyB},
      ));
      expect(retry.requestOptions.headers['Idempotency-Key'], keyB);
      expect(IdempotencyScopeManager.hasKeyActive(keyA), isFalse);
    });

    test('F: multiple unresolved intents retain independent keys through token rotation', () async {
      final secure = _MemorySecureStorage();
      final storage = TokenStorageService(secure);
      await storage.startAuthenticatedSession(
        token: 'credential-a', principalType: 'branch_manager', principalId: 'acct-a',
      );
      final gates = [Completer<void>(), Completer<void>()];
      final bothStarted = Completer<void>();
      var call = 0;
      adapter.onFetch = (options) async {
        final index = call++;
        if (call == 2) bothStarted.complete();
        await gates[index].future;
        return _timeout(options);
      };
      final first = dio.post('purchase/orders', data: {'x': 1});
      final second = dio.post('purchase/orders', data: {'x': 1});
      await bothStarted.future;
      final keys = adapter.seen.map((o) => o.headers['Idempotency-Key']).toList();
      expect(keys[0], isNot(keys[1]));
      gates[0].complete();
      gates[1].complete();
      await Future.wait([
        expectLater(first, throwsA(isA<DioException>())),
        expectLater(second, throwsA(isA<DioException>())),
      ]);
      await storage.saveAccessToken('rotated-credential-a');

      adapter.onFetch = null;
      for (final key in keys) {
        final retry = await dio.fetch(RequestOptions(
          path: 'purchase/orders', method: 'POST', data: {'x': 1},
          extra: {'retry_idempotency_key': key},
        ));
        expect(retry.requestOptions.headers['Idempotency-Key'], key);
      }
    });

    test('G: retry key from unknown session is rejected locally without minting a replacement', () async {
      final storage = TokenStorageService(_MemorySecureStorage());
      await storage.startAuthenticatedSession(
        token: 'credential-a', principalType: 'branch_manager', principalId: 'acct-a',
      );
      adapter.onFetch = _timeout;
      await expectLater(dio.post('purchase/orders', data: {'x': 1}), throwsA(isA<DioException>()));
      final oldKey = adapter.seen.single.headers['Idempotency-Key'] as String;
      await AuthService.logout(revokeRemote: false);

      adapter.onFetch = null;
      await expectLater(
        dio.fetch(RequestOptions(
          path: 'purchase/orders', method: 'POST', data: {'x': 1},
          extra: {'retry_idempotency_key': oldKey},
        )),
        throwsA(isA<DioException>()),
      );
      expect(adapter.seen.length, 1);
    });

    test('H: unresolved screen-owned intent stays blocked after session boundary', () async {
      final storage = TokenStorageService(_MemorySecureStorage());
      getIt.registerSingleton<TokenStorageService>(storage);
      await storage.startAuthenticatedSession(
        token: 'credential-a', principalType: 'branch_manager', principalId: 'acct-a',
      );
      final owner = _IntentOwnerHarness();
      adapter.onFetch = _timeout;
      await expectLater(
        owner.submit(() => dio.post('purchase/orders', data: {'x': 1})),
        throwsA(isA<DioException>()),
      );
      expect(owner.hasUnresolvedUserIntent, isTrue);

      await AuthService.logout(revokeRemote: false);
      expect(owner.hasUnresolvedUserIntent, isTrue);
      var sentAgain = false;
      final result = await owner.submit(() async {
        sentAgain = true;
        return 'sent';
      });
      expect(result, isNull);
      expect(sentAgain, isFalse);
    });
  });
}
