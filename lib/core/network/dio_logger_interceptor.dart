import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_request_timing_interceptor.dart';

class DioLoggerInterceptor extends Interceptor {
  final bool logRequest;
  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponse;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final bool logError;
  final bool useAnsiColors;
  final int boxWidth;

  final void Function(String message, {String name})? logger;

  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _dim = '\x1B[2m';
  static const _cyan = '\x1B[96m';
  static const _green = '\x1B[92m';
  static const _yellow = '\x1B[93m';
  static const _red = '\x1B[91m';
  static const _magenta = '\x1B[95m';
  static const _blue = '\x1B[94m';
  static const _white = '\x1B[97m';
  static const _grey = '\x1B[90m';

  static const _topLeft = '╔';
  static const _bottomLeft = '╚';
  static const _horizontal = '═';
  static const _vertical = '║';
  static const _separator = '╟';
  static const _separatorLine = '─';

  DioLoggerInterceptor({
    this.logRequest = true,
    this.logRequestHeaders = true,
    this.logRequestBody = true,
    this.logResponse = true,
    this.logResponseHeaders = false,
    this.logResponseBody = true,
    this.logError = true,
    // Android Studio Logcat does NOT render ANSI codes — they show as raw
    // text like "[96m".  Default to false so output is clean everywhere.
    // Set to true only when running in a terminal that supports ANSI
    // (e.g. `flutter run` in a proper shell, or VS Code's debug console
    // with an ANSI-aware extension installed).
    this.useAnsiColors = false,
    int boxWidth = 80,
    this.logger,
  }) : boxWidth = boxWidth < 20 ? 20 : boxWidth;

  static List<Interceptor> createInterceptors({
    bool logRequest = true,
    bool logRequestHeaders = true,
    bool logRequestBody = true,
    bool logResponse = true,
    bool logResponseHeaders = false,
    bool logResponseBody = true,
    bool logError = true,
    bool useAnsiColors = false, // same default as constructor
    int boxWidth = 80,
    void Function(String message, {String name})? logger,
  }) {
    return [
      DioRequestTimingInterceptor(),
      DioLoggerInterceptor(
        logRequest: logRequest,
        logRequestHeaders: logRequestHeaders,
        logRequestBody: logRequestBody,
        logResponse: logResponse,
        logResponseHeaders: logResponseHeaders,
        logResponseBody: logResponseBody,
        logError: logError,
        useAnsiColors: useAnsiColors,
        boxWidth: boxWidth,
        logger: logger,
      ),
    ];
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode && logRequest) _logRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode && logResponse) _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode && logError) _logError(err);
    handler.next(err);
  }

  // ─── FIX 2 ───────────────────────────────────────────────────────────────
  // Strip ANSI codes when useAnsiColors == false so IDEs that don't support
  // them (IntelliJ without the "Grep Console" plugin, plain terminal, etc.)
  // don't show garbage escape characters like "[96m" in the output.
  // ─────────────────────────────────────────────────────────────────────────
  static final _ansiStripRe = RegExp(r'\x1B\[[0-9;]*m');

  String _sanitize(String raw) =>
      useAnsiColors ? raw : raw.replaceAll(_ansiStripRe, '');

  void _logRequest(RequestOptions options) {
    final buf = StringBuffer();
    final method = options.method.toUpperCase();
    final hLine = _horizontal * boxWidth;
    final sLine = _separatorLine * boxWidth;

    _writeTopBorder(buf, ' [DIO REQUEST] ', _cyan);
    buf.writeln(
      '${_c(_cyan)}$_vertical${_c(_reset)}  '
      '${_c(_bold)}${_c(_methodColour(method))}$method${_c(_reset)}'
      '${_c(_grey)}  →  ${_c(_reset)}'
      '${_c(_white)}${options.uri}${_c(_reset)}'
      '${_c(_grey)}  [${_timestamp()}]${_c(_reset)}',
    );
    buf.writeln('${_c(_cyan)}$_separator$sLine${_c(_reset)}');

    _writeRow(
      buf,
      _cyan,
      'Base URL',
      '${_c(_dim)}${options.baseUrl}${_c(_reset)}',
    );
    _writeRow(
      buf,
      _cyan,
      'Path    ',
      '${_c(_dim)}${options.path}${_c(_reset)}',
    );

    if (options.queryParameters.isNotEmpty) {
      _writeSectionHeader(buf, _cyan, sLine, 'Query Params');
      options.queryParameters.forEach((k, v) => _writeKV(buf, _cyan, k, '$v'));
    }

    if (logRequestHeaders && options.headers.isNotEmpty) {
      _writeSectionHeader(buf, _cyan, sLine, 'Request Headers');
      options.headers.forEach((k, v) {
        _writeKV(buf, _cyan, k, _redactSensitiveHeader(k, v.toString()));
      });
    }

    if (logRequestBody && options.data != null) {
      _writeSectionHeader(buf, _cyan, sLine, 'Request Body');
      _writeBodyLines(buf, _cyan, _formatBody(options.data));
    }

    buf.write('${_c(_cyan)}$_bottomLeft$hLine${_c(_reset)}');
    _print(buf.toString(), name: 'DIO REQUEST');
  }

  void _logResponse(Response response) {
    final buf = StringBuffer();
    final status = response.statusCode ?? 0;
    final method = response.requestOptions.method.toUpperCase();
    final hLine = _horizontal * boxWidth;
    final sLine = _separatorLine * boxWidth;

    _writeTopBorder(buf, ' [DIO RESPONSE] ', _green);
    buf.writeln(
      '${_c(_green)}$_vertical${_c(_reset)}  '
      '${_c(_statusColour(status))}${_c(_bold)}$status ${_statusText(status)}${_c(_reset)}'
      '${_c(_grey)}  ←  ${_c(_reset)}'
      '${_c(_bold)}${_c(_methodColour(method))}$method${_c(_reset)}'
      '${_c(_grey)}  ${response.requestOptions.uri}  [${_timestamp()}]${_c(_reset)}',
    );
    buf.writeln('${_c(_green)}$_separator$sLine${_c(_reset)}');

    _writeRow(
      buf,
      _green,
      'Duration',
      '${_c(_yellow)}${_duration(response.requestOptions)}${_c(_reset)}',
    );
    _writeRow(
      buf,
      _green,
      'Size    ',
      '${_c(_magenta)}${_payloadSize(response.data)}${_c(_reset)}',
    );

    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      _writeSectionHeader(buf, _green, sLine, 'Response Headers');
      response.headers.map.forEach((k, values) {
        _writeKV(buf, _green, k, values.join(', '));
      });
    }

    if (logResponseBody && response.data != null) {
      _writeSectionHeader(buf, _green, sLine, 'Response Body');
      _writeBodyLines(buf, _green, _formatBody(response.data));
    }

    buf.write('${_c(_green)}$_bottomLeft$hLine${_c(_reset)}');
    _print(buf.toString(), name: 'DIO RESPONSE');
  }

  void _logError(DioException err) {
    final buf = StringBuffer();
    final status = err.response?.statusCode;
    final method = err.requestOptions.method.toUpperCase();
    final hLine = _horizontal * boxWidth;
    final sLine = _separatorLine * boxWidth;

    _writeTopBorder(buf, ' [DIO ERROR] ', _red);
    buf.writeln(
      '${_c(_red)}$_vertical${_c(_reset)}  '
      '${_c(_bold)}${_c(_red)}✕ ${err.type.name}${_c(_reset)}'
      '${_c(_grey)}  [${_timestamp()}]${_c(_reset)}',
    );
    buf.writeln('${_c(_red)}$_separator$sLine${_c(_reset)}');

    _writeRow(
      buf,
      _red,
      'Method  ',
      '${_c(_bold)}${_c(_methodColour(method))}$method${_c(_reset)}',
    );
    _writeRow(
      buf,
      _red,
      'URL     ',
      '${_c(_white)}${err.requestOptions.uri}${_c(_reset)}',
    );
    _writeRow(
      buf,
      _red,
      'Duration',
      '${_c(_yellow)}${_duration(err.requestOptions)}${_c(_reset)}',
    );

    if (status != null) {
      _writeRow(
        buf,
        _red,
        'Status  ',
        '${_c(_statusColour(status))}${_c(_bold)}$status ${_statusText(status)}${_c(_reset)}',
      );
    }

    if (logRequestBody && err.requestOptions.data != null) {
      _writeSectionHeader(buf, _red, sLine, 'Request Body (sent)');
      _writeBodyLines(buf, _red, _formatBody(err.requestOptions.data));
    }

    if (err.message != null) {
      _writeSectionHeader(buf, _red, sLine, 'Message');
      buf.writeln(
        '${_c(_red)}$_vertical${_c(_reset)}    ${_c(_red)}${err.message}${_c(_reset)}',
      );
    }

    if (err.response?.data != null) {
      _writeSectionHeader(buf, _red, sLine, 'Error Body');
      _writeBodyLines(buf, _red, _formatBody(err.response!.data));
    }

    buf.write('${_c(_red)}$_bottomLeft$hLine${_c(_reset)}');
    _print(buf.toString(), name: 'DIO ERROR');
  }

  void _writeTopBorder(StringBuffer buf, String label, String colour) {
    final fill = _horizontal * (boxWidth - 2 - label.length);
    buf.writeln(
      '${_c(colour)}$_topLeft${_c(_bold)}'
      '${_horizontal * 2}$label$fill'
      '${_c(_reset)}',
    );
  }

  void _writeRow(StringBuffer buf, String colour, String label, String value) {
    buf.writeln(
      '${_c(colour)}$_vertical${_c(_reset)}  '
      '${_c(_grey)}$label  ${_c(_reset)}'
      '$value',
    );
  }

  void _writeSectionHeader(
    StringBuffer buf,
    String colour,
    String sLine,
    String title,
  ) {
    buf.writeln('${_c(colour)}$_separator$sLine${_c(_reset)}');
    buf.writeln(
      '${_c(colour)}$_vertical${_c(_reset)}  '
      '${_c(_bold)}${_c(_yellow)}$title${_c(_reset)}',
    );
  }

  /// Writes each line of [body] without a border prefix so the JSON
  /// can be selected and copied cleanly.
  void _writeBodyLines(StringBuffer buf, String colour, String body) {
    for (final line in body.split('\n')) {
      buf.writeln('    $line');
    }
  }

  void _writeKV(StringBuffer buf, String colour, String key, String value) {
    buf.writeln(
      '${_c(colour)}$_vertical${_c(_reset)}    '
      '${_c(_blue)}$key${_c(_reset)}: ${_c(_white)}$value${_c(_reset)}',
    );
  }

  String _c(String code) => useAnsiColors ? code : '';

  void _print(String message, {required String name}) {
    // Sanitize once (strips ANSI when useAnsiColors == false).
    final sanitized = _sanitize(message);

    if (logger != null) {
      logger!(sanitized, name: name);
      return;
    }

    // Android logcat prepends "[<name>]" before EVERY developer.log() call.
    // Splitting into multiple calls means "[DIO RESPONSE]" (or "[log]" for
    // empty-name chunks) appears randomly mid-output.
    //
    // Solution: one single developer.log() call with the full message.
    // To keep every line visually aligned under the name tag we manually
    // prefix continuation lines with spaces equal to "[<name>] ".length so
    // the box drawing characters line up in the logcat panel.
    final indent = ' ' * ('[$name] '.length);
    final lines = sanitized.split('\n');
    final aligned = StringBuffer();
    for (var i = 0; i < lines.length; i++) {
      if (i == 0) {
        aligned.write(lines[i]);
      } else {
        aligned.write('\n$indent${lines[i]}');
      }
    }
    developer.log(aligned.toString(), name: name);
  }

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
  }

  String _duration(RequestOptions options) {
    final start =
        options.extra[DioRequestTimingInterceptor.extraKey] as DateTime?;
    if (start == null) {
      return 'unknown — add DioRequestTimingInterceptor first';
    }
    final ms = DateTime.now().difference(start).inMilliseconds;
    return ms < 1000 ? '${ms}ms' : '${(ms / 1000).toStringAsFixed(2)}s';
  }

  String _payloadSize(dynamic data) {
    if (data == null) return '—';
    if (data is FormData) {
      final f = data.fields.length;
      final fi = data.files.length;
      return 'FormData ($f field${f == 1 ? '' : 's'}, $fi file${fi == 1 ? '' : 's'})';
    }
    try {
      final normalized = data is String ? jsonDecode(data) : data;
      return _formatBytes(utf8.encode(jsonEncode(normalized)).length);
    } catch (_) {
      return _formatBytes(utf8.encode(data.toString()).length);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(2)} MB';
  }

  String _formatBody(dynamic data) {
    if (data == null) return 'null';

    if (data is FormData) {
      final buf = StringBuffer('FormData:');
      if (data.fields.isNotEmpty) {
        buf.write('\n  Fields:');
        for (final e in data.fields) {
          buf.write('\n    ${e.key}: ${e.value}');
        }
      }
      if (data.files.isNotEmpty) {
        buf.write('\n  Files:');
        for (final e in data.files) {
          buf.write(
            '\n    ${e.key}: [file] ${e.value.filename ?? '<unnamed>'} '
            '(${e.value.contentType ?? 'unknown'})',
          );
        }
      }
      return buf.toString();
    }

    try {
      final normalized = data is String ? jsonDecode(data) : data;
      return const JsonEncoder.withIndent('  ').convert(normalized);
    } catch (_) {
      return data.toString();
    }
  }

  String _methodColour(String method) => switch (method) {
    'GET' => _cyan,
    'POST' => _magenta,
    'PUT' => _yellow,
    'PATCH' => _blue,
    'DELETE' => _red,
    'HEAD' => _green,
    _ => _white,
  };

  String _statusColour(int status) {
    if (status < 300) return _green;
    if (status < 400) return _yellow;
    if (status < 500) return _magenta;
    return _red;
  }

  String _statusText(int status) => switch (status) {
    200 => 'OK',
    201 => 'Created',
    204 => 'No Content',
    206 => 'Partial Content',
    301 => 'Moved Permanently',
    302 => 'Found',
    304 => 'Not Modified',
    400 => 'Bad Request',
    401 => 'Unauthorized',
    403 => 'Forbidden',
    404 => 'Not Found',
    405 => 'Method Not Allowed',
    408 => 'Request Timeout',
    409 => 'Conflict',
    410 => 'Gone',
    422 => 'Unprocessable Entity',
    429 => 'Too Many Requests',
    451 => 'Unavailable For Legal Reasons',
    500 => 'Internal Server Error',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Timeout',
    _ => 'Unknown',
  };

  String _redactSensitiveHeader(String key, String value) {
    return value;
  }
}
