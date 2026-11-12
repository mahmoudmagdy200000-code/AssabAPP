import 'dart:io';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:dio/dio.dart';

class ServerTimeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _extractAndSyncServerTime(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _extractAndSyncServerTime(err.response!);
    }
    handler.next(err);
  }

  void _extractAndSyncServerTime(Response response) {
    try {
      // 1. Check custom X-Server-Time header (ISO 8601 string)
      final xServerTime = response.headers.value('x-server-time');
      if (xServerTime != null && xServerTime.isNotEmpty) {
        final parsed = DateTime.tryParse(xServerTime);
        if (parsed != null) {
          ShiftStartWindowHelper.syncServerTime(parsed);
          return;
        }
      }

      // 2. Check standard HTTP Date header (RFC 7231 / RFC 1123)
      final dateHeader = response.headers.value('date');
      if (dateHeader != null && dateHeader.isNotEmpty) {
        try {
          final parsed = HttpDate.parse(dateHeader);
          ShiftStartWindowHelper.syncServerTime(parsed);
          return;
        } catch (_) {}
      }

      // 3. Check response payload for server_time
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['server_time'] is String) {
          final parsed = DateTime.tryParse(data['server_time']);
          if (parsed != null) {
            ShiftStartWindowHelper.syncServerTime(parsed);
            return;
          }
        }
        final innerData = data['data'];
        if (innerData is Map<String, dynamic>) {
          final startWindow = innerData['start_window'];
          if (startWindow is Map<String, dynamic> && startWindow['server_time'] is String) {
            final parsed = DateTime.tryParse(startWindow['server_time']);
            if (parsed != null) {
              ShiftStartWindowHelper.syncServerTime(parsed);
              return;
            }
          }
        }
      }
    } catch (_) {
      // Fail closed / silent on clock extraction; never disrupt request flow
    }
  }
}
