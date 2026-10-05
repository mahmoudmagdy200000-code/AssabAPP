import 'package:dio/dio.dart';

import '../utils/app_logger.dart';

class CancelRequestService {
  final Map<String, List<CancelToken>> _tokens = {};

  /// Create a new token for each request (IMPORTANT)
  CancelToken createToken(String key) {
    final token = CancelToken();

    _tokens.putIfAbsent(key, () => []).add(token);

    AppLogger.log('Created token for: $key', tag: 'CancelService');

    return token;
  }

  /// Cancel all requests for a route
  void cancelRoute(String key) {
    final tokens = _tokens[key];

    if (tokens != null) {
      for (final token in tokens) {
        if (!token.isCancelled) {
          token.cancel('Request cancelled: leaving $key');
        }
      }

      AppLogger.log('Cancelled all tokens for: $key', tag: 'CancelService');

      _tokens.remove(key);
    }
  }

  /// Cancel all tokens globally
  void cancelAll() {
    for (final entry in _tokens.entries) {
      for (final token in entry.value) {
        if (!token.isCancelled) {
          token.cancel('All requests cancelled');
        }
      }
      AppLogger.log('Cancelled tokens for: ${entry.key}', tag: 'CancelService');
    }

    _tokens.clear();
  }

  int getActiveRequestsCount(String key) {
    return _tokens[key]?.length ?? 0;
  }
}
