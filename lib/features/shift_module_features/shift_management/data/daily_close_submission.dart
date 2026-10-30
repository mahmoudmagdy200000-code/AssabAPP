import 'dart:convert';

import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps an unresolved submission's exact payload and key across app restarts.
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

  String _storageKey(String id) =>
      'daily_close_submit_v2:${Uri.encodeComponent(_dio.options.baseUrl)}:${Uri.encodeComponent(actorId)}:${Uri.encodeComponent(branchId)}:${Uri.encodeComponent(id)}';
  String _legacyKey(String id) => 'daily_close_submit_intent:$id';
  bool get hasCurrentActor =>
      actorId.isNotEmpty && _preferences.getString('u_id') == actorId;
  bool hasUnresolved(String id) =>
      _preferences.getString(_storageKey(id)) != null ||
      _preferences.getString(_legacyKey(id)) != null;

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
      await _dio.post(
        'branch-manager/workday/daily-close/submit',
        data: {
          'branch_manager_shift_id': workdayId,
          'expected_revision': revision,
        },
        options: Options(headers: {'Idempotency-Key': intent['key']}),
      );
    } finally {
      _inFlight.remove(scope);
    }
  }

  /// Only call after a fresh server read proves this workday was submitted.
  Future<void> resolveSubmitted(String workdayId) async {
    if (!hasCurrentActor) throw StateError('Account changed.');
    await _preferences.remove(_storageKey(workdayId));
    await _preferences.remove(_legacyKey(workdayId));
  }
}
