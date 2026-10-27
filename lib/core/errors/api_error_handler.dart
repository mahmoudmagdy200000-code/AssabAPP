import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_cancelled_exception.dart';
import 'api_error_model.dart';
import 'api_failure.dart';
import 'api_status_code.dart';
import 'error_logger.dart';
import 'l10n/error_locale_resolver.dart';
import 'l10n/error_messages.dart';
import 'local_status_code.dart';

class ApiErrorHandler {
  const ApiErrorHandler._();

  static String _msg(ErrorMessageKey key) => ErrorLocaleResolver.resolve(key);

  static ApiFailure handle(Object error, StackTrace stackTrace) {
    if (error is DioException && error.type == DioExceptionType.cancel) {
      throw const ApiCancelledException();
    }

    late final ApiFailure failure;

    switch (error) {
      case DioException e:
        failure = _handleDioError(e);

      case SocketException _:
        failure = NetworkFailure(
          error: LocalErrorModel(message: _msg(ErrorMessageKey.noInternet)),
          icon: CupertinoIcons.wifi_slash,
          statusCode: LocalStatusCode.connectionError,
          stackTrace: stackTrace,
        );
      case TimeoutException _:
        failure = TimeoutFailure(
          error: LocalErrorModel(message: _msg(ErrorMessageKey.timeout)),
          icon: CupertinoIcons.timer,
          statusCode: LocalStatusCode.connectionTimeout,
          stackTrace: stackTrace,
        );
      case FormatException _:
        failure = UnknownFailure(
          error: LocalErrorModel(message: _msg(ErrorMessageKey.invalidFormat)),
          icon: CupertinoIcons.text_bubble,
          statusCode: LocalStatusCode.formatException,
          stackTrace: stackTrace,
        );
      case TypeError e:
        failure = UnknownFailure(
          error: LocalErrorModel(
            message: '${_msg(ErrorMessageKey.invalidFormat)}: ${e.toString()}',
          ),
          icon: CupertinoIcons.text_bubble,
          statusCode: LocalStatusCode.formatException,
          stackTrace: stackTrace,
        );
      case Exception e:
        failure = UnknownFailure(
          error: LocalErrorModel(
            message: '${_msg(ErrorMessageKey.unexpected)}: ${e.toString()}',
          ),
          icon: CupertinoIcons.exclamationmark_triangle,
          statusCode: LocalStatusCode.unknown,
          stackTrace: stackTrace,
        );
      default:
        failure = UnknownFailure(
          error: LocalErrorModel(message: _msg(ErrorMessageKey.unexpected)),
          icon: CupertinoIcons.exclamationmark_triangle,
          statusCode: LocalStatusCode.unknown,
          stackTrace: stackTrace,
        );
    }

    ErrorLogger.log(failure, error, tag: 'ApiErrorHandler');
    return failure;
  }

  static ApiFailure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          error: DioErrorModel(message: _msg(ErrorMessageKey.timeout)),
          icon: CupertinoIcons.clock,
          statusCode: LocalStatusCode.connectionTimeout,
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.badCertificate:
        return NetworkFailure(
          error: DioErrorModel(message: _msg(ErrorMessageKey.connectionClosed)),
          icon: CupertinoIcons.exclamationmark_shield,
          statusCode: LocalStatusCode.badCertificate,
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.badResponse:
        return _handleResponse(e.response, e.stackTrace);
      case DioExceptionType.cancel:
        throw const ApiCancelledException();
      case DioExceptionType.connectionError:
        return NetworkFailure(
          error: DioErrorModel(message: _msg(ErrorMessageKey.noInternet)),
          icon: CupertinoIcons.wifi_slash,
          statusCode: LocalStatusCode.connectionError,
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.unknown:
        return UnknownFailure(
          error: DioErrorModel(message: _msg(ErrorMessageKey.unexpected)),
          icon: CupertinoIcons.exclamationmark_triangle,
          statusCode: LocalStatusCode.unknown,
          stackTrace: e.stackTrace,
        );
    }
  }

  static ApiFailure _handleResponse(Response? response, StackTrace stackTrace) {
    final statusCode = response?.statusCode ?? 0;
    final rawData = response?.data;
    final mapData = rawData is Map ? rawData : null;
    final nestedError = mapData?['error'];
    final nestedErrorMap = nestedError is Map ? nestedError : null;
    final rawErrors = mapData?['errors'] ?? nestedErrorMap?['details'];
    final errorsMap = rawErrors is Map<String, dynamic>
        ? rawErrors
        : (rawErrors is Map ? Map<String, dynamic>.from(rawErrors) : null);

    String serverMessage(ErrorMessageKey fallback) {
      final topMessage = mapData?['message']?.toString().trim();
      if (topMessage != null && topMessage.isNotEmpty) {
        return topMessage;
      }
      final nestedMessage = nestedErrorMap?['message']?.toString().trim();
      if (nestedMessage != null && nestedMessage.isNotEmpty) {
        return nestedMessage;
      }
      return _msg(fallback);
    }

    switch (statusCode) {
      case ApiStatusCode.badRequest:
        return ValidationFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.badRequest),
            errors: errorsMap,
          ),
          icon: CupertinoIcons.exclamationmark_circle,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      case ApiStatusCode.unauthorized:
        return AuthFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.unauthorized),
          ),
          icon: CupertinoIcons.lock,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      case ApiStatusCode.forbidden:
        return AuthFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.forbidden),
          ),
          icon: CupertinoIcons.lock,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      case ApiStatusCode.unprocessableEntity:
        return ValidationFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.validationFailed),
            errors: errorsMap,
          ),
          icon: CupertinoIcons.exclamationmark_circle,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      case ApiStatusCode.notFound:
        return NotFoundFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.notFound),
          ),
          icon: CupertinoIcons.search,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      case ApiStatusCode.internalServerError:
      case 502:
      case ApiStatusCode.serviceUnavailable:
      case 504:
        final resolvedMessage = serverMessage(ErrorMessageKey.serverError);
        final lowerMsg = resolvedMessage.toLowerCase();
        // Supplier auth controller extends BaseController which maps plain
        // Exception('Invalid credentials') / Exception('Account is inactive')
        // to HTTP 500 JSON; surface those cleanly as AuthFailure.
        if (lowerMsg.contains('invalid credentials') ||
            lowerMsg.contains('account is inactive')) {
          return AuthFailure(
            error: DioErrorModel(message: resolvedMessage),
            icon: CupertinoIcons.lock,
            statusCode: statusCode,
            stackTrace: stackTrace,
          );
        }
        return ServerFailure(
          error: DioErrorModel(message: resolvedMessage),
          icon: CupertinoIcons.antenna_radiowaves_left_right,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      case ApiStatusCode.movedPermanently:
        return AuthFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.sessionExpired),
          ),
          icon: CupertinoIcons.lock,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
      default:
        return UnknownFailure(
          error: DioErrorModel(
            message: serverMessage(ErrorMessageKey.unexpected),
          ),
          icon: CupertinoIcons.exclamationmark_triangle,
          statusCode: statusCode,
          stackTrace: stackTrace,
        );
    }
  }
}
