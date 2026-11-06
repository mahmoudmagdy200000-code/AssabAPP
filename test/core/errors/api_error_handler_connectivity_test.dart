import 'dart:io';

import 'package:assab/core/errors/api_error_handler.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/errors/l10n/error_locale_resolver.dart';
import 'package:assab/core/errors/l10n/error_messages.dart';
import 'package:assab/core/errors/local_status_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiErrorHandler connectivity & distinction tests', () {
    test(
      'Actual network down (errno 101 / network is unreachable) maps to noInternet error',
      () {
        const socketError = SocketException(
          'Network is unreachable',
          osError: OSError('Network is unreachable', 101),
        );
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api/v1/test'),
          type: DioExceptionType.connectionError,
          error: socketError,
        );

        final failure = ApiErrorHandler.handle(dioException, StackTrace.current);

        expect(failure, isA<NetworkFailure>());
        expect(failure.statusCode, equals(LocalStatusCode.connectionError));
        expect(
          failure.error.message,
          equals(ErrorMessages.resolve(ErrorMessageKey.noInternet, ErrorLocaleResolver.currentLanguage)),
        );
      },
    );

    test(
      'Server host lookup failure (DNS / invalid host) maps to serverUnreachable, NOT noInternet',
      () {
        const socketError = SocketException(
          'Failed host lookup: staging.assab.app',
          osError: OSError('No address associated with hostname', 7),
        );
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api/v1/test'),
          type: DioExceptionType.connectionError,
          error: socketError,
        );

        final failure = ApiErrorHandler.handle(dioException, StackTrace.current);

        expect(failure, isA<NetworkFailure>());
        expect(
          failure.error.message,
          equals(ErrorMessages.resolve(ErrorMessageKey.serverUnreachable, ErrorLocaleResolver.currentLanguage)),
        );
        expect(
          failure.error.message,
          isNot(equals(ErrorMessages.resolve(ErrorMessageKey.noInternet, ErrorLocaleResolver.currentLanguage))),
        );
      },
    );

    test(
      'Connection refused (server down / firewall) maps to serverUnreachable',
      () {
        const socketError = SocketException(
          'Connection refused',
          osError: OSError('Connection refused', 111),
        );
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api/v1/test'),
          type: DioExceptionType.connectionError,
          error: socketError,
        );

        final failure = ApiErrorHandler.handle(dioException, StackTrace.current);

        expect(failure, isA<NetworkFailure>());
        expect(
          failure.error.message,
          equals(ErrorMessages.resolve(ErrorMessageKey.serverUnreachable, ErrorLocaleResolver.currentLanguage)),
        );
      },
    );

    test(
      'Direct SocketException without Dio wrapper distinguishes between network down and server unreachable',
      () {
        const netDown = SocketException(
          'Network down',
          osError: OSError('Network is down', 100),
        );
        final fNetDown = ApiErrorHandler.handle(netDown, StackTrace.current);
        expect(
          fNetDown.error.message,
          equals(ErrorMessages.resolve(ErrorMessageKey.noInternet, ErrorLocaleResolver.currentLanguage)),
        );

        const srvUnreachable = SocketException(
          'Connection refused',
          osError: OSError('Connection refused', 111),
        );
        final fSrv = ApiErrorHandler.handle(srvUnreachable, StackTrace.current);
        expect(
          fSrv.error.message,
          equals(ErrorMessages.resolve(ErrorMessageKey.serverUnreachable, ErrorLocaleResolver.currentLanguage)),
        );
      },
    );

    test(
      'Arabic and English translations exist and are distinct for noInternet and serverUnreachable',
      () {
        final arNoNet = ErrorMessages.resolve(ErrorMessageKey.noInternet, 'ar');
        final arSrv = ErrorMessages.resolve(ErrorMessageKey.serverUnreachable, 'ar');
        expect(arNoNet, contains('لا يوجد اتصال بالإنترنت'));
        expect(arSrv, contains('تعذّر الاتصال بالخادم'));
        expect(arNoNet, isNot(equals(arSrv)));

        final enNoNet = ErrorMessages.resolve(ErrorMessageKey.noInternet, 'en');
        final enSrv = ErrorMessages.resolve(ErrorMessageKey.serverUnreachable, 'en');
        expect(enNoNet, contains('No internet connection'));
        expect(enSrv, contains('Could not connect to the server'));
        expect(enNoNet, isNot(equals(enSrv)));
      },
    );

    test(
      'HTTP 401 Unauthorized maps to AuthFailure with server/auth message, never noInternet',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api/v1/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/login'),
            statusCode: 401,
            data: {'message': 'بيانات تسجيل الدخول غير صحيحة'},
          ),
        );

        final failure = ApiErrorHandler.handle(dioException, StackTrace.current);

        expect(failure, isA<AuthFailure>());
        expect(failure.error.message, equals('بيانات تسجيل الدخول غير صحيحة'));
        expect(
          failure.error.message,
          isNot(equals(ErrorMessages.resolve(ErrorMessageKey.noInternet, 'ar'))),
        );
        expect(
          failure.error.message,
          isNot(equals(ErrorMessages.resolve(ErrorMessageKey.serverUnreachable, 'ar'))),
        );
      },
    );

    test(
      'HTTP 422 Validation error maps to ValidationFailure with server details',
      () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/api/v1/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/login'),
            statusCode: 422,
            data: {
              'message': 'The identifier field is required.',
              'errors': {
                'identifier': ['The identifier field is required.'],
              },
            },
          ),
        );

        final failure = ApiErrorHandler.handle(dioException, StackTrace.current);

        expect(failure, isA<ValidationFailure>());
        expect(failure.error.message, equals('The identifier field is required.'));
      },
    );

    test('Timeout maps to TimeoutFailure, never noInternet', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final failure = ApiErrorHandler.handle(dioException, StackTrace.current);

      expect(failure, isA<TimeoutFailure>());
      expect(
        failure.error.message,
        equals(ErrorMessages.resolve(ErrorMessageKey.timeout, ErrorLocaleResolver.currentLanguage)),
      );
    });
  });
}
