import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../entities/login_entity.dart';
import '../repositories/login_repository.dart';

@LazySingleton()
class BrandOwnerLoginUseCase {
  final LoginRepository _repository;

  BrandOwnerLoginUseCase(this._repository);

  FutureApiResult<LoginEntity> call({
    required String identifier,
    required String password,
  }) {
    return _repository.brandOwnerLogin(
      identifier: identifier,
      password: password,
    );
  }
}
