import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_asset_overview_model.dart';
import '../models/brand_owner_control_panel_model.dart';

part 'brand_owner_asset_overview_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BrandOwnerAssetOverviewRemoteDataSource {
  factory BrandOwnerAssetOverviewRemoteDataSource(Dio dio, {String baseUrl}) =
      _BrandOwnerAssetOverviewRemoteDataSource;

  @GET(ApiEndpoint.brandOwnerAssetOverview)
  Future<BrandOwnerAssetOverviewResponseModel> getOverview();

  @GET(ApiEndpoint.brandOwnerAssetOverviewPerformanceSummary)
  Future<BrandOwnerAssetOverviewPerformanceSummaryModel>
  getPerformanceSummary();

  @GET(ApiEndpoint.brandOwnerAssetOverviewBranchDetails)
  Future<BrandOwnerAssetOverviewBranchModel> getBranchDetails({
    @Path('branchId') required String branchId,
  });

  @POST(ApiEndpoint.brandOwnerAssetOverviewExport)
  Future<BrandOwnerAssetOverviewExportResponseModel> exportReport({
    @Body() required BrandOwnerAssetOverviewExportRequestModel request,
  });

  @GET(ApiEndpoint.brandOwnerControlPanel)
  Future<BrandOwnerControlPanelModel> getControlPanelData();
}
