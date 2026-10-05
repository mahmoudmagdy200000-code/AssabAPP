import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_asset_overview_model.dart';

abstract class BrandOwnerAssetOverviewRepository {
  FutureApiResult<BrandOwnerAssetOverviewResponseModel> getOverview();

  FutureApiResult<BrandOwnerAssetOverviewPerformanceSummaryModel>
  getPerformanceSummary();

  FutureApiResult<BrandOwnerAssetOverviewBranchModel> getBranchDetails({
    required String branchId,
  });

  FutureApiResult<BrandOwnerAssetOverviewExportResponseModel> exportReport({
    required BrandOwnerAssetOverviewExportRequestModel request,
  });
}
