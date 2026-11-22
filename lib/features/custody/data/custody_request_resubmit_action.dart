import 'package:dio/dio.dart';

/// Resubmits the existing rejected request; the server preserves its history.
class CustodyRequestResubmitAction {
  CustodyRequestResubmitAction(this._dio);

  final Dio _dio;
  static final Set<String> _inFlight = {};

  Future<void> resubmit(String requestId) async {
    final key = '${_dio.options.baseUrl}:$requestId';
    if (requestId.isEmpty || !_inFlight.add(key)) {
      throw StateError('Resubmission is already in progress.');
    }
    try {
      await _dio.post(
        'custody/requests/${Uri.encodeComponent(requestId)}/resubmit',
      );
    } finally {
      _inFlight.remove(key);
    }
  }
}
