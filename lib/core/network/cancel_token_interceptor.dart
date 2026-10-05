import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/services/cancel_request_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:dio/dio.dart';

import '../utils/app_logger.dart';

class CancelTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final routeName =
          options.extra['route'] ?? NavigationService.I.currentRouteName;

      if (routeName != null && routeName.isNotEmpty) {
        final cancelService = getIt<CancelRequestService>();

        final token = cancelService.createToken(routeName);

        options.cancelToken = token;

        AppLogger.log(
          'Attached token for: $routeName -> ${options.path}',
          tag: 'CancelInterceptor',
        );
      } else {
        AppLogger.log(
          'No route found for: ${options.path}',
          tag: 'CancelInterceptor',
        );
      }
    } catch (e) {
      AppLogger.log('Error attaching token: $e', tag: 'CancelInterceptor');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.cancel) {
      AppLogger.log(
        'Request cancelled: ${err.requestOptions.path}',
        tag: 'CancelInterceptor',
      );
      return;
    }

    handler.next(err);
  }
}
