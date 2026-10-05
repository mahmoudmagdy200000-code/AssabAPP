import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../repositories/active_account_repository.dart';

@LazySingleton()
class ResetPasswordFirstLoginUseCase {
  final ActiveAccountRepository _repository;

  ResetPasswordFirstLoginUseCase(this._repository);

  FutureApiResult<void> call({
    required String password,
    required String passwordConfirmation,
  }) {
    return _repository.resetPasswordFirstLogin(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  FutureApiResult<void> supplier({
    required String password,
    required String passwordConfirmation,
  }) {
    return _repository.supplierResetPasswordFirstLogin(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  FutureApiResult<void> brandOwner({
    required String password,
    required String passwordConfirmation,
  }) {
    return _repository.brandOwnerResetPasswordFirstLogin(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
