import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../datasources/cashier_home_remote_data_source.dart';
import '../models/cashier_branch_info_response.dart';
import '../models/cashier_info_response.dart';
import '../models/cashier_tasks_response.dart';

@LazySingleton()
class CashierHomeRepository with RepositoryMixin {
  final CashierHomeRemoteDataSource _remoteDataSource;

  CashierHomeRepository(this._remoteDataSource);

  FutureApiResult<CashierTasksResponse> getInventoryTasks() =>
      execute(() async => _remoteDataSource.getInventoryTasks());

  FutureApiResult<CashierBranchInfoResponse> getBranchInfo() =>
      execute(() async => _remoteDataSource.getBranchInfo());

  FutureApiResult<CashierInfoResponse> getCashierInfo() =>
      execute(() async => _remoteDataSource.getCashierInfo());
}
