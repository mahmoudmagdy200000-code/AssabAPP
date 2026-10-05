import '../../../../core/utils/future_api_result.dart';
import '../entities/login_entity.dart';

abstract class LoginRepository {
  FutureApiResult<LoginEntity> branchManagerLogin({
    required String identifier,
    required String password,
  });

  FutureApiResult<LoginEntity> supplierLogin({
    required String identifier,
    required String password,
  });

  FutureApiResult<LoginEntity> cashierLogin({
    required String identifier,
    required String password,
  });

  FutureApiResult<LoginEntity> brandOwnerLogin({
    required String identifier,
    required String password,
  });
}
