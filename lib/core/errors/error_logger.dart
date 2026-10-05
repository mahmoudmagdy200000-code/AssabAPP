import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'api_failure.dart';

class ErrorLogger {
  const ErrorLogger._();

  static const int _boxWidth = 80;

  static const int _logChunkSize = 800;

  static const int _defaultStackLines = 10;

  // ANSI codes
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _dim = '\x1B[2m';
  static const _red = '\x1B[91m';
  static const _yellow = '\x1B[93m';
  static const _magenta = '\x1B[95m';
  static const _cyan = '\x1B[96m';
  static const _green = '\x1B[92m';
  static const _blue = '\x1B[94m';
  static const _white = '\x1B[97m';
  static const _grey = '\x1B[90m';
  static const _orange = '\x1B[33m';

  // Box-drawing characters (matches DioLoggerInterceptor)
  static const _topLeft = '╔';
  static const _bottomLeft = '╚';
  static const _horizontal = '═';
  static const _vertical = '║';
  static const _separator = '╟';
  static const _separatorLine = '─';

  static void log(
    ApiFailure failure,
    Object error, {
    String tag = 'ApiError',
    int stackLines = _defaultStackLines,
  }) {
    if (!kDebugMode) {
      // TODO(your-team): Forward to Crashlytics / Sentry here.
      return;
    }

    final colour = _failureColour(failure);
    final sLine = _separatorLine * _boxWidth;
    final hLine = _horizontal * _boxWidth;
    final label = ' [${tag.toUpperCase()}] ';
    final labelFill = _horizontal * (_boxWidth - 2 - label.length);

    final buf = StringBuffer();

    // Top border with label
    buf.writeln(
      '$colour$_topLeft$_bold${_horizontal * 2}$label$labelFill$_reset',
    );

    // Failure identity
    buf.writeln(
      '$colour$_vertical$_reset  '
      '$_bold$colour${failure.runtimeType}$_reset'
      '$_grey  ·  $_reset'
      '$_white${failure.error.getErrorMessage}$_reset',
    );
    buf.writeln('$colour$_separator$sLine$_reset');

    // Metadata rows
    _writeRow(buf, colour, 'Status   ', '$_yellow${failure.statusCode}$_reset');
    _writeRow(buf, colour, 'Tag      ', '$_cyan$tag$_reset');
    _writeRow(
      buf,
      colour,
      'Time     ',
      '$_dim${DateTime.now().toIso8601String()}$_reset',
    );

    // Exception type
    buf.writeln('$colour$_separator$sLine$_reset');
    final isError = error is Error;
    final exKind = isError
        ? '$_red[Error]$_reset'
        : '$_green[Exception]$_reset';
    _writeRow(buf, colour, 'Kind     ', exKind);
    _writeRow(buf, colour, 'Type     ', '$_white${error.runtimeType}$_reset');

    // Stack trace
    buf.writeln('$colour$_separator$sLine$_reset');
    buf.writeln(
      '$colour$_vertical$_reset  '
      '$_bold$_yellow Stack Trace$_reset',
    );

    final frames = _filterFrames(failure.stackTrace, stackLines);
    if (frames.isEmpty) {
      buf.writeln('$colour$_vertical$_reset    $_dim(unavailable)$_reset');
    } else {
      for (var i = 0; i < frames.length; i++) {
        final index = '$_dim#${i.toString().padRight(3)}$_reset';
        buf.writeln('$colour$_vertical$_reset    $index ${frames[i]}');
      }
    }

    // Bottom border
    buf.write('$colour$_bottomLeft$hLine$_reset');

    _print(
      buf.toString(),
      name: tag,
      error: error,
      stackTrace: failure.stackTrace,
    );
  }

  // Private helpers

  /// Writes a labelled data row:
  /// `║  Label     value`
  static void _writeRow(
    StringBuffer buf,
    String colour,
    String label,
    String value,
  ) {
    buf.writeln(
      '$colour$_vertical$_reset  '
      '$_grey$label$_reset  '
      '$value',
    );
  }

  /// Extracts stack frames, preferring frames from the app's own code.
  ///
  /// Strategy:
  /// 1. Split into non-empty lines.
  /// 2. Try to find frames from your own package (not `package:flutter`,
  ///    `package:dio`, `dart:`, etc.).
  /// 3. If fewer than [limit] app frames exist, fall back to all frames.
  /// 4. Take at most [limit] frames.
  static List<String> _filterFrames(StackTrace? stackTrace, int limit) {
    if (stackTrace == null) return [];

    final all = stackTrace
        .toString()
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (all.isEmpty) return [];

    // Filter out well-known framework/library prefixes to surface app frames.
    const noisePatterns = [
      'package:flutter/',
      'package:dio/',
      'dart:',
      'package:flutter_bloc/',
      'package:bloc/',
    ];

    final appFrames = all
        .where((l) => !noisePatterns.any((p) => l.contains(p)))
        .toList();

    // Use app frames if we have enough; otherwise fall back to all frames.
    final source = appFrames.length >= (limit ~/ 2) ? appFrames : all;
    return source.take(limit).toList();
  }

  /// Returns the ANSI colour that represents [failure]'s category.
  ///
  /// Colour coding lets you spot failure types at a glance without reading
  /// the class name:
  /// - 🔴 Red       → [AuthFailure]
  /// - 🟠 Orange    → [ServerFailure]
  /// - 🟡 Yellow    → [ValidationFailure]
  /// - 🔵 Blue      → [NetworkFailure]
  /// - 🟣 Magenta   → [TimeoutFailure]
  /// - ⚪ White     → [NotFoundFailure]
  /// - 🩶 Grey      → everything else ([UnknownFailure])
  static String _failureColour(ApiFailure failure) => switch (failure) {
    AuthFailure() => _red,
    ServerFailure() => _orange,
    ValidationFailure() => _yellow,
    NetworkFailure() => _blue,
    TimeoutFailure() => _magenta,
    NotFoundFailure() => _white,
    _ => _grey,
  };

  /// Emits [message] in chunks to prevent silent drops by the platform logger.
  static void _print(
    String message, {
    required String name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final rawLines = message.split('\n');
    final chunk = StringBuffer();

    for (final line in rawLines) {
      if (chunk.length + line.length + 1 > _logChunkSize && chunk.isNotEmpty) {
        developer.log(chunk.toString(), name: name);
        chunk.clear();
      }
      chunk.writeln(line);
    }

    if (chunk.isNotEmpty) {
      developer.log(
        chunk.toString(),
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
