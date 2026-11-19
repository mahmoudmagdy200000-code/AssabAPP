import 'dart:convert';

import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DailyCloseReconcileStatus {
  none,
  confirmed,
  rejected,
  pending,
  unverifiedActor,
}

class DailyCloseReconcileResult {
  const DailyCloseReconcileResult({
    required this.status,
    this.statusCode,
    this.errorCode,
    this.message,
  });

  final DailyCloseReconcileStatus status;
  final int? statusCode;
  final String? errorCode;
  final String? message;
}

class DailyCloseServerError {
  const DailyCloseServerError({
    this.statusCode,
    this.code,
    this.message,
  });

  final int? statusCode;
  final String? code;
  final String? message;

  String formatted({required String fallback}) {
    final cleanMsg = message?.trim();
    final cleanCode = code?.trim();
    if (cleanCode != null && cleanCode.isNotEmpty && cleanMsg != null && cleanMsg.isNotEmpty) {
      return '$cleanMsg ($cleanCode)';
    }
    if (cleanMsg != null && cleanMsg.isNotEmpty) {
      return cleanMsg;
    }
    if (cleanCode != null && cleanCode.isNotEmpty) {
      return cleanCode;
    }
    return fallback;
  }
}

/// Keeps an unresolved submission's exact payload and key across app restarts,
/// and safely reconciles definitive rejections vs ambiguous server outcomes.
class DailyCloseSubmission {
  DailyCloseSubmission(
    this._dio,
    this._preferences, {
    required this.actorId,
    required this.branchId,
  });

  final Dio _dio;
  final SharedPreferences _preferences;
  final String actorId;
  final String branchId;
  static final Set<String> _inFlight = {};

  static const Set<String> _ambiguousConflictCodes = {
    'IDEMPOTENCY_IN_PROGRESS',
  };

  static const Set<String> _alreadyCommittedCodes = {
    'DAILY_REPORT_ALREADY_SUBMITTED',
    'IDEMPOTENCY_RESPONSE_EXPIRED',
  };

  String _storageKey(String id) =>
      'daily_close_submit_v2:${Uri.encodeComponent(_dio.options.baseUrl)}:${Uri.encodeComponent(actorId)}:${Uri.encodeComponent(branchId)}:${Uri.encodeComponent(id)}';
  String _legacyKey(String id) => 'daily_close_submit_intent:$id';
  bool get hasCurrentActor =>
      actorId.isNotEmpty && _preferences.getString('u_id') == actorId;
  bool hasUnresolved(String id) =>
      _preferences.getString(_storageKey(id)) != null ||
      _preferences.getString(_legacyKey(id)) != null;

  static DailyCloseServerError extractServerError(Object? error) {
    if (error is! DioException) {
      return DailyCloseServerError(message: error?.toString());
    }
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    String? code;
    String? message;
    if (data is Map) {
      code = (data['code'] ?? data['error_code'])?.toString();
      message = data['message']?.toString();
      if ((code == null || code.isEmpty) && data['error'] is Map) {
        code = (data['error']['code'] ?? data['error']['error_code'])?.toString();
      }
      if ((message == null || message.isEmpty) && data['error'] is Map) {
        message = data['error']['message']?.toString();
      }
    }
    return DailyCloseServerError(
      statusCode: statusCode,
      code: code,
      message: message,
    );
  }

  static bool isDefinitiveRollbackFailure(DailyCloseServerError err) {
    final status = err.statusCode;
    if (status == null || status < 400 || status >= 500) {
      return false;
    }
    final code = err.code?.trim().toUpperCase();
    if (code != null &&
        (_ambiguousConflictCodes.contains(code) ||
            _alreadyCommittedCodes.contains(code))) {
      return false;
    }
    return true;
  }

  static bool isAlreadyCommittedSignal(DailyCloseServerError err) {
    final code = err.code?.trim().toUpperCase();
    return code != null && _alreadyCommittedCodes.contains(code);
  }

  Map<String, dynamic>? readSavedIntent(String workdayId) {
    final raw = _preferences.getString(_storageKey(workdayId));
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic>
          ? decoded
          : (decoded is Map ? Map<String, dynamic>.from(decoded) : null);
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearIntent(String workdayId) async {
    await _preferences.remove(_storageKey(workdayId));
    await _preferences.remove(_legacyKey(workdayId));
  }

  Future<void> _recordIntentOutcome(
    String workdayId,
    Map<String, dynamic> intent,
    DailyCloseServerError err,
  ) async {
    final updated = Map<String, dynamic>.from(intent)
      ..['lastStatus'] = err.statusCode
      ..['lastCode'] = err.code;
    await _preferences.setString(_storageKey(workdayId), jsonEncode(updated));
  }

  Future<void> submit(String workdayId, int revision) async {
    if (!hasCurrentActor ||
        branchId.isEmpty ||
        workdayId.isEmpty ||
        revision < 1) {
      throw StateError('A selected workday and manager revision are required.');
    }
    final scope = _storageKey(workdayId);
    if (!_inFlight.add(scope)) {
      throw StateError('Submission is already in progress.');
    }
    try {
      final storageKey = _storageKey(workdayId);
      if (_preferences.getString(_legacyKey(workdayId)) != null) {
        throw StateError('An earlier submission must be reconciled first.');
      }
      final saved = _preferences.getString(storageKey);
      final intent = saved == null
          ? <String, dynamic>{
              'key': IdempotencyScopeManager.generateUuidV4(),
              'revision': revision,
            }
          : jsonDecode(saved) as Map<String, dynamic>;
      if (intent['revision'] != revision || intent['key'] is! String) {
        throw StateError('An earlier submission must be reconciled first.');
      }
      if (saved == null &&
          !await _preferences.setString(storageKey, jsonEncode(intent))) {
        throw StateError('Could not safely save the submission intent.');
      }
      if (!hasCurrentActor) {
        throw StateError('Account changed; reconcile the submission.');
      }
      try {
        await _dio.post(
          'branch-manager/workday/daily-close/submit',
          data: {
            'branch_manager_shift_id': workdayId,
            'expected_revision': revision,
          },
          options: Options(headers: {'Idempotency-Key': intent['key']}),
        );
      } on DioException catch (e) {
        final parsed = extractServerError(e);
        if (isDefinitiveRollbackFailure(parsed)) {
          // Backend idempotency middleware guarantees full rollback & reservation release on non-2xx.
          await _clearIntent(workdayId);
        } else {
          await _recordIntentOutcome(workdayId, intent, parsed);
        }
        rethrow;
      }
    } finally {
      _inFlight.remove(scope);
    }
  }

  /// Safely reconciles an unresolved submission intent:
  /// 1) Reads server state by exact workday UUID. If submitted, clears intent.
  /// 2) If unsubmitted and revision matches, replays the exact saved payload/key ONCE.
  /// 3) Surfaces definitive validation rejections and clears the rolled-back intent.
  /// 4) Retains intent on ambiguous/in-progress/5xx outcomes without generating new keys.
  Future<DailyCloseReconcileResult> reconcile(
    String workdayId, {
    required int? currentRevision,
    required Future<bool> Function() refreshAndVerifySubmitted,
  }) async {
    if (!hasCurrentActor) {
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.unverifiedActor,
      );
    }

    final verifiedBeforeReplay = await refreshAndVerifySubmitted();
    if (verifiedBeforeReplay) {
      await resolveSubmitted(workdayId);
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.confirmed,
      );
    }

    if (_preferences.getString(_legacyKey(workdayId)) != null) {
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.pending,
      );
    }

    final saved = readSavedIntent(workdayId);
    if (saved == null) {
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.none,
      );
    }

    final savedRevision = saved['revision'] is int
        ? saved['revision'] as int
        : int.tryParse(saved['revision']?.toString() ?? '');
    if (savedRevision == null || savedRevision < 1 || saved['key'] is! String) {
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.pending,
      );
    }

    if (currentRevision != null && savedRevision != currentRevision) {
      final lastStatus = saved['lastStatus'] is int
          ? saved['lastStatus'] as int
          : int.tryParse(saved['lastStatus']?.toString() ?? '');
      final lastCode = saved['lastCode']?.toString();
      final lastErr = DailyCloseServerError(
        statusCode: lastStatus,
        code: lastCode,
      );
      if (isDefinitiveRollbackFailure(lastErr)) {
        await _clearIntent(workdayId);
        return DailyCloseReconcileResult(
          status: DailyCloseReconcileStatus.rejected,
          statusCode: lastStatus,
          errorCode: lastCode,
        );
      }
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.pending,
      );
    }

    // Single safe replay using the exact saved key & revision (no loop, no new key).
    try {
      await submit(workdayId, savedRevision);
      final verifiedAfterReplay = await refreshAndVerifySubmitted();
      if (verifiedAfterReplay) {
        await resolveSubmitted(workdayId);
        return const DailyCloseReconcileResult(
          status: DailyCloseReconcileStatus.confirmed,
        );
      }
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.pending,
      );
    } on DioException catch (e) {
      final parsed = extractServerError(e);
      if (isAlreadyCommittedSignal(parsed)) {
        final verifiedNow = await refreshAndVerifySubmitted();
        if (verifiedNow) {
          await resolveSubmitted(workdayId);
          return const DailyCloseReconcileResult(
            status: DailyCloseReconcileStatus.confirmed,
          );
        }
        return DailyCloseReconcileResult(
          status: DailyCloseReconcileStatus.pending,
          statusCode: parsed.statusCode,
          errorCode: parsed.code,
          message: parsed.message,
        );
      }
      if (isDefinitiveRollbackFailure(parsed)) {
        return DailyCloseReconcileResult(
          status: DailyCloseReconcileStatus.rejected,
          statusCode: parsed.statusCode,
          errorCode: parsed.code,
          message: parsed.message,
        );
      }
      return DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.pending,
        statusCode: parsed.statusCode,
        errorCode: parsed.code,
        message: parsed.message,
      );
    } catch (_) {
      return const DailyCloseReconcileResult(
        status: DailyCloseReconcileStatus.pending,
      );
    }
  }

  /// Only call after a fresh server read proves this workday was submitted.
  Future<void> resolveSubmitted(String workdayId) async {
    if (!hasCurrentActor) throw StateError('Account changed.');
    await _clearIntent(workdayId);
  }
}
