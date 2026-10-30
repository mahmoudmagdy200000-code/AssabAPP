import 'dart:async';
import 'dart:typed_data';
import 'package:assab/features/custody/data/custody_receipt_action.dart';
import 'package:assab/features/custody/data/models/custody_request_details_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool fail = false;
  Completer<void>? hold;
  @override
  Future<ResponseBody> fetch(
    RequestOptions request,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    requests.add(request);
    if (hold != null) await hold!.future;
    if (fail) {
      throw DioException.connectionError(
        requestOptions: request,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late _Adapter adapter;
  late CustodyReceiptAction action;
  setUp(() async {
    SharedPreferences.setMockInitialValues({'u_id': 'manager-1'});
    prefs = await SharedPreferences.getInstance();
    adapter = _Adapter();
    action = CustodyReceiptAction(
      Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
        ..httpClientAdapter = adapter,
      prefs,
      actorId: 'manager-1',
    );
  });
  test('eligibility defaults to false and accepts only the server flag', () {
    Map<String, dynamic> data(Object? flag) => {
      'requestId': 'r1',
      'status': 'approved',
      'canConfirmReceipt': flag,
      'details': {
        'requestedAmount': 10,
        'purpose': '',
        'preferredReceiptMethod': '',
        'attachments': [],
        'additionalNotes': null,
      },
    };
    expect(
      CustodyRequestDetailsData.fromJson(data(true)).canConfirmReceipt,
      true,
    );
    expect(
      CustodyRequestDetailsData.fromJson(data(null)).canConfirmReceipt,
      false,
    );
    expect(
      CustodyRequestDetailsData.fromJson(data('true')).canConfirmReceipt,
      false,
    );
  });
  test('posts exact request without an amount and blocks duplicate', () async {
    await action.confirm('request-1');
    expect(
      adapter.requests.single.uri.path,
      '/api/v1/custody/requests/request-1/confirm-receipt',
    );
    expect(adapter.requests.single.data, isNull);
    expect(action.isUnresolved('request-1'), true);
    await expectLater(action.confirm('request-1'), throwsStateError);
    expect(adapter.requests.length, 1);
  });
  test('uncertain result survives a new action instance', () async {
    adapter.fail = true;
    await expectLater(
      action.confirm('request-1'),
      throwsA(isA<DioException>()),
    );
    expect(
      CustodyReceiptAction(
        Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/')),
        prefs,
        actorId: 'manager-1',
      ).isUnresolved('request-1'),
      true,
    );
    await expectLater(action.confirm('request-1'), throwsStateError);
    expect(adapter.requests.length, 1);
    await action.resolveConfirmed('request-1');
    expect(action.isUnresolved('request-1'), false);
  });
  test('concurrent confirmations are blocked', () async {
    adapter.hold = Completer<void>();
    final first = action.confirm('request-1');
    await Future<void>.delayed(Duration.zero);
    await expectLater(action.confirm('request-1'), throwsStateError);
    adapter.hold!.complete();
    await first;
    expect(adapter.requests.length, 1);
  });
  test(
    'lost response refreshes details and balance before accepting receipt',
    () async {
      adapter.fail = true;
      var balanceReads = 0;
      final confirmed = await action.confirmAndReconcile(
        'request-1',
        refreshDetails: () async => true,
        refreshBalance: () async {
          balanceReads++;
        },
      );
      expect(confirmed, true);
      expect(balanceReads, 1);
      expect(action.isUnresolved('request-1'), false);
    },
  );
  test('unconfirmed refresh keeps receipt locked', () async {
    final confirmed = await action.confirmAndReconcile(
      'request-1',
      refreshDetails: () async => false,
      refreshBalance: () async {},
    );
    expect(confirmed, false);
    expect(action.isUnresolved('request-1'), true);
  });
  test(
    'account switch isolates unresolved state and stale actor cannot post',
    () async {
      await action.confirm('request-1');
      await prefs.setString('u_id', 'manager-2');
      await expectLater(action.confirm('request-2'), throwsStateError);
      final other = CustodyReceiptAction(
        Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/')),
        prefs,
        actorId: 'manager-2',
      );
      expect(other.isUnresolved('request-1'), false);
      expect(adapter.requests.length, 1);
    },
  );
  test('legacy uncertain flag fails closed', () async {
    await prefs.setBool('custody_receipt_unresolved:request-1', true);
    await expectLater(action.confirm('request-1'), throwsStateError);
    expect(adapter.requests, isEmpty);
  });
}
