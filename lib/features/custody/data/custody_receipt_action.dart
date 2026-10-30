import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Refuses a second receipt while an earlier outcome is unresolved.
class CustodyReceiptAction {
  CustodyReceiptAction(this._dio, this._preferences, {required this.actorId});
  final Dio _dio;
  final SharedPreferences _preferences;
  final String actorId;
  static final Set<String> _inFlight = {};
  String _key(String requestId) =>
      'custody_receipt_v2:${Uri.encodeComponent(_dio.options.baseUrl)}:${Uri.encodeComponent(actorId)}:${Uri.encodeComponent(requestId)}';
  String _legacyKey(String requestId) =>
      'custody_receipt_unresolved:$requestId';

  bool get hasCurrentActor =>
      actorId.isNotEmpty && _preferences.getString('u_id') == actorId;

  bool isUnresolved(String requestId) =>
      (_preferences.getBool(_key(requestId)) ?? false) ||
      (_preferences.getBool(_legacyKey(requestId)) ?? false);

  Future<void> confirm(String requestId) async {
    final scope = _key(requestId);
    if (!hasCurrentActor || requestId.isEmpty || !_inFlight.add(scope)) {
      throw StateError('Receipt confirmation is already in progress.');
    }
    try {
      if (isUnresolved(requestId) ||
          !await _preferences.setBool(_key(requestId), true)) {
        throw StateError('Receipt outcome requires reconciliation.');
      }
      if (!hasCurrentActor) {
        throw StateError('Account changed; reconcile the receipt.');
      }
      await _dio.post(
        'custody/requests/${Uri.encodeComponent(requestId)}/confirm-receipt',
      );
    } finally {
      _inFlight.remove(scope);
    }
  }

  /// A lost response is reconciled by read-only refreshes; never infer success
  /// from the POST alone. A failed refresh leaves the intent blocked.
  Future<bool> confirmAndReconcile(
    String requestId, {
    required Future<bool> Function() refreshDetails,
    required Future<void> Function() refreshBalance,
  }) async {
    try {
      await confirm(requestId);
    } catch (_) {
      // Even an error can follow a committed receipt.
    }
    final results = await Future.wait<Object>([
      refreshDetails(),
      refreshBalance().then<Object>((_) => true),
    ]);
    final confirmed = results.first == true;
    if (confirmed) await resolveConfirmed(requestId);
    return confirmed;
  }

  /// Only after the server's details response confirms completed receipt.
  Future<void> resolveConfirmed(String requestId) async {
    if (!hasCurrentActor) throw StateError('Account changed.');
    await _preferences.remove(_key(requestId));
    await _preferences.remove(_legacyKey(requestId));
  }
}
