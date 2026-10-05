import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../entities/login_entity.dart';
import '../repositories/login_repository.dart';

@LazySingleton()
class CashierLoginUseCase {
  final LoginRepository _repository;

  CashierLoginUseCase(this._repository);

  FutureApiResult<LoginEntity> call({
    required String identifier,
    required String password,
  }) {
    return _repository.cashierLogin(
      identifier: identifier,
      password: password,
    );
  }
}
