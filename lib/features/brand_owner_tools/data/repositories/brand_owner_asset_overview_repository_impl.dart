import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/brand_owner_asset_overview_repository.dart';
import '../datasources/brand_owner_asset_overview_remote_data_source.dart';
import '../models/brand_owner_asset_overview_model.dart';

@LazySingleton(as: BrandOwnerAssetOverviewRepository)
class BrandOwnerAssetOverviewRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerAssetOverviewRepository {
  final BrandOwnerAssetOverviewRemoteDataSource _dataSource;

  BrandOwnerAssetOverviewRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<BrandOwnerAssetOverviewResponseModel> getOverview() {
    return execute(() => _dataSource.getOverview());
  }

  @override
  FutureApiResult<BrandOwnerAssetOverviewPerformanceSummaryModel>
  getPerformanceSummary() {
    return execute(() => _dataSource.getPerformanceSummary());
  }

  @override
  FutureApiResult<BrandOwnerAssetOverviewBranchModel> getBranchDetails({
    required String branchId,
  }) {
    return execute(() => _dataSource.getBranchDetails(branchId: branchId));
  }

  @override
  FutureApiResult<BrandOwnerAssetOverviewExportResponseModel> exportReport({
    required BrandOwnerAssetOverviewExportRequestModel request,
  }) {
    return execute(() => _dataSource.exportReport(request: request));
  }
}
