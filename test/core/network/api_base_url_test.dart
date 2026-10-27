import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/core/network/dio_client.dart';
import 'package:assab/features/active_account/data/data_source/active_account_remote_data_source.dart';
import 'package:assab/features/login/data/data_source/login_remote_data_source.dart';
import 'package:assab/features/login/data/models/login_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _CaptureAdapter implements HttpClientAdapter {
  Uri? lastUri;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastUri = options.uri;
    return ResponseBody.fromString(
      jsonEncode({
        'success': true,
        'message': 'OK',
        'data': {
          'token': 'test-token',
          'user': {
            'id': '1',
            'name': 'Test User',
            'email': 'test@fixture.invalid',
          },
        },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const stagingBaseUrl =
      'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/api/v1/';

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

    test(
      'Legacy Hostinger production host is strictly forbidden in both demo and full-app builds',
      () {
        for (final demoMode in [true, false]) {
          expect(
            () => ApiEndpoint.normalizeBaseUrl(
              'https://ivory-snail-183262.hostingersite.com/api/v1/',
              demo: demoMode,
            ),
            throwsA(isA<StateError>()),
          );

          expect(
            () => ApiEndpoint.normalizeBaseUrl(
              'https://other.hostingersite.com',
              demo: demoMode,
            ),
            throwsA(isA<StateError>()),
          );
        }
      },
    );

    test('Normalizes base URL to end with /api/v1/ including Coolify staging', () {
      expect(
        ApiEndpoint.normalizeBaseUrl('http://127.0.0.1:8000', demo: false),
        equals('http://127.0.0.1:8000/api/v1/'),
      );
      expect(
        ApiEndpoint.normalizeBaseUrl('http://127.0.0.1:8000/', demo: false),
        equals('http://127.0.0.1:8000/api/v1/'),
      );
      expect(
        ApiEndpoint.normalizeBaseUrl('http://127.0.0.1:8000/api', demo: false),
        equals('http://127.0.0.1:8000/api/v1/'),
      );
      expect(
        ApiEndpoint.normalizeBaseUrl(
          'http://127.0.0.1:8000/api/v1',
          demo: false,
        ),
        equals('http://127.0.0.1:8000/api/v1/'),
      );
      expect(
        ApiEndpoint.normalizeBaseUrl(
          'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io',
          demo: false,
        ),
        equals(stagingBaseUrl),
      );
      expect(
        ApiEndpoint.normalizeBaseUrl(stagingBaseUrl, demo: false),
        equals(stagingBaseUrl),
      );
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
      expect(
        ApiEndpoint.derivePusherAuthUrl(stagingBaseUrl),
        equals(
          'https://szkrjqiuo9s6d6nsy5fldc0j.62.72.19.141.sslip.io/broadcasting/auth',
        ),
      );
    });

    test(
      'Retrofit LoginRemoteDataSource and ActiveAccountRemoteDataSource inherit staging Dio baseUrl with no Hostinger fallback',
      () async {
        final dio = DioClient.create(customBaseUrl: stagingBaseUrl);
        dio.interceptors.clear();
        final adapter = _CaptureAdapter();
        dio.httpClientAdapter = adapter;

        final loginDs = LoginRemoteDataSource(dio);
        await loginDs.branchManagerLogin(
          LoginRequestModel(
            identifier: 'assab-ui-qa-20261018.branch-manager@fixture.invalid',
            password: 'secret',
          ),
        );
        expect(
          adapter.lastUri.toString(),
          equals('${stagingBaseUrl}branch-manager/auth/login'),
        );
        expect(adapter.lastUri!.host, isNot(contains('hostingersite.com')));

        final activeDs = ActiveAccountRemoteDataSource(dio);
        expect(activeDs, isNotNull);
      },
    );

    test(
      'Auth and profile endpoint constants align with Laravel api_v1 routes without double slashes',
      () {
        final endpoints = [
          ApiEndpoint.branchManagerLogin,
          ApiEndpoint.branchManagerLogout,
          ApiEndpoint.branchManagerMe,
          ApiEndpoint.branchManagerFirstLogin,
          ApiEndpoint.branchManagerResetPasswordFirstLogin,
          ApiEndpoint.cashierLogin,
          ApiEndpoint.cashierLogout,
          ApiEndpoint.cashierMe,
          ApiEndpoint.cashierFirstLogin,
          ApiEndpoint.cashierResetPasswordFirstLogin,
          ApiEndpoint.supplierLogin,
          ApiEndpoint.supplierLogout,
          ApiEndpoint.supplierMe,
          ApiEndpoint.supplierActiveAccount,
          ApiEndpoint.supplierResetPasswordFirstLogin,
          ApiEndpoint.brandOwnerLogin,
          ApiEndpoint.brandOwnerLogout,
          ApiEndpoint.brandOwnerMe,
          ApiEndpoint.brandOwnerFirstLogin,
          ApiEndpoint.brandOwnerResetPasswordFirstLogin,
        ];

        for (final ep in endpoints) {
          expect(ep.contains('//'), isFalse, reason: 'Duplicate slash in $ep');
        }

        expect(ApiEndpoint.cashierLogout, equals('cashier/logout'));
        expect(ApiEndpoint.cashierMe, equals('cashier/profile'));
        expect(ApiEndpoint.supplierLogout, equals('supplier/auth/logout'));
        expect(ApiEndpoint.brandOwnerLogout, equals('brand-owner/auth/logout'));
      },
    );
  });
}
