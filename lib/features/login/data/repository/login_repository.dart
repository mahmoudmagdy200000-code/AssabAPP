import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/login/data/data_source/login_remote_data_source.dart';
import 'package:assab/features/login/data/models/login_request_model.dart';
import 'package:assab/features/login/domain/entities/login_entity.dart';
import 'package:assab/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl with RepositoryMixin implements LoginRepository {
  final LoginRemoteDataSource _loginRemoteDataSource;

  LoginRepositoryImpl(this._loginRemoteDataSource);

  LoginEntity _mapToEntity(dynamic response) {
    final data = response.data;
    return LoginEntity(
      id: data.user.id,
      name: data.user.name,
      email: data.user.email,
      phone: data.user.phone,
      image: data.user.image,
      createdAt: data.user.createdAt,
      token: data.token,
    );
  }

  @override
  FutureApiResult<LoginEntity> branchManagerLogin({
    required String identifier,
    required String password,
  }) => execute(() async {
    final request = LoginRequestModel(
      identifier: identifier,
      password: password,
    );
    final response = await _loginRemoteDataSource.branchManagerLogin(request);
    return _mapToEntity(response);
  });

  @override
  FutureApiResult<LoginEntity> supplierLogin({
    required String identifier,
    required String password,
  }) => execute(() async {
    final request = LoginRequestModel(
      identifier: identifier,
      password: password,
    );
    final response = await _loginRemoteDataSource.supplierLogin(request);
    return _mapToEntity(response);
  });

  @override
  FutureApiResult<LoginEntity> cashierLogin({
    required String identifier,
    required String password,
  }) => execute(() async {
    final request = LoginRequestModel(
      identifier: identifier,
      password: password,
    );
    final response = await _loginRemoteDataSource.cashierLogin(request);
    return _mapToEntity(response);
  });

  @override
  FutureApiResult<LoginEntity> brandOwnerLogin({
    required String identifier,
    required String password,
  }) => execute(() async {
    final request = LoginRequestModel(
      identifier: identifier,
      password: password,
    );
    final response = await _loginRemoteDataSource.brandOwnerLogin(request);
    return _mapToEntity(response);
  });
}
