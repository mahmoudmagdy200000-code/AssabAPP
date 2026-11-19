import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/features/shift_module_features/shift_management/data/daily_close_submission.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool fail = false;
  int? nextStatus;
  Map<String, dynamic>? nextBody;
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
    final status = nextStatus ?? 200;
    final payload = nextBody != null ? jsonEncode(nextBody) : '{}';
    nextStatus = null;
    nextBody = null;
    return ResponseBody.fromString(
      payload,
      status,
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

  test(
    'definitive 409 domain rejection clears intent and surfaces server code',
    () async {
      adapter.nextStatus = 409;
      adapter.nextBody = {
        'success': false,
        'code': 'LIABILITY_EVIDENCE_UNAVAILABLE',
        'message': 'Missing cashier count evidence',
      };

      await expectLater(
        action.submit('workday', 7),
        throwsA(
          isA<DioException>().having(
            (e) => DailyCloseSubmission.extractServerError(e).code,
            'code',
            'LIABILITY_EVIDENCE_UNAVAILABLE',
          ),
        ),
      );
      expect(action.hasUnresolved('workday'), false);
    },
  );

  test(
    'timeout retains intent and reconcile replays once with exact same key',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 7),
        throwsA(isA<DioException>()),
      );
      expect(action.hasUnresolved('workday'), true);
      final originalKey = adapter.requests.single.headers['Idempotency-Key'];

      adapter.fail = false;
      var serverSubmitted = false;
      final result = await action.reconcile(
        'workday',
        refreshWorkday: () async {
          if (adapter.requests.length >= 2) {
            serverSubmitted = true;
          }
          return DailyCloseFreshRead(
            readSucceeded: true,
            workdayId: 'workday',
            managerId: 'manager-1',
            branchId: 'branch-1',
            serverSubmitted: serverSubmitted,
            reportRevision: 7,
          );
        },
      );

      expect(result.status, DailyCloseReconcileStatus.confirmed);
      expect(adapter.requests.length, 2);
      expect(adapter.requests.last.headers['Idempotency-Key'], originalKey);
      expect(action.hasUnresolved('workday'), false);
    },
  );

  test(
    'DAILY_REPORT_ALREADY_SUBMITTED on replay verifies server and clears intent',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 7),
        throwsA(isA<DioException>()),
      );

      adapter.fail = false;
      adapter.nextStatus = 409;
      adapter.nextBody = {
        'success': false,
        'code': 'DAILY_REPORT_ALREADY_SUBMITTED',
        'message': 'Already submitted',
      };

      var checks = 0;
      final result = await action.reconcile(
        'workday',
        refreshWorkday: () async {
          checks++;
          return DailyCloseFreshRead(
            readSucceeded: true,
            workdayId: 'workday',
            managerId: 'manager-1',
            branchId: 'branch-1',
            serverSubmitted: checks >= 2,
            reportRevision: 7,
          );
        },
      );

      expect(result.status, DailyCloseReconcileStatus.confirmed);
      expect(action.hasUnresolved('workday'), false);
    },
  );

  test(
    'IDEMPOTENCY_IN_PROGRESS retains intent and does not clear or generate new key',
    () async {
      adapter.nextStatus = 409;
      adapter.nextBody = {
        'success': false,
        'code': 'IDEMPOTENCY_IN_PROGRESS',
        'message': 'Command in progress',
      };

      await expectLater(
        action.submit('workday', 7),
        throwsA(isA<DioException>()),
      );
      expect(action.hasUnresolved('workday'), true);
      final key = adapter.requests.single.headers['Idempotency-Key'];

      adapter.nextStatus = 409;
      adapter.nextBody = {
        'success': false,
        'code': 'IDEMPOTENCY_IN_PROGRESS',
        'message': 'Still running',
      };
      final result = await action.reconcile(
        'workday',
        refreshWorkday: () async => const DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: 'workday',
          managerId: 'manager-1',
          branchId: 'branch-1',
          serverSubmitted: false,
          reportRevision: 7,
        ),
      );

      expect(result.status, DailyCloseReconcileStatus.pending);
      expect(action.hasUnresolved('workday'), true);
      expect(adapter.requests.last.headers['Idempotency-Key'], key);
    },
  );

  test('account change refuses reconcile and never clears intent', () async {
    adapter.fail = true;
    await expectLater(
      action.submit('workday', 7),
      throwsA(isA<DioException>()),
    );
    await prefs.setString('u_id', 'manager-2');

    final result = await action.reconcile(
      'workday',
      refreshWorkday: () async => const DailyCloseFreshRead(
        readSucceeded: true,
        workdayId: 'workday',
        managerId: 'manager-1',
        branchId: 'branch-1',
        serverSubmitted: true,
        reportRevision: 7,
      ),
    );

    expect(result.status, DailyCloseReconcileStatus.unverifiedActor);
    expect(action.hasUnresolved('workday'), true);
  });

  test(
    'Gap 4 Row 1: fresh GET confirms workday already submitted -> clears intent with 0 extra POSTs',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 4),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests.length, 1);

      adapter.fail = false;
      final result = await action.reconcile(
        'workday',
        refreshWorkday: () async => const DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: 'workday',
          managerId: 'manager-1',
          branchId: 'branch-1',
          serverSubmitted: true,
          reportRevision: 5,
        ),
      );

      expect(result.status, DailyCloseReconcileStatus.confirmed);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), false);
    },
  );

  test(
    'Gap 4 Row 3: fresh GET returns open with changed revision (4 -> 5) -> 0 POSTs and retains intent',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 4),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests.length, 1);

      adapter.fail = false;
      final result = await action.reconcile(
        'workday',
        refreshWorkday: () async => const DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: 'workday',
          managerId: 'manager-1',
          branchId: 'branch-1',
          serverSubmitted: false,
          reportRevision: 5,
        ),
      );

      expect(result.status, DailyCloseReconcileStatus.revisionChangedAmbiguous);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), true);
    },
  );

  test(
    'Gap 4 Row 4a: fresh GET failure or incomplete data -> 0 POSTs and retains intent',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 4),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests.length, 1);

      adapter.fail = false;
      final failedRead = await action.reconcile(
        'workday',
        refreshWorkday: () async =>
            const DailyCloseFreshRead(readSucceeded: false),
      );
      expect(failedRead.status, DailyCloseReconcileStatus.verificationFailed);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), true);

      final incompleteRead = await action.reconcile(
        'workday',
        refreshWorkday: () async => const DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: 'workday',
          managerId: 'manager-1',
          branchId: 'branch-1',
          serverSubmitted: false,
          reportRevision: null,
        ),
      );
      expect(incompleteRead.status, DailyCloseReconcileStatus.verificationFailed);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), true);
    },
  );

  test(
    'Gap 4 Row 4b: branch mismatch or account change mid-GET -> 0 POSTs and retains intent',
    () async {
      adapter.fail = true;
      await expectLater(
        action.submit('workday', 4),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests.length, 1);

      adapter.fail = false;
      final wrongBranch = await action.reconcile(
        'workday',
        refreshWorkday: () async => const DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: 'workday',
          managerId: 'manager-1',
          branchId: 'branch-99',
          serverSubmitted: true,
          reportRevision: 4,
        ),
      );
      expect(wrongBranch.status, DailyCloseReconcileStatus.verificationFailed);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), true);

      final wrongWorkday = await action.reconcile(
        'workday',
        refreshWorkday: () async => const DailyCloseFreshRead(
          readSucceeded: true,
          workdayId: 'other-workday',
          managerId: 'manager-1',
          branchId: 'branch-1',
          serverSubmitted: false,
          reportRevision: 4,
        ),
      );
      expect(wrongWorkday.status, DailyCloseReconcileStatus.verificationFailed);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), true);

      final switchedAccount = await action.reconcile(
        'workday',
        refreshWorkday: () async {
          await prefs.setString('u_id', 'manager-2');
          return const DailyCloseFreshRead(
            readSucceeded: true,
            workdayId: 'workday',
            managerId: 'manager-1',
            branchId: 'branch-1',
            serverSubmitted: true,
            reportRevision: 4,
          );
        },
      );
      expect(switchedAccount.status, DailyCloseReconcileStatus.unverifiedActor);
      expect(adapter.requests.length, 1);
      expect(action.hasUnresolved('workday'), true);
    },
  );
}
