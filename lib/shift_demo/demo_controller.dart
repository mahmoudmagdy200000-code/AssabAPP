import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Strict decimal input. Integer minor units are used only to validate input
/// and allocation totals; all reconciliation values come from the server.
int money(String text) {
  final value = text.trim();
  if (!RegExp(r'^\d{1,10}(\.\d{1,2})?$').hasMatch(value)) {
    throw const FormatException(
      'أدخل مبلغًا موجبًا أو صفرًا بخانتين عشريتين كحد أقصى',
    );
  }
  final parts = value.split('.');
  return int.parse(parts[0]) * 100 +
      int.parse(parts.length == 1 ? '0' : parts[1].padRight(2, '0'));
}

String decimal(int minor) => (minor / 100).toStringAsFixed(2);

Map<String, dynamic> object(dynamic value) {
  if (value is! Map) throw const FormatException('صيغة رد السيرفر غير متوافقة');
  return Map<String, dynamic>.from(value);
}

class DemoApiError implements Exception {
  const DemoApiError(this.message, {this.status, this.code});
  final String message;
  final int? status;
  final String? code;
  @override
  String toString() => [
    if (status != null) 'HTTP $status',
    if (code != null) code,
    message,
  ].join(' · ');
}

class DemoPreview {
  DemoPreview(Map<String, dynamic> data)
    : reconciliation = object(data['cash_reconciliation']),
      allocationRequired = data['allocation_required'] == true,
      shortage = money(data['shortage_to_allocate'].toString()) {
    if (data['allocation_required'] is! bool ||
        ![
          'balanced',
          'shortage',
          'surplus',
        ].contains(reconciliation['cash_variance_type'])) {
      throw const FormatException('بيانات التسوية غير مكتملة');
    }
    for (final key in [
      'counted_cash',
      'expected_cash',
      'cash_variance',
      'pending_incoming_cash',
      'confirmed_opening_cash',
    ]) {
      final value = num.tryParse(reconciliation[key].toString());
      if (value == null || !value.isFinite) {
        throw const FormatException('مبلغ التسوية غير صالح');
      }
    }
    if (allocationRequired != (shortage > 0) ||
        allocationRequired !=
            (reconciliation['cash_variance_type'] == 'shortage')) {
      throw const FormatException('رد توزيع العجز غير متوافق');
    }
  }
  final Map<String, dynamic> reconciliation;
  final bool allocationRequired;
  final int shortage;
}

class DemoAllocation {
  const DemoAllocation(this.type, this.id, this.amount);
  final String type;
  final String id;
  final String amount;
  Map<String, dynamic> toJson() => {
    'responsible_type': type,
    'responsible_id': id.trim(),
    'amount': decimal(money(amount)),
  };
}

class DemoController extends ChangeNotifier {
  DemoController(this.dio);
  final Dio dio;
  bool busy = false;
  bool loggedIn = false;
  bool needsRefresh = false;
  String? cashierId;
  String? name;
  String? error;
  String? result;
  List<Map<String, dynamic>> shifts = [];
  Map<String, dynamic>? shift;
  DemoPreview? preview;
  List<DemoAllocation> allocations = [];
  String totalSales = '', cards = '0', counted = '', pending = '0';
  int _revision = 0;
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    dio.close(force: true);
    super.dispose();
  }

  void edit({String? sales, String? card, String? cash, String? incoming}) {
    if (busy) return;
    totalSales = sales ?? totalSales;
    cards = card ?? cards;
    counted = cash ?? counted;
    pending = incoming ?? pending;
    _invalidate();
    notifyListeners();
  }

  void _invalidate() {
    _revision++;
    preview = null;
    allocations = [];
    result = null;
  }

  Map<String, dynamic> _figures() => {
    'total_sales': decimal(money(totalSales)),
    'card_payments': decimal(money(cards)),
    'counted_cash': decimal(money(counted)),
    'pending_incoming_cash': decimal(money(pending)),
  };

  bool get canClose {
    if (busy ||
        needsRefresh ||
        shift?['status'] != 'in_progress' ||
        preview == null) {
      return false;
    }
    if (!preview!.allocationRequired) return allocations.isEmpty;
    final seen = <String>{};
    int sum = 0;
    try {
      for (final row in allocations) {
        if (!['cashier', 'branch_manager', 'employee'].contains(row.type) ||
            row.id.trim().isEmpty ||
            row.id.trim().length > 64 ||
            !seen.add('${row.type}:${row.id.trim()}') ||
            money(row.amount) <= 0) {
          return false;
        }
        sum += money(row.amount);
      }
    } on FormatException {
      return false;
    }
    return sum == preview!.shortage;
  }

  void allocate(List<DemoAllocation> rows) {
    if (busy) return;
    allocations = List.unmodifiable(rows);
    notifyListeners();
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.request<dynamic>(
        path,
        data: body,
        options: Options(method: method),
      );
      final json = object(response.data);
      if (json['success'] != true) {
        throw DemoApiError(
          json['message']?.toString() ?? 'السيرفر رفض العملية',
        );
      }
      return json;
    } on DioException catch (e) {
      final data = e.response?.data;
      final json = data is Map ? data : <String, dynamic>{};
      final status = e.response?.statusCode;
      if (status == 401) {
        loggedIn = false;
        dio.options.headers.remove('Authorization');
        shifts = [];
        shift = null;
        cashierId = null;
        name = null;
      }
      final fields = json['errors'];
      final details = fields is Map
          ? fields.entries
                .map(
                  (e) =>
                      '${e.key}: ${e.value is List ? (e.value as List).join(', ') : e.value}',
                )
                .join('\n')
          : '';
      throw DemoApiError(
        '${json['message'] ?? 'تعذر الاتصال. حدّث حالة الوردية قبل إعادة أي عملية مالية.'}${details.isEmpty ? '' : '\n$details'}',
        status: status,
        code: json['code']?.toString(),
      );
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (busy) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      preview = null;
      allocations = [];
      error = e is DemoApiError || e is FormatException
          ? e.toString()
          : 'رد السيرفر غير متوافق؛ حدّث حالة الوردية قبل المتابعة.';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> login(String identifier, String password) => _run(() async {
    final json = await _request(
      'POST',
      'cashier/auth/login',
      body: {
        'identifier': identifier.trim(),
        'password': password,
        'remember_me': false,
      },
    );
    final data = object(json['data']);
    final token = data['token'];
    final user = object(data['user']);
    if (token is! String || token.isEmpty || user['id'] == null) {
      throw const FormatException('رد تسجيل الدخول غير متوافق');
    }
    dio.options.headers['Authorization'] = 'Bearer $token';
    cashierId = user['id'].toString();
    name = user['name']?.toString();
    loggedIn = true;
    await _loadShifts();
  });

  Future<void> _loadShifts() async {
    final json = await _request('GET', 'cashier/my-shifts/in-progress');
    final list = object(json['data'])['shifts'];
    if (list is! List) {
      throw const FormatException('قائمة الورديات غير متوافقة');
    }
    shifts = list.map(object).toList();
  }

  Future<void> refreshShifts() => _run(_loadShifts);

  Future<void> select(String id) => _run(() async {
    _invalidate();
    shift = null;
    final json = await _request(
      'GET',
      'cashier/my-shifts/${Uri.encodeComponent(id)}',
    );
    final data = object(json['data']);
    if (data['id']?.toString() != id || data['status'] is! String) {
      throw const FormatException('بيانات الوردية غير متوافقة');
    }
    shift = data;
    needsRefresh = false;
  });

  Future<void> reconcile() => _run(() async {
    if (needsRefresh) {
      throw const FormatException('حدّث حالة الوردية قبل أي معاينة جديدة.');
    }
    if (shift?['status'] != 'in_progress') {
      throw const FormatException('اختر وردية قيد العمل');
    }
    _invalidate();
    final revision = _revision;
    final json = await _request(
      'POST',
      'cashier/shifts/${Uri.encodeComponent(shift!['id'].toString())}/cash-reconciliation/preview',
      body: _figures(),
    );
    final next = DemoPreview(object(json['data']));
    if (revision == _revision) preview = next;
  });

  Future<void> closeShift() async {
    if (!canClose) {
      error = 'راجع التسوية ووزّع كامل العجز على موظفين محددين.';
      notifyListeners();
      return;
    }
    final body = _figures();
    if (allocations.isNotEmpty) {
      body['shortage_allocations'] = allocations
          .map((a) => a.toJson())
          .toList();
    }
    await _run(() async {
      needsRefresh = true;
      // No retry interceptor: a timeout is an unknown outcome, never a success.
      final json = await _request(
        'POST',
        'cashier/shifts/${Uri.encodeComponent(shift!['id'].toString())}/end',
        body: body,
      );
      final updated = object(object(json['data'])['shift']);
      if (updated['id']?.toString() != shift!['id']?.toString() ||
          updated['status'] != 'completed') {
        throw const FormatException(
          'استجابة الإغلاق غير مؤكدة؛ حدّث حالة الوردية.',
        );
      }
      shift = updated;
      preview = null;
      allocations = [];
      result = '${json['message']}\nحالة الوردية: ${updated['status']}';
    });
  }
}
