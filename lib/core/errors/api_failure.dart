import 'package:flutter/cupertino.dart';

import 'api_error_model.dart';

abstract class ApiFailure {
  final BaseApiErrorModel error;
  final IconData icon;
  final int statusCode;
  final StackTrace stackTrace;

  const ApiFailure({
    required this.error,
    required this.icon,
    required this.statusCode,
    required this.stackTrace,
  });
}

class NetworkFailure extends ApiFailure {
  const NetworkFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class TimeoutFailure extends ApiFailure {
  const TimeoutFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class AuthFailure extends ApiFailure {
  const AuthFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class ValidationFailure extends ApiFailure {
  const ValidationFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class NotFoundFailure extends ApiFailure {
  const NotFoundFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class ServerFailure extends ApiFailure {
  const ServerFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class CacheFailure extends ApiFailure {
  const CacheFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class ConnectionClosedFailure extends ApiFailure {
  const ConnectionClosedFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}

class UnknownFailure extends ApiFailure {
  const UnknownFailure({
    required super.error,
    required super.icon,
    required super.statusCode,
    required super.stackTrace,
  });
}
