import 'dart:async';
import 'dart:typed_data';

import 'package:assab/features/shift_module_features/shift_management/data/daily_close_submission.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool fail = false;
  Completer<void>? hold;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (hold != null) await hold!.future;
    if (fail) {
      throw DioException.connectionError(
        requestOptions: options,
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
  late DailyCloseSubmission action;
  setUp(() async {
    SharedPreferences.setMockInitialValues({'u_id': 'manager-1'});
    prefs = await SharedPreferences.getInstance();
    adapter = _Adapter();
    action = DailyCloseSubmission(
      Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
        ..httpClientAdapter = adapter,
      prefs,
      actorId: 'manager-1',
      branchId: 'branch-1',
    );
  });

  test('sends manager workday and revision with a UUID key', () async {
    await action.submit('workday', 7);
    final request = adapter.requests.single;
    expect(
      request.uri.path,
      '/api/v1/branch-manager/workday/daily-close/submit',
    );
    expect(request.data, {
      'branch_manager_shift_id': 'workday',
      'expected_revision': 7,
    });
    expect(
      request.headers['Idempotency-Key'],
      matches(RegExp(r'^[0-9a-f-]{36}$')),
    );
  });

  test(
    'unknown result retains the same payload and key across instances',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 7),
        throwsA(isA<DioException>()),
      );
      final first = adapter.requests.single.headers['Idempotency-Key'];
      adapter.fail = false;
      await DailyCloseSubmission(
        Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
          ..httpClientAdapter = adapter,
        prefs,
        actorId: 'manager-1',
        branchId: 'branch-1',
      ).submit('workday', 7);
      expect(adapter.requests.last.headers['Idempotency-Key'], first);
      await expectLater(action.submit('workday', 8), throwsStateError);
      expect(adapter.requests.length, 2);
    },
  );

  test('concurrent submissions are blocked', () async {
    adapter.hold = Completer<void>();
    final first = action.submit('workday', 7);
    await Future<void>.delayed(Duration.zero);
    await expectLater(action.submit('workday', 7), throwsStateError);
    adapter.hold!.complete();
    await first;
    expect(adapter.requests.length, 1);
  });

  test('manager revision and submitted status come from shift.daily_close', () {
    final data = FinalDailyCloseData.fromJson({
      'shift': {
        'status': 'completed',
        'shift_details': {'manager_id': 'manager-1', 'branch_id': 'branch-1'},
        'daily_close': {'report_revision': 7, 'is_submitted': true},
      },
      'cashier_breakdown': [],
      'totals': <String, dynamic>{},
      'aggregators': [],
    });
    expect(data.managerReportRevision, 7);
    expect(data.serverSubmitted, true);
    expect(data.managerShiftCompleted, true);
    expect(data.managerId, 'manager-1');
    expect(data.branchId, 'branch-1');
  });
  test(
    'account and branch scope isolate intents and stale account cannot submit',
    () async {
      await action.submit('workday', 7);
      await prefs.setString('u_id', 'manager-2');
      await expectLater(action.submit('other', 7), throwsStateError);
      final other = DailyCloseSubmission(
        Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/')),
        prefs,
        actorId: 'manager-2',
        branchId: 'branch-2',
      );
      expect(other.hasUnresolved('workday'), false);
      expect(adapter.requests.length, 1);
    },
  );
  test('legacy intent fails closed', () async {
    await prefs.setString('daily_close_submit_intent:workday', '{}');
    expect(action.hasUnresolved('workday'), true);
    await expectLater(action.submit('workday', 7), throwsStateError);
    expect(adapter.requests, isEmpty);
  });
}
