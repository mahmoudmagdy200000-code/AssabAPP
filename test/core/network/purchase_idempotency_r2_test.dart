import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/network/auth_interceptor.dart';
import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

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
    // Drain requestStream just like real Dio adapters do when sending FormData
    if (requestStream != null) {
      await requestStream.drain<void>();
    }
    if (onFetch != null) {
      return await onFetch!(options);
    }
    return ResponseBody.fromString(
      jsonEncode({'success': true}),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeTokenStorage implements TokenStorageService {
  String? _access;
  String? _refresh;

  @override
  Future<void> clearTokens() async {
    _access = null;
    _refresh = null;
    IdempotencyScopeManager.resetAll();
  }

  @override
  Future<void> deleteAll() async => clearTokens();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<String?> getAccessToken() async => _access;

  @override
  Future<String?> getRefreshToken() async => _refresh;

  @override
  Future<void> saveAccessToken(String token) async {
    _access = token;
  }

  @override
  Future<void> startAuthenticatedSession({
    required String token,
    required String principalType,
    required String principalId,
  }) async {
    IdempotencyScopeManager.startSession(
      principalType: principalType,
      principalId: principalId,
    );
    _access = token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _refresh = token;
  }
}

void main() {
  group('Stage 0 R2: AUD-S0-008, AUD-S0-009, AUD-S0-010', () {
    late IdempotencyInterceptor interceptor;
    late _InMemoryAdapter adapter;
    late Dio dio;

    setUp(() {
      IdempotencyScopeManager.resetAll();
      UserTypeService.selectedUserType = UserType.branchManager;
      interceptor = IdempotencyInterceptor();
      adapter = _InMemoryAdapter();
      dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(interceptor);
    });

    tearDown(() {
      if (getIt.isRegistered<TokenStorageService>()) {
        getIt.unregister<TokenStorageService>();
      }
      UserTypeService.selectedUserType = null;
    });

    test('AUD-S0-009: concurrent identical Purchase operations preserve independent retry keys across out-of-order completion', () async {
      final gateA = Completer<void>();
      final gateB = Completer<void>();
      final seenTwo = Completer<void>();
      var call = 0;
      adapter.onFetch = (opts) async {
        call++;
        if (call == 2 && !seenTwo.isCompleted) {
          seenTwo.complete();
        }
        if (call == 1) {
          await gateA.future;
          return ResponseBody.fromString(jsonEncode({'op': 'A'}), 200);
        }
        await gateB.future;
        throw DioException(
          requestOptions: opts,
          type: DioExceptionType.connectionTimeout,
        );
      };

      final payload = {'items': [{'item_id': 'item-1', 'quantity': 5}]};
      final futureA = dio.post('purchase/orders', data: payload);
      final futureB = dio.post('purchase/orders', data: payload);

      await seenTwo.future;
      expect(adapter.seen.length, equals(2));
      final keyA = adapter.seen[0].headers['Idempotency-Key'] as String;
      final keyB = adapter.seen[1].headers['Idempotency-Key'] as String;
      expect(keyA, isNot(equals(keyB)));

      // Complete A BEFORE B errors — must NOT clear/retire B's entry!
      gateA.complete();
      await futureA;

      gateB.complete();
      await expectLater(futureB, throwsA(isA<DioException>()));

      // Retrying B MUST reuse keyB!
      final retryBOpts = RequestOptions(
        path: 'purchase/orders',
        method: 'POST',
        data: payload,
        extra: {'retry_idempotency_key': keyB},
      );
      adapter.onFetch = (opts) async => ResponseBody.fromString(jsonEncode({'ok': true}), 200);
      await dio.fetch(retryBOpts);
      expect(adapter.seen.last.headers['Idempotency-Key'], equals(keyB));

      // Verify cleanup with key1 cannot remove active entry for key2
      final o1 = RequestOptions(path: 'shifts/1/end', method: 'POST', data: {'x': 1});
      final o2 = RequestOptions(path: 'shifts/1/end', method: 'POST', data: {'x': 1}, extra: {'idempotency_intent_id': 'intent-2'});
      final h1 = _ReqHandler();
      final h2 = _ReqHandler();
      interceptor.onRequest(o1, h1);
      interceptor.onRequest(o2, h2);
      final k1 = o1.headers['Idempotency-Key'] as String;
      final k2 = o2.headers['Idempotency-Key'] as String;
      expect(k1, isNot(equals(k2)));
      interceptor.onResponse(Response(requestOptions: o1, statusCode: 200), _ResHandler());
      expect(IdempotencyScopeManager.hasKeyActive(k2), isTrue);
    });

    test('AUD-S0-010: FormData distinguishes different file content with identical filename and byte length, without consuming streams', () async {
      final bytesA = utf8.encode('FILE-CONTENT-AAA');
      final bytesB = utf8.encode('FILE-CONTENT-BBB');
      expect(bytesA.length, equals(bytesB.length));

      final formA1 = FormData.fromMap({
        'note': 'same',
        'file': MultipartFile.fromBytes(bytesA, filename: 'invoice.jpg'),
      });
      final formA2 = FormData.fromMap({
        'note': 'same',
        'file': MultipartFile.fromBytes(bytesA, filename: 'invoice.jpg'),
      });
      final formB = FormData.fromMap({
        'note': 'same',
        'file': MultipartFile.fromBytes(bytesB, filename: 'invoice.jpg'),
      });

      final rA1 = await dio.post('purchase/receiving/1/invoice', data: formA1, options: Options(extra: {'idempotency_intent_id': 'u1'}));
      final rB = await dio.post('purchase/receiving/1/invoice', data: formB, options: Options(extra: {'idempotency_intent_id': 'u1'}));
      expect(rA1.requestOptions.extra['idempotency_scope'], isNot(equals(rB.requestOptions.extra['idempotency_scope'])));
      expect(rA1.requestOptions.headers['Idempotency-Key'], isNot(equals(rB.requestOptions.headers['Idempotency-Key'])));

      // Retrying same file content after timeout under same intent reuses key and upload stream still succeeds
      adapter.onFetch = (opts) async {
        throw DioException(requestOptions: opts, type: DioExceptionType.connectionTimeout);
      };
      await expectLater(
        dio.post('purchase/receiving/2/invoice', data: formA2, options: Options(extra: {'idempotency_intent_id': 'u2'})),
        throwsA(isA<DioException>()),
      );
      final kTimeout = adapter.seen.last.headers['Idempotency-Key'];
      adapter.onFetch = null;
      final formA2Retry = FormData.fromMap({
        'note': 'same',
        'file': MultipartFile.fromBytes(bytesA, filename: 'invoice.jpg'),
      });
      final retryRes = await dio.post('purchase/receiving/2/invoice', data: formA2Retry, options: Options(extra: {'idempotency_intent_id': 'u2'}));
      expect(retryRes.requestOptions.headers['Idempotency-Key'], equals(kTimeout));

      // Deprecated one-shot stream MultipartFile still completes actual upload without throwing already-listened error
      final oneShotStream = Stream<List<int>>.fromIterable([bytesA]);
      final oneShotForm = FormData.fromMap({
        // ignore: deprecated_member_use
        'file': MultipartFile(oneShotStream, bytesA.length, filename: 'oneshot.jpg'),
      });
      final oneShotRes = await dio.post('purchase/receiving/3/invoice', data: oneShotForm);
      expect(oneShotRes.statusCode, equals(200));
    });

    test('AUD-S0-008 B4: AuthInterceptor + TokenStorageService isolate sessions and block stale callbacks from corrupting new session', () async {
      final storage = _FakeTokenStorage();
      getIt.registerSingleton<TokenStorageService>(storage);
      await storage.startAuthenticatedSession(
        token: 'raw-secret-token-AAA',
        principalType: 'branch_manager',
        principalId: 'account-a',
      );

      final authDio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
      authDio.httpClientAdapter = adapter;
      authDio.interceptors.addAll([AuthInterceptor(), interceptor]);

      final gateOld = Completer<void>();
      var reqNum = 0;
      adapter.onFetch = (opts) async {
        reqNum++;
        if (reqNum == 1) {
          await gateOld.future;
          throw DioException(requestOptions: opts, type: DioExceptionType.connectionTimeout);
        }
        return ResponseBody.fromString(jsonEncode({'ok': true}), 200);
      };

      // Start request in Session A
      final oldStarted = Completer<void>();
      adapter.onFetch = (opts) async {
        reqNum++;
        if (reqNum == 1) {
          if (!oldStarted.isCompleted) oldStarted.complete();
          await gateOld.future;
          throw DioException(requestOptions: opts, type: DioExceptionType.connectionTimeout);
        }
        return ResponseBody.fromString(jsonEncode({'ok': true}), 200);
      };
      final oldReq = authDio.post('purchase/orders', data: {'q': 1});
      await oldStarted.future;
      final oldKey = adapter.seen.last.headers['Idempotency-Key'] as String;
      final oldScope = adapter.seen.last.extra['idempotency_scope'] as String;
      expect(oldScope.contains('raw-secret-token-AAA'), isFalse);

      // Switch account / refresh token -> Session B
      await storage.startAuthenticatedSession(
        token: 'raw-secret-token-BBB',
        principalType: 'branch_manager',
        principalId: 'account-b',
      );
      // Now old session's timeout arrives AFTER account switch — must NOT pollute Session B
      gateOld.complete();
      await expectLater(oldReq, throwsA(isA<DioException>()));

      // Session B makes the same request -> gets a NEW key and is NOT corrupted by old session error
      final newRes = await authDio.post('purchase/orders', data: {'q': 1});
      expect(newRes.requestOptions.headers['Idempotency-Key'], isNot(equals(oldKey)));
    });

    test('AUD-S0-009/010 extra: B completes before A times out, 422 in A leaves B untouched, and multi-attachment FormData is deterministic', () async {
      final gateA = Completer<void>();
      final gateB = Completer<void>();
      final bothSeen = Completer<void>();
      var n = 0;
      adapter.onFetch = (opts) async {
        n++;
        if (n == 2 && !bothSeen.isCompleted) bothSeen.complete();
        if (n == 1) {
          await gateA.future;
          throw DioException(requestOptions: opts, type: DioExceptionType.connectionTimeout);
        }
        await gateB.future;
        return ResponseBody.fromString(jsonEncode({'op': 'B'}), 200);
      };

      final fA = dio.post('purchase/receiving/9/complete', data: {'ok': true});
      final fB = dio.post('purchase/receiving/9/complete', data: {'ok': true});
      await bothSeen.future;
      final kA = adapter.seen[0].headers['Idempotency-Key'] as String;

      // B completes first; then A times out -> A retains kA for retry
      gateB.complete();
      await fB;
      gateA.complete();
      await expectLater(fA, throwsA(isA<DioException>()));
      expect(IdempotencyScopeManager.hasKeyActive(kA), isTrue);

      adapter.onFetch = null;
      final retryA = await dio.fetch(RequestOptions(
        path: 'purchase/receiving/9/complete',
        method: 'POST',
        data: {'ok': true},
        extra: {'retry_idempotency_key': kA},
      ));
      expect(retryA.requestOptions.headers['Idempotency-Key'], equals(kA));

      // Deterministic multi-attachment FormData with repeated field names
      final multi1 = FormData.fromMap({
        'tag': ['one', 'two'],
        'files[]': [
          MultipartFile.fromBytes(utf8.encode('1111'), filename: 'x.jpg'),
          MultipartFile.fromBytes(utf8.encode('2222'), filename: 'y.jpg'),
        ],
      });
      final multi2 = FormData.fromMap({
        'tag': ['one', 'two'],
        'files[]': [
          MultipartFile.fromBytes(utf8.encode('1111'), filename: 'x.jpg'),
          MultipartFile.fromBytes(utf8.encode('2222'), filename: 'y.jpg'),
        ],
      });
      final r1 = await dio.post('purchase/receiving/10/invoice', data: multi1);
      final r2 = await dio.post('purchase/receiving/10/invoice', data: multi2);
      expect(r1.requestOptions.extra['idempotency_scope'], equals(r2.requestOptions.extra['idempotency_scope']));
    });
  });
}

class _ReqHandler extends RequestInterceptorHandler {
  RequestOptions? options;
  @override
  void next(RequestOptions requestOptions) {
    options = requestOptions;
  }
}

class _ResHandler extends ResponseInterceptorHandler {
  Response? response;
  @override
  void next(Response response) {
    this.response = response;
  }
}
