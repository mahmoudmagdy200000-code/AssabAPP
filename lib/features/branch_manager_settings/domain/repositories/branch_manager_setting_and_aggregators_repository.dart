import '../../../../core/utils/future_api_result.dart';
import '../entities/branch_manager_my_account_details_entity.dart';
import '../entities/branch_manager_setting_and_aggregators_entity.dart';

abstract class BranchManagerSettingAndAggregatorsRepository {
  FutureApiResult<BranchManagerMyAccountDetailsEntity>
  getBranchManagerMyAccountDetails();

  FutureApiResult<BranchManagerSettingAndAggregatorsEntity>
  getBranchManagerSettingAndAggregators();

  FutureApiResult<List<BranchManagerAggregatorEntity>>
  getAvailableAggregators();

  FutureApiResult<List<BranchManagerAggregatorEntity>> getBranchAggregators();

  FutureApiResult<BranchManagerAggregatorEntity> addAggregator({
    required String aggregatorId,
  });

  FutureApiResult<BranchManagerAggregatorEntity> deleteAggregator({
    required String aggregatorId,
  });

  FutureApiResult<BranchManagerAggregatorEntity> setAggregatorEnabled({
    required String aggregatorId,
    required bool enabled,
  });

  FutureApiResult<void> updateShiftVarianceAlerts({required bool enabled});

  FutureApiResult<void> updateDailyInventoryReminders({required bool enabled});

  FutureApiResult<void> updateApprovedAggregatorsOnly({required bool enabled});

  FutureApiResult<void> updateAssetTransferRequests({required bool enabled});

  FutureApiResult<void> updateAllowSplitShiftHandovers({required bool enabled});
}
