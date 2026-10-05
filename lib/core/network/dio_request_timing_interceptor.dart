import 'package:dio/dio.dart';

class DioRequestTimingInterceptor extends Interceptor {
  static const String extraKey = '_dio_logger_start';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[extraKey] = DateTime.now();
    handler.next(options);
  }
}
