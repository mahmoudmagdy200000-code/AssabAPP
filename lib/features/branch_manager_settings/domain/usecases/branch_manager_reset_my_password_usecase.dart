import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../repositories/branch_manager_reset_my_password_repository.dart';

@LazySingleton()
class BranchManagerResetMyPasswordUseCase {
  final BranchManagerResetMyPasswordRepository _repository;

  BranchManagerResetMyPasswordUseCase(this._repository);

  FutureApiResult<void> call({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return _repository.resetMyPassword(
      oldPassword: oldPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}