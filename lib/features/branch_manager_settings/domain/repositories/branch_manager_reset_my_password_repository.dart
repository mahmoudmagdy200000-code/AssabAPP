import '../../../../core/utils/future_api_result.dart';

abstract class BranchManagerResetMyPasswordRepository {
  FutureApiResult<void> resetMyPassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  });
}