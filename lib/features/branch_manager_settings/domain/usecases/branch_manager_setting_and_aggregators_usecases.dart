import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../../../../core/utils/future_api_result.dart';
import '../entities/branch_manager_my_account_details_entity.dart';
import '../entities/branch_manager_setting_and_aggregators_entity.dart';
import '../repositories/branch_manager_setting_and_aggregators_repository.dart';

@LazySingleton()
class GetBranchManagerMyAccountDetailsUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  GetBranchManagerMyAccountDetailsUseCase(this._repository);

  FutureApiResult<BranchManagerMyAccountDetailsEntity> call() {
    return _repository.getBranchManagerMyAccountDetails();
  }
}

@LazySingleton()
class GetBranchManagerSettingAndAggregatorsUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  GetBranchManagerSettingAndAggregatorsUseCase(this._repository);

  FutureApiResult<BranchManagerSettingAndAggregatorsEntity> call() {
    return _repository.getBranchManagerSettingAndAggregators();
  }
}

@LazySingleton()
class GetAvailableAggregatorsUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  GetAvailableAggregatorsUseCase(this._repository);

  FutureApiResult<List<BranchManagerAggregatorEntity>> call() {
    return _repository.getAvailableAggregators();
  }
}

@LazySingleton()
class GetBranchAggregatorsUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  GetBranchAggregatorsUseCase(this._repository);

  FutureApiResult<List<BranchManagerAggregatorEntity>> call() {
    return _repository.getBranchAggregators();
  }
}

@LazySingleton()
class AddBranchManagerAggregatorUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  AddBranchManagerAggregatorUseCase(this._repository);

  FutureApiResult<BranchManagerSettingAndAggregatorsEntity> call({
    required String aggregatorId,
  }) async {
    final addResult = await _repository.addAggregator(
      aggregatorId: aggregatorId,
    );
    return addResult.when(
      success: (_) => _repository.getBranchManagerSettingAndAggregators(),
      failure: (failure) => Future.value(ApiResult.failure(failure)),
    );
  }
}

@LazySingleton()
class DeleteBranchManagerAggregatorUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  DeleteBranchManagerAggregatorUseCase(this._repository);

  FutureApiResult<BranchManagerSettingAndAggregatorsEntity> call({
    required String aggregatorId,
  }) async {
    final deleteResult = await _repository.deleteAggregator(
      aggregatorId: aggregatorId,
    );
    return deleteResult.when(
      success: (_) => _repository.getBranchManagerSettingAndAggregators(),
      failure: (failure) => Future.value(ApiResult.failure(failure)),
    );
  }
}

@LazySingleton()
class SetBranchManagerAggregatorStatusUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  SetBranchManagerAggregatorStatusUseCase(this._repository);

  FutureApiResult<BranchManagerSettingAndAggregatorsEntity> call({
    required String aggregatorId,
    required bool enabled,
  }) async {
    final statusResult = await _repository.setAggregatorEnabled(
      aggregatorId: aggregatorId,
      enabled: enabled,
    );
    return statusResult.when(
      success: (_) => _repository.getBranchManagerSettingAndAggregators(),
      failure: (failure) => Future.value(ApiResult.failure(failure)),
    );
  }
}

@LazySingleton()
class UpdateBranchManagerNotificationUseCase {
  final BranchManagerSettingAndAggregatorsRepository _repository;

  UpdateBranchManagerNotificationUseCase(this._repository);

  FutureApiResult<BranchManagerSettingAndAggregatorsEntity> call({
    required BranchManagerNotificationType type,
    required bool enabled,
  }) async {
    final updateResult = switch (type) {
      BranchManagerNotificationType.shiftVarianceAlerts =>
        await _repository.updateShiftVarianceAlerts(enabled: enabled),
      BranchManagerNotificationType.dailyInventoryReminders =>
        await _repository.updateDailyInventoryReminders(enabled: enabled),
      BranchManagerNotificationType.approvedAggregatorsOnly =>
        await _repository.updateApprovedAggregatorsOnly(enabled: enabled),
      BranchManagerNotificationType.assetTransferRequests =>
        await _repository.updateAssetTransferRequests(enabled: enabled),
      BranchManagerNotificationType.allowSplitShiftHandovers =>
        await _repository.updateAllowSplitShiftHandovers(enabled: enabled),
    };

    return updateResult.when(
      success: (_) => _repository.getBranchManagerSettingAndAggregators(),
      failure: (failure) => Future.value(ApiResult.failure(failure)),
    );
  }
}
