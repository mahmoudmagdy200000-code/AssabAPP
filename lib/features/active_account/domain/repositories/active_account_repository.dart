import '../../../../core/utils/future_api_result.dart';
import '../../../../shared/models/login_model/login_response_model.dart';

abstract class ActiveAccountRepository {
  FutureApiResult<LoginResponseModel> firstLogin({
    required String email,
    required String password,
  });

  FutureApiResult<void> resetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  });

  FutureApiResult<LoginResponseModel> supplierFirstLogin({
    required String email,
    required String password,
  });

  FutureApiResult<void> supplierResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  });

  FutureApiResult<LoginResponseModel> brandOwnerFirstLogin({
    required String email,
    required String password,
  });

  FutureApiResult<void> brandOwnerResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  });

  FutureApiResult<LoginResponseModel> cashierFirstLogin({
    required String email,
    required String password,
  });

  FutureApiResult<void> cashierResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  });
}
