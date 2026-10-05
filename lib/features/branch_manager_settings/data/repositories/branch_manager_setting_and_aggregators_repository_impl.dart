import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/branch_manager_my_account_details_entity.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import '../../domain/repositories/branch_manager_setting_and_aggregators_repository.dart';
import '../datasources/branch_manager_setting_and_aggregators_remote_data_source.dart';
import '../models/branch_manager_setting_and_aggregators_models.dart';

@LazySingleton(as: BranchManagerSettingAndAggregatorsRepository)
class BranchManagerSettingAndAggregatorsRepositoryImpl
    with RepositoryMixin
    implements BranchManagerSettingAndAggregatorsRepository {
  final BranchManagerSettingAndAggregatorsRemoteDataSource _remote;

  BranchManagerSettingAndAggregatorsRepositoryImpl(this._remote);

  @override
  FutureApiResult<BranchManagerMyAccountDetailsEntity>
  getBranchManagerMyAccountDetails() {
    return execute(() async {
      return await _remote.getMyAccountDetails();
    });
  }

  @override
  FutureApiResult<BranchManagerSettingAndAggregatorsEntity>
  getBranchManagerSettingAndAggregators() {
    return execute(() async {
      final response = await _remote.getScreenData();
      return response.toEntity();
    });
  }

  @override
  FutureApiResult<List<BranchManagerAggregatorEntity>>
  getAvailableAggregators() {
    return execute(() async {
      return await _remote.getAvailableAggregators();
    });
  }

  @override
  FutureApiResult<List<BranchManagerAggregatorEntity>> getBranchAggregators() {
    return execute(() async {
      return await _remote.getBranchAggregators();
    });
  }

  @override
  FutureApiResult<BranchManagerAggregatorEntity> addAggregator({
    required String aggregatorId,
  }) {
    return execute(() async {
      return await _remote.addAggregator(
        BranchManagerAggregatorRequestModel(
          aggregatorId: aggregatorId,
        ).toJson(),
      );
    });
  }

  @override
  FutureApiResult<BranchManagerAggregatorEntity> deleteAggregator({
    required String aggregatorId,
  }) {
    return execute(() async {
      return await _remote.deleteAggregator(aggregatorId);
    });
  }

  @override
  FutureApiResult<BranchManagerAggregatorEntity> setAggregatorEnabled({
    required String aggregatorId,
    required bool enabled,
  }) {
    return execute(() async {
      return await _remote.setAggregatorEnabled(
        aggregatorId,
        BranchManagerAggregatorStatusRequestModel(
          aggregatorId: aggregatorId,
          enabled: enabled,
        ).toJson(),
      );
    });
  }

  @override
  FutureApiResult<void> updateShiftVarianceAlerts({required bool enabled}) {
    return execute(() async {
      return await _remote.updateShiftVarianceAlerts(
        BranchManagerNotificationRequestModel(enabled: enabled).toJson(),
      );
    });
  }

  @override
  FutureApiResult<void> updateDailyInventoryReminders({required bool enabled}) {
    return execute(() async {
      return await _remote.updateDailyInventoryReminders(
        BranchManagerNotificationRequestModel(enabled: enabled).toJson(),
      );
    });
  }

  @override
  FutureApiResult<void> updateApprovedAggregatorsOnly({required bool enabled}) {
    return execute(() async {
      return await _remote.updateApprovedAggregatorsOnly(
        BranchManagerNotificationRequestModel(enabled: enabled).toJson(),
      );
    });
  }

  @override
  FutureApiResult<void> updateAssetTransferRequests({required bool enabled}) {
    return execute(() async {
      return await _remote.updateAssetTransferRequests(
        BranchManagerNotificationRequestModel(enabled: enabled).toJson(),
      );
    });
  }

  @override
  FutureApiResult<void> updateAllowSplitShiftHandovers({
    required bool enabled,
  }) {
    return execute(() async {
      return await _remote.updateAllowSplitShiftHandovers(
        BranchManagerNotificationRequestModel(enabled: enabled).toJson(),
      );
    });
  }
}
