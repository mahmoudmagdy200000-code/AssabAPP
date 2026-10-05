import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

import '../di/dependency_injection.dart';
import 'unauthorized_dialog.dart';

class AuthInterceptor extends Interceptor {
  bool _isUnauthorizedHandled = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await getIt.get<TokenStorageService>().getAccessToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (e, st) {
      AppLogger.log(
        'AuthInterceptor: failed to retrieve access token: $e\n$st',
      );
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isUnauthorized(error)) {
      return handler.next(error);
    }

    if (_isUnauthorizedHandled) {
      return handler.next(error);
    }
    _isUnauthorizedHandled = true;

    await _handleUnauthorized(error, handler);
  }

  bool _isUnauthorized(DioException error) {
    if (error.response?.statusCode != 401) return false;
    if (error.requestOptions.uri.toString().contains('/auth')) return false;
    return true;
  }

  Future<void> _handleUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      await AuthService.logout();
    } catch (e) {
      AppLogger.log('AuthInterceptor: AuthService.logout() threw: $e');
    }

    final context = NavigationService.I.context;

    if (context == null || !context.mounted) {
      AppLogger.log(
        'AuthInterceptor: 401 received but no mounted context found. '
        'Resetting handler flag.',
      );
      _isUnauthorizedHandled = false;
      return handler.next(error);
    }

    AppDialog.showCustomDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          UnauthorizedDialog(onDismiss: () => _isUnauthorizedHandled = false),
    );

    return handler.next(error);
  }
}
