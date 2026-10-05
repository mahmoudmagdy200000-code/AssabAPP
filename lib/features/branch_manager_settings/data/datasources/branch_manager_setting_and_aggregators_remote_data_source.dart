import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/branch_manager_my_account_details_model.dart';
import '../models/branch_manager_setting_and_aggregators_models.dart';

part 'branch_manager_setting_and_aggregators_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BranchManagerSettingAndAggregatorsRemoteDataSource {
  factory BranchManagerSettingAndAggregatorsRemoteDataSource(
    Dio dio, {
    String? baseUrl,
  }) = _BranchManagerSettingAndAggregatorsRemoteDataSource;

  @GET(ApiEndpoint.branchManagerSettingsAccountDetails)
  Future<BranchManagerMyAccountDetailsModel> getMyAccountDetails();

  @GET(ApiEndpoint.branchManagerSettingsAggregators)
  Future<BranchManagerSettingAndAggregatorsResponseModel> getScreenData();

  @GET(ApiEndpoint.branchManagerSettingsAggregatorsAvailable)
  Future<List<BranchManagerAggregatorModel>> getAvailableAggregators();

  @GET(ApiEndpoint.branchManagerSettingsAggregatorsAssigned)
  Future<List<BranchManagerAggregatorModel>> getBranchAggregators();

  @POST(ApiEndpoint.branchManagerSettingsAggregators)
  Future<BranchManagerAggregatorModel> addAggregator(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(ApiEndpoint.branchManagerSettingsAggregatorsItem)
  Future<BranchManagerAggregatorModel> deleteAggregator(
    @Path('aggregatorId') String aggregatorId,
  );

  @PATCH(ApiEndpoint.branchManagerSettingsAggregatorsItemStatus)
  Future<BranchManagerAggregatorModel> setAggregatorEnabled(
    @Path('aggregatorId') String aggregatorId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(ApiEndpoint.branchManagerSettingsNotificationsShiftVarianceAlerts)
  Future<void> updateShiftVarianceAlerts(@Body() Map<String, dynamic> body);

  @PATCH(ApiEndpoint.branchManagerSettingsNotificationsDailyInventoryReminders)
  Future<void> updateDailyInventoryReminders(@Body() Map<String, dynamic> body);

  @PATCH(ApiEndpoint.branchManagerSettingsNotificationsApprovedAggregatorsOnly)
  Future<void> updateApprovedAggregatorsOnly(@Body() Map<String, dynamic> body);

  @PATCH(ApiEndpoint.branchManagerSettingsNotificationsAssetTransferRequests)
  Future<void> updateAssetTransferRequests(@Body() Map<String, dynamic> body);

  @PATCH(ApiEndpoint.branchManagerSettingsNotificationsAllowSplitShiftHandovers)
  Future<void> updateAllowSplitShiftHandovers(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoint.branchManagerSettingsResetPassword)
  Future<void> resetPassword(@Body() Map<String, dynamic> body);
}
