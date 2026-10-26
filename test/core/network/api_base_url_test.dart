import 'package:assab/core/network/api_endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiEndpoint URL validation and normalization tests', () {
    test('Empty URL fails closed with StateError', () {
      expect(
        () => ApiEndpoint.normalizeBaseUrl(''),
        throwsA(isA<StateError>()),
      );
      expect(
        () => ApiEndpoint.normalizeBaseUrl('   '),
        throwsA(isA<StateError>()),
      );
    });

    test('Invalid scheme throws FormatException', () {
      expect(
        () => ApiEndpoint.normalizeBaseUrl('ftp://example.com/api/v1'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => ApiEndpoint.normalizeBaseUrl('not-a-url'),
        throwsA(isA<FormatException>()),
      );
    });

    test('Hostinger production host is strictly forbidden in demo mode', () {
      expect(
        () => ApiEndpoint.normalizeBaseUrl(
          'https://ivory-snail-183262.hostingersite.com/api/v1/',
          demo: true,
        ),
        throwsA(isA<StateError>()),
      );

      expect(
        () => ApiEndpoint.normalizeBaseUrl(
          'https://other.hostingersite.com',
          demo: true,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('Normalizes base URL to end with /api/v1/', () {
      final url1 = ApiEndpoint.normalizeBaseUrl(
        'http://127.0.0.1:8000',
        demo: false,
      );
      expect(url1, equals('http://127.0.0.1:8000/api/v1/'));

      final url2 = ApiEndpoint.normalizeBaseUrl(
        'http://127.0.0.1:8000/',
        demo: false,
      );
      expect(url2, equals('http://127.0.0.1:8000/api/v1/'));

      final url3 = ApiEndpoint.normalizeBaseUrl(
        'http://127.0.0.1:8000/api',
        demo: false,
      );
      expect(url3, equals('http://127.0.0.1:8000/api/v1/'));

      final url4 = ApiEndpoint.normalizeBaseUrl(
        'http://127.0.0.1:8000/api/v1',
        demo: false,
      );
      expect(url4, equals('http://127.0.0.1:8000/api/v1/'));

      final url5 = ApiEndpoint.normalizeBaseUrl(
        'http://127.0.0.1:8000/api/v1/',
        demo: false,
      );
      expect(url5, equals('http://127.0.0.1:8000/api/v1/'));

      final stagingUrl = ApiEndpoint.normalizeBaseUrl(
        'https://staging-api.assab.local',
        demo: true,
      );
      expect(stagingUrl, equals('https://staging-api.assab.local/api/v1/'));
    });

    test(
      'Rejects hostless URLs, embedded credentials, queries and fragments',
      () {
        for (final url in [
          'http:///api/v1',
          'https://user:pass@example.com',
          'https://example.com?token=x',
          'https://example.com#x',
        ]) {
          expect(
            () => ApiEndpoint.normalizeBaseUrl(url),
            throwsFormatException,
          );
        }
      },
    );

    test('derivePusherAuthUrl derives /broadcasting/auth endpoint', () {
      final authUrl = ApiEndpoint.derivePusherAuthUrl(
        'http://127.0.0.1:8000/api/v1/',
      );
      expect(authUrl, equals('http://127.0.0.1:8000/broadcasting/auth'));

      final authUrlHttps = ApiEndpoint.derivePusherAuthUrl(
        'https://staging.assab.com/api/v1/',
      );
      expect(
        authUrlHttps,
        equals('https://staging.assab.com/broadcasting/auth'),
      );
    });
  });
}
