import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../../../shared/models/login_model/login_response_model.dart';
import '../repositories/active_account_repository.dart';

@LazySingleton()
class FirstLoginUseCase {
  final ActiveAccountRepository _repository;

  FirstLoginUseCase(this._repository);

  FutureApiResult<LoginResponseModel> call({
    required String email,
    required String password,
  }) {
    return _repository.firstLogin(email: email, password: password);
  }

  FutureApiResult<LoginResponseModel> supplier({
    required String email,
    required String password,
  }) {
    return _repository.supplierFirstLogin(email: email, password: password);
  }

  FutureApiResult<LoginResponseModel> brandOwner({
    required String email,
    required String password,
  }) {
    return _repository.brandOwnerFirstLogin(email: email, password: password);
  }
}
