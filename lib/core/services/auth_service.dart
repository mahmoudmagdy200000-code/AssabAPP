import 'package:assab/core/utils/app_logger.dart';

import '../di/dependency_injection.dart';
import 'token_storage_service.dart';

class AuthService {
  const AuthService._();

  static bool _isLoggedInVal = false;

  static bool get isLoggedInVal => _isLoggedInVal;

  static Future<void> isLoggedIn() async {
    try {
      final token = await getIt<TokenStorageService>().getAccessToken();
      _isLoggedInVal = token != null && token.isNotEmpty;
    } catch (e) {
      AppLogger.log(e.toString(), tag: 'AuthService.isLoggedIn');
    }
  }

  static Future<void> logout() async {
    await getIt<TokenStorageService>().clearTokens();
    _isLoggedInVal = false;
  }
}
