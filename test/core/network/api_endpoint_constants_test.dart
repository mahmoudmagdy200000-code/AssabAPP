import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FL-03: No ApiEndpoint string constant contains double slash', () {
    final file = File('lib/core/network/api_endpoints.dart');
    expect(file.existsSync(), isTrue, reason: 'api_endpoints.dart must exist');

    final content = file.readAsStringSync();
    final normalized = content.replaceAll('\r\n', '\n').replaceAll(RegExp(r'\n\s+'), ' ');

    final regex = RegExp(r"static const String (\w+)\s*=\s*[']([^;]+)['];");
    final map = <String, String>{};

    for (final m in regex.allMatches(normalized)) {
      final key = m.group(1)!;
      var raw = m.group(2)!.trim();
      if (raw.endsWith("'")) {
        raw = raw.substring(0, raw.length - 1);
      }
      map[key] = raw;
    }

    expect(map.length, greaterThan(100), reason: 'Expected to find over 100 endpoint constants');

    // Resolve variable interpolations iteratively
    for (var i = 0; i < 15; i++) {
      for (final entry in map.entries.toList()) {
        var val = entry.value;
        for (final r in map.entries) {
          val = val.replaceAll('\$${r.key}', r.value);
          val = val.replaceAll('\${${r.key}}', r.value);
        }
        map[entry.key] = val;
      }
    }

    final violations = <String, String>{};
    for (final entry in map.entries) {
      final cleaned = entry.value.replaceAll(RegExp(r'https?:\/\/'), '');
      if (cleaned.contains('//')) {
        violations[entry.key] = entry.value;
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Endpoint constants must not contain consecutive slashes (//): $violations',
    );
  });
}
