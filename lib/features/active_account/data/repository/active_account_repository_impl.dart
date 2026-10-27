import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../../../shared/models/login_model/login_response_model.dart';
import '../../domain/repositories/active_account_repository.dart';
import '../data_source/active_account_remote_data_source.dart';
import '../models/first_login_request_model.dart';
import '../models/reset_password_activation_account_request_model.dart';

@LazySingleton(as: ActiveAccountRepository)
class ActiveAccountRepositoryImpl
    with RepositoryMixin
    implements ActiveAccountRepository {
  final ActiveAccountRemoteDataSource _activeAccountRemoteDataSource;

  ActiveAccountRepositoryImpl(this._activeAccountRemoteDataSource);

  @override
  FutureApiResult<LoginResponseModel> firstLogin({
    required String email,
    required String password,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.firstLogin(
      FirstLoginRequestModel(email: email, password: password),
    );
  });

  @override
  FutureApiResult<void> resetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.resetPasswordFirstLogin(
      ResetPasswordActivationAccountRequestModel(
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  });

  @override
  FutureApiResult<LoginResponseModel> supplierFirstLogin({
    required String email,
    required String password,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.supplierFirstLogin(
      FirstLoginRequestModel(email: email, password: password),
    );
  });

  @override
  FutureApiResult<void> supplierResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.supplierResetPasswordFirstLogin(
      ResetPasswordActivationAccountRequestModel(
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  });

  @override
  FutureApiResult<LoginResponseModel> brandOwnerFirstLogin({
    required String email,
    required String password,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.brandOwnerFirstLogin(
      FirstLoginRequestModel(email: email, password: password),
    );
  });

  @override
  FutureApiResult<void> brandOwnerResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.brandOwnerResetPasswordFirstLogin(
      ResetPasswordActivationAccountRequestModel(
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  });

  @override
  FutureApiResult<LoginResponseModel> cashierFirstLogin({
    required String email,
    required String password,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.cashierFirstLogin(
      FirstLoginRequestModel(email: email, password: password),
    );
  });

  @override
  FutureApiResult<void> cashierResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) => execute(() async {
    return _activeAccountRemoteDataSource.cashierResetPasswordFirstLogin(
      ResetPasswordActivationAccountRequestModel(
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  });
}
