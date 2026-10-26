import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:assab/shift_demo/demo_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class QueueAdapter implements HttpClientAdapter {
  final calls = <RequestOptions>[];
  bool timeout = false;
  Completer<void>? gate;
  Completer<void>? entered;
  final replies = <({int status, dynamic body})>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    calls.add(options);
    if (entered != null && !entered!.isCompleted) entered!.complete();
    if (gate != null) await gate!.future;
    if (timeout) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.receiveTimeout,
      );
    }
    final reply = replies.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(reply.body),
      reply.status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
  void ok(dynamic data) => replies.add((
    status: 200,
    body: {'success': true, 'data': data, 'message': 'OK'},
  ));
}

Map<String, dynamic> previewBody({
  String type = 'shortage',
  num shortage = 20,
}) => {
  'allocation_required': type == 'shortage',
  'shortage_to_allocate': shortage,
  'cash_reconciliation': {
    'counted_cash': 30,
    'expected_cash': 50,
    'cash_variance': type == 'shortage' ? -20 : 0,
    'cash_variance_type': type,
    'pending_incoming_cash': 0,
    'confirmed_opening_cash': 0,
  },
};

void main() {
  late DemoController c;
  late QueueAdapter adapter;
  setUp(() {
    adapter = QueueAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://staging.example/api/v1/'))
      ..httpClientAdapter = adapter;
    c = DemoController(dio);
  });
  tearDown(() => c.dispose());

  Future<void> ready({String type = 'shortage', num shortage = 20}) async {
    c.shift = {'id': 'shift-1', 'status': 'in_progress'};
    c.edit(sales: '115', card: '25', cash: '30', incoming: '10');
    adapter.ok(previewBody(type: type, shortage: shortage));
    await c.reconcile();
  }

  test('decimal validation preserves zero and exact minor units', () {
    expect(money('0'), 0);
    expect(money('12.08'), 1208);
    expect(decimal(1208), '12.08');
    for (final bad in ['', '-1', 'NaN', 'Infinity', '1e2', '0.001', '1,000']) {
      expect(() => money(bad), throwsFormatException);
    }
  });
  test(
    'login contract, bearer token and assigned in-progress shifts',
    () async {
      adapter.ok({
        'token': 'synthetic-token',
        'user': {'id': 'cashier-1', 'name': 'Test'},
      });
      adapter.ok({
        'shifts': [
          {'id': 'shift-1', 'status': 'In Progress'},
        ],
      });
      await c.login('test@example.com', 'synthetic-password');
      expect(c.loggedIn, true);
      expect(c.shifts.single['id'], 'shift-1');
      expect(adapter.calls[0].path, 'cashier/auth/login');
      expect(adapter.calls[0].data, {
        'identifier': 'test@example.com',
        'password': 'synthetic-password',
        'remember_me': false,
      });
      expect(
        adapter.calls[1].headers['Authorization'],
        'Bearer synthetic-token',
      );
    },
  );
  test(
    'shift selection uses server status, never invents assigned identity',
    () async {
      adapter.ok({'id': 'shift-1', 'status': 'in_progress'});
      await c.select('shift-1');
      expect(c.shift!['status'], 'in_progress');
      adapter.ok({'id': 'wrong', 'status': 'completed'});
      await c.select('shift-1');
      expect(c.shift, isNull);
      expect(c.error, isNotNull);
    },
  );
  test(
    'preview sends independent physical count and pending incoming; displays server amounts',
    () async {
      await ready();
      expect(
        adapter.calls.single.path,
        'cashier/shifts/shift-1/cash-reconciliation/preview',
      );
      expect(adapter.calls.single.data, {
        'total_sales': '115.00',
        'card_payments': '25.00',
        'counted_cash': '30.00',
        'pending_incoming_cash': '10.00',
      });
      expect(c.preview!.reconciliation['expected_cash'], 50);
      expect(c.preview!.reconciliation['cash_variance'], -20);
      expect(c.canClose, false);
    },
  );
  test(
    'valid 12+8 shortage serializes as exact decimal JSON and uses cashier end route',
    () async {
      await ready();
      c.allocate([
        const DemoAllocation('cashier', 'c1', '12'),
        const DemoAllocation('employee', 'e1', '8'),
      ]);
      expect(c.canClose, true);
      adapter.ok({
        'shift': {'id': 'shift-1', 'status': 'completed'},
      });
      await c.closeShift();
      final call = adapter.calls.last;
      expect(call.path, 'cashier/shifts/shift-1/end');
      expect(call.data['counted_cash'], '30.00');
      expect(call.data['shortage_allocations'], [
        {
          'responsible_type': 'cashier',
          'responsible_id': 'c1',
          'amount': '12.00',
        },
        {
          'responsible_type': 'employee',
          'responsible_id': 'e1',
          'amount': '8.00',
        },
      ]);
      expect(call.data.containsKey('variance'), false);
      expect(c.shift!['status'], 'completed');
      expect(c.result, contains('completed'));
      expect(c.canClose, false);
    },
  );
  test('invalid allocation sets never reach the network', () async {
    await ready();
    for (final rows in [
      [const DemoAllocation('cashier', 'c1', '15')],
      [const DemoAllocation('other_factors', 'c1', '20')],
      [const DemoAllocation('cashier', '', '20')],
      [
        const DemoAllocation('cashier', 'c1', '-1'),
        const DemoAllocation('employee', 'e1', '21'),
      ],
      [
        const DemoAllocation('cashier', 'c1', '10'),
        const DemoAllocation('cashier', 'c1', '10'),
      ],
      [const DemoAllocation('cashier', 'c1', '20.001')],
      [const DemoAllocation('cashier', 'c1', '19.99')],
    ]) {
      c.allocate(rows);
      expect(c.canClose, false);
      await c.closeShift();
    }
    expect(adapter.calls.length, 1);
  });
  for (final type in ['surplus', 'balanced']) {
    test(
      '$type does not require allocation; unexpected allocation blocks close',
      () async {
        await ready(type: type, shortage: 0);
        expect(c.canClose, true);
        c.allocate([const DemoAllocation('cashier', 'c1', '1')]);
        expect(c.canClose, false);
        c.allocate([]);
        expect(c.canClose, true);
      },
    );
  }
  test(
    'zero count is valid; missing, negative and overprecision never request preview',
    () async {
      c.shift = {'id': 'shift-1', 'status': 'in_progress'};
      for (final count in ['', '-1', '1.001']) {
        c.edit(sales: '0', cash: count);
        await c.reconcile();
        expect(c.preview, isNull);
      }
      expect(adapter.calls, isEmpty);
      c.edit(cash: '0');
      adapter.ok(previewBody(type: 'balanced', shortage: 0));
      await c.reconcile();
      expect(adapter.calls.single.data['counted_cash'], '0.00');
    },
  );
  test(
    'editing every financial input invalidates preview and allocations',
    () async {
      for (final edit in [
        () => c.edit(sales: '120'),
        () => c.edit(card: '12'),
        () => c.edit(cash: '31'),
        () => c.edit(incoming: '0'),
      ]) {
        await ready();
        c.allocate([const DemoAllocation('cashier', 'c1', '20')]);
        edit();
        expect(c.preview, isNull);
        expect(c.allocations, isEmpty);
        expect(c.canClose, false);
      }
    },
  );
  test('malformed successful preview fails closed', () async {
    c.shift = {'id': 'shift-1', 'status': 'in_progress'};
    c.edit(sales: '1', cash: '1');
    adapter.ok({});
    await c.reconcile();
    expect(c.preview, isNull);
    expect(c.canClose, false);
  });
  for (final status in [422, 409, 403]) {
    test(
      'HTTP $status surfaces message code and field errors; never success',
      () async {
        await ready(type: 'balanced', shortage: 0);
        adapter.replies.add((
          status: status,
          body: {
            'success': false,
            'message': 'Conflict or validation',
            'code': 'TEST_CODE',
            'errors': {
              'counted_cash': ['Refresh count'],
            },
          },
        ));
        await c.closeShift();
        expect(c.result, isNull);
        expect(c.preview, isNull);
        expect(c.error, contains('HTTP $status'));
        expect(c.error, contains('TEST_CODE'));
        expect(c.error, contains('Refresh count'));
      },
    );
  }
  test('401 clears token and session', () async {
    c.loggedIn = true;
    c.dio.options.headers['Authorization'] = 'Bearer synthetic';
    adapter.replies.add((status: 401, body: {'message': 'Unauthenticated'}));
    await c.refreshShifts();
    expect(c.loggedIn, false);
    expect(c.dio.options.headers.containsKey('Authorization'), false);
  });
  test('malformed close response does not invent success or retry', () async {
    await ready(type: 'balanced', shortage: 0);
    adapter.ok({});
    await c.closeShift();
    expect(c.result, isNull);
    expect(c.error, isNotNull);
    expect(c.canClose, false);
    await c.closeShift();
    expect(adapter.calls.length, 2);
  });
  test(
    'ambiguous network outcome blocks retry and preview until read-only refresh',
    () async {
      await ready(type: 'balanced', shortage: 0);
      adapter.timeout = true;
      await c.closeShift();
      expect(c.result, isNull);
      expect(c.needsRefresh, true);
      await c.reconcile();
      expect(adapter.calls.length, 2);
      adapter.timeout = false;
      adapter.ok({'id': 'shift-1', 'status': 'completed'});
      await c.select('shift-1');
      expect(c.canClose, false);
      expect(c.needsRefresh, false);
    },
  );
  test('in-flight closure cannot be duplicated or edited', () async {
    await ready(type: 'balanced', shortage: 0);
    adapter.gate = Completer<void>();
    adapter.entered = Completer<void>();
    adapter.ok({
      'shift': {'id': 'shift-1', 'status': 'completed'},
    });
    final first = c.closeShift();
    await adapter.entered!.future;
    expect(c.busy, true);
    c.edit(cash: '999');
    expect(c.counted, '30');
    await c.closeShift();
    expect(adapter.calls.length, 2);
    adapter.gate!.complete();
    await first;
    expect(c.result, contains('completed'));
  });
}
