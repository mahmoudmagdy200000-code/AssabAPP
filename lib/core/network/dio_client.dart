import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'cancel_token_interceptor.dart';
import 'dio_logger_interceptor.dart';
import 'idempotency_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio create({String? customBaseUrl}) {
    final effectiveBaseUrl = customBaseUrl == null
        ? ApiEndpoint.validatedBaseUrl
        : ApiEndpoint.normalizeBaseUrl(customBaseUrl);

    final dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      ...DioLoggerInterceptor.createInterceptors(),
      AuthInterceptor(),
      CancelTokenInterceptor(),
      IdempotencyInterceptor(),
    ]);

    return dio;
  }
}
