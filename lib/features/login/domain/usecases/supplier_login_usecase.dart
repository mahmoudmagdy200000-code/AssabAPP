import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../entities/login_entity.dart';
import '../repositories/login_repository.dart';

@LazySingleton()
class SupplierLoginUseCase {
  final LoginRepository _repository;

  SupplierLoginUseCase(this._repository);

  FutureApiResult<LoginEntity> call({
    required String identifier,
    required String password,
  }) {
    return _repository.supplierLogin(
      identifier: identifier,
      password: password,
    );
  }
}
