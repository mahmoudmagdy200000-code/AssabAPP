import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/core/services/realtime_service/realtime_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

import '../di/dependency_injection.dart';
import 'token_storage_service.dart';

class AuthService {
  const AuthService._();

  static bool _isLoggedInVal = false;

  static bool get isLoggedInVal => _isLoggedInVal;

  static void markLoggedIn() {
    _isLoggedInVal = true;
  }

  static String? logoutEndpointForRole(UserType? userType) {
    return switch (userType) {
      UserType.branchManager => ApiEndpoint.branchManagerLogout,
      UserType.cashier => ApiEndpoint.cashierLogout,
      UserType.supplier => ApiEndpoint.supplierLogout,
      UserType.brandOwner => ApiEndpoint.brandOwnerLogout,
      null => null,
    };
  }

  static Future<void> isLoggedIn() async {
    try {
      final token = await getIt<TokenStorageService>().getAccessToken();
      _isLoggedInVal = token != null && token.isNotEmpty;
    } catch (e) {
      AppLogger.log(e.toString(), tag: 'AuthService.isLoggedIn');
    }
  }

  static Future<void> logout({bool revokeRemote = true}) async {
    final activeUserType =
        UserTypeService.selectedUserType ?? UserTypeService.getSavedUserType();
    final logoutEndpoint = logoutEndpointForRole(activeUserType);

    if (revokeRemote &&
        logoutEndpoint != null &&
        getIt.isRegistered<TokenStorageService>() &&
        getIt.isRegistered<Dio>()) {
      try {
        final token = await getIt<TokenStorageService>().getAccessToken();
        if (token != null && token.isNotEmpty) {
          await getIt<Dio>().post<dynamic>(
            logoutEndpoint,
            options: Options(
              extra: const {'skipAuthInterceptor': true},
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        AppLogger.log(
          'Remote token revocation ignored during logout ($logoutEndpoint): $e',
          tag: 'AuthService.logout',
        );
      }
    }

    if (getIt.isRegistered<RealtimeService>()) {
      try {
        await getIt<RealtimeService>().disconnect();
      } catch (e) {
        AppLogger.log(
          'Realtime disconnect ignored during logout: $e',
          tag: 'AuthService.logout',
        );
      }
    }

    if (getIt.isRegistered<TokenStorageService>()) {
      await getIt<TokenStorageService>().clearTokens();
    }

    if (getIt.isRegistered<SharedPreferencesHelper>()) {
      final prefs = getIt<SharedPreferencesHelper>();
      await Future.wait([
        prefs.remove('u_name'),
        prefs.remove('u_id'),
      ]);
    }

    await UserTypeService.clearUserType();
    _isLoggedInVal = false;
  }
}
