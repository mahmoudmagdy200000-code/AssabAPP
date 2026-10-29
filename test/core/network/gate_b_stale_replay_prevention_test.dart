import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory HTTP adapter simulating server behaviors (timeouts, 422 rejections, 200 OKs)
class _InMemoryHttpAdapter implements HttpClientAdapter {
  Future<ResponseBody> Function(RequestOptions options)? onFetch;

  _InMemoryHttpAdapter();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (onFetch != null) {
      return await onFetch!(options);
    }
    return ResponseBody.fromString(
      jsonEncode({'success': true, 'status': 'confirmed'}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Simulated client service that uses UserIntentOwner to manage financial command life cycle
class CashierHandoverSimulator with UserIntentOwner {
  final Dio dio;

  CashierHandoverSimulator(this.dio);

  Future<Response<dynamic>?> initiateHandover({
    required String shiftId,
    required double amount,
    String? note,
  }) async {
    final fingerprint =
        'handover:$shiftId:${amount.toStringAsFixed(2)}:${note ?? ''}';
    return await runUserIntent(fingerprint, () async {
      return await dio.post(
        'cashier/shifts/$shiftId/end-with-handover',
        data: {
          'handover_amount': amount.toStringAsFixed(2),
          'note': note ?? '',
        },
      );
    });
  }

  Future<Response<dynamic>?> initiateDifferentAction({
    required String shiftId,
    required double amount,
  }) async {
    final fingerprint =
        'different_action:$shiftId:${amount.toStringAsFixed(2)}';
    return await runUserIntent(fingerprint, () async {
      return await dio.post(
        'cashier/shifts/$shiftId/end-with-handover',
        data: {
          'handover_amount': amount.toStringAsFixed(2),
          'action': 'different',
        },
      );
    });
  }
}

void main() {
  group('GATE B: F-04 Stale Idempotency Replay Prevention & Intent Scoping', () {
    late Dio dio;
    late _InMemoryHttpAdapter adapter;
    late IdempotencyInterceptor interceptor;
    late CashierHandoverSimulator client;
    final List<String> capturedKeys = [];

    setUp(() {
      IdempotencyScopeManager.resetAll();
      UserTypeService.selectedUserType = UserType.cashier;
      capturedKeys.clear();

      dio = Dio(BaseOptions(baseUrl: 'https://api.assab.local/api/'));
      interceptor = IdempotencyInterceptor();
      dio.interceptors.add(interceptor);

      adapter = _InMemoryHttpAdapter();
      dio.httpClientAdapter = adapter;

      client = CashierHandoverSimulator(dio);
    });

    test(
        'Exact GATE B Reproduction & Verification: 7-step scenario for intent-owned idempotency and stale replay prevention',
        () async {
      // -----------------------------------------------------------------------
      // Step 1: Cashier initiates handover A for 100.00 SAR with intent key K1.
      // -----------------------------------------------------------------------
      String? keyK1;
      adapter.onFetch = (options) async {
        keyK1 = options.headers['Idempotency-Key'] as String?;
        capturedKeys.add(keyK1!);
        // Simulate network timeout on the first call (outcome unknown)
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timed out to backend during handover A',
        );
      };

      // Call handover A - this times out
      try {
        await client.initiateHandover(shiftId: 'shift_101', amount: 100.00);
        fail('Expected DioException on connection timeout');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.connectionTimeout));
      }

      // Verify K1 was generated as a valid RFC4122 v4 UUID
      expect(keyK1, isNotNull);
      expect(keyK1!.length, equals(36));
      expect(capturedKeys.length, equals(1));

      // -----------------------------------------------------------------------
      // Step 2: Verify K1 is retained for genuine retry while reconciliation is pending.
      // -----------------------------------------------------------------------
      expect(client.hasUnresolvedUserIntent, isTrue,
          reason: 'Intent must be unresolved following uncertain network timeout');

      String? retryKey;
      adapter.onFetch = (options) async {
        retryKey = options.headers['Idempotency-Key'] as String?;
        capturedKeys.add(retryKey!);
        // Still times out or still in-flight
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
          message: 'Second timeout on retry of handover A',
        );
      };

      // Genuine retry of the same unresolved action
      try {
        await client.initiateHandover(shiftId: 'shift_101', amount: 100.00);
        fail('Expected DioException on second connection timeout');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.connectionTimeout));
      }

      expect(retryKey, equals(keyK1),
          reason:
              'K1 must be strictly preserved across user retries while reconciliation is pending');

      // -----------------------------------------------------------------------
      // Step 7 (first check): Assert a DIFFERENT action while intent is unresolved is refused pending reconciliation.
      // -----------------------------------------------------------------------
      final refusedDifferentResult = await client.initiateDifferentAction(
        shiftId: 'shift_101',
        amount: 200.00,
      );
      expect(refusedDifferentResult, isNull,
          reason:
              'Different action must be refused (return null) while previous intent is unresolved pending reconciliation');

      // -----------------------------------------------------------------------
      // Step 3: Simulate recipient rejection of handover A.
      // -----------------------------------------------------------------------
      // The server rejects handover A with HTTP 422 Unprocessable Entity
      String? rejectionAttemptKey;
      adapter.onFetch = (options) async {
        rejectionAttemptKey = options.headers['Idempotency-Key'] as String?;
        return ResponseBody.fromString(
          jsonEncode({
            'message': 'Handover request rejected by recipient: Physical count mismatch',
            'errors': {'amount': ['Physical count does not match']}
          }),
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      // Retrying now yields definitive HTTP 422 rejection from server
      try {
        await client.initiateHandover(shiftId: 'shift_101', amount: 100.00);
        fail('Expected 422 DioException on rejection');
      } on DioException catch (e) {
        expect(e.response?.statusCode, equals(422));
      }

      // The attempt key was K1 during this final attempt
      expect(rejectionAttemptKey, equals(keyK1));

      // Rejection is a definitive outcome: the unresolved intent is resolved
      expect(client.hasUnresolvedUserIntent, isFalse,
          reason: 'Definitive rejection resolves the pending intent state');

      // -----------------------------------------------------------------------
      // Step 4: Initiate a new handover B with identical payload (100.00 SAR).
      // -----------------------------------------------------------------------
      String? keyK2;
      Map<String, dynamic>? handoverBResponseData;
      adapter.onFetch = (options) async {
        keyK2 = options.headers['Idempotency-Key'] as String?;
        capturedKeys.add(keyK2!);
        return ResponseBody.fromString(
          jsonEncode({
            'id': 'handover_b_999',
            'status': 'submitted',
            'amount': '100.00',
            'created_at': DateTime.now().toIso8601String(),
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      final responseB = await client.initiateHandover(
        shiftId: 'shift_101',
        amount: 100.00,
      );
      expect(responseB, isNotNull);
      expect(responseB!.statusCode, equals(200));
      handoverBResponseData = responseB.data as Map<String, dynamic>;

      // -----------------------------------------------------------------------
      // Step 5: Assert K1 != K2 (fresh intent key minting).
      // -----------------------------------------------------------------------
      expect(keyK2, isNotNull);
      expect(keyK2, isNot(equals(keyK1)),
          reason:
              'K1 != K2: Handover B is a separate user intent and must mint a distinct idempotency key, even with identical payload');

      // -----------------------------------------------------------------------
      // Step 6: Assert client does NOT display cached success of handover A as confirmation of B.
      // -----------------------------------------------------------------------
      // Handover B returned its own fresh transaction data ('handover_b_999'),
      // and K1 is recorded as completed/resolved, never replayable.
      expect(handoverBResponseData['id'], equals('handover_b_999'));
      expect(IdempotencyScopeManager.hasActiveKey(keyK1!), isFalse,
          reason: 'Key K1 cannot remain active or replay for subsequent operations');

      // -----------------------------------------------------------------------
      // Step 7 (final check): After B succeeds, new submissions continue to mint fresh keys
      // -----------------------------------------------------------------------
      String? keyK3;
      adapter.onFetch = (options) async {
        keyK3 = options.headers['Idempotency-Key'] as String?;
        return ResponseBody.fromString(
          jsonEncode({'id': 'handover_c_1000', 'status': 'submitted'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      };

      final responseC = await client.initiateHandover(
        shiftId: 'shift_101',
        amount: 100.00,
      );
      expect(responseC!.statusCode, equals(200));
      expect(keyK3, isNot(equals(keyK1)));
      expect(keyK3, isNot(equals(keyK2)),
          reason: 'Post-success submissions always receive freshly minted keys');
    });

    test('ReconcileUserIntent manually releases an unresolved intent for a new submission', () async {
      adapter.onFetch = (options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout on server',
        );
      };

      try {
        await client.initiateHandover(shiftId: 'shift_102', amount: 50.00);
        fail('Expected DioException on receive timeout');
      } on DioException catch (e) {
        expect(e.type, equals(DioExceptionType.receiveTimeout));
      }
      expect(client.hasUnresolvedUserIntent, isTrue);

      // Attempting different action is blocked
      final blocked = await client.initiateDifferentAction(
        shiftId: 'shift_102',
        amount: 75.00,
      );
      expect(blocked, isNull);

      // Reconcile user intent explicitly (e.g. after querying shift status)
      client.reconcileUserIntent();
      expect(client.hasUnresolvedUserIntent, isFalse);

      // Now different action can proceed
      String? nextKey;
      adapter.onFetch = (options) async {
        nextKey = options.headers['Idempotency-Key'] as String?;
        return ResponseBody.fromString(
          jsonEncode({'status': 'ok'}),
          200,
          headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
        );
      };

      final allowed = await client.initiateDifferentAction(
        shiftId: 'shift_102',
        amount: 75.00,
      );
      expect(allowed, isNotNull);
      expect(nextKey, isNotNull);
    });
  });
}
