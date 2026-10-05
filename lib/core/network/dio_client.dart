import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'cancel_token_interceptor.dart';
import 'dio_logger_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      ...DioLoggerInterceptor.createInterceptors(),
      AuthInterceptor(),
      CancelTokenInterceptor(),
    ]);

    return dio;
  }
}
