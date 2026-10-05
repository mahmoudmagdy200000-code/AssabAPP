import 'package:assab/features/branch_manager_settings/data/datasources/branch_manager_setting_and_aggregators_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../../reset_password/data/models/branch_manager_reset_my_password_request_model.dart';
import '../../domain/repositories/branch_manager_reset_my_password_repository.dart';

@LazySingleton(as: BranchManagerResetMyPasswordRepository)
class BranchManagerResetMyPasswordRepositoryImpl
    with RepositoryMixin
    implements BranchManagerResetMyPasswordRepository {
  final BranchManagerSettingAndAggregatorsRemoteDataSource _remote;
  BranchManagerResetMyPasswordRepositoryImpl(this._remote);

  @override
  FutureApiResult<void> resetMyPassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return execute(() async {
      await Future.delayed(const Duration(seconds: 1));
      return await _remote.resetPassword(
        BranchManagerResetMyPasswordRequestModel(
          oldPassword: oldPassword,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ).toJson(),
      );
    });
  }
}
