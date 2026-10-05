import 'package:assab/core/utils/app_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TokenStorageService {
  final FlutterSecureStorage flutterSecureStorage;

  TokenStorageService(this.flutterSecureStorage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  static const _secureAndroidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static const _secureIOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  Future<void> saveAccessToken(String token) async {
    await flutterSecureStorage.write(
      key: _accessTokenKey,
      value: token,
      aOptions: _secureAndroidOptions,
      iOptions: _secureIOSOptions,
    );
  }

  Future<void> saveRefreshToken(String token) async {
    await flutterSecureStorage.write(
      key: _refreshTokenKey,
      value: token,
      aOptions: _secureAndroidOptions,
      iOptions: _secureIOSOptions,
    );
  }

  Future<String?> getAccessToken() async {
    return await flutterSecureStorage.read(
      key: _accessTokenKey,
      aOptions: _secureAndroidOptions,
      iOptions: _secureIOSOptions,
    );
  }

  Future<String?> getRefreshToken() async {
    return await flutterSecureStorage.read(
      key: _refreshTokenKey,
      aOptions: _secureAndroidOptions,
      iOptions: _secureIOSOptions,
    );
  }

  Future<void> clearTokens() async {
    await Future.wait([
      flutterSecureStorage.delete(
        key: _accessTokenKey,
        aOptions: _secureAndroidOptions,
        iOptions: _secureIOSOptions,
      ),
      flutterSecureStorage.delete(
        key: _refreshTokenKey,
        aOptions: _secureAndroidOptions,
        iOptions: _secureIOSOptions,
      ),
    ]);

    AppLogger.log('Tokens cleared from secure storage');
  }

  Future<void> deleteAll() async {
    await flutterSecureStorage.deleteAll(
      aOptions: _secureAndroidOptions,
      iOptions: _secureIOSOptions,
    );
  }
}
