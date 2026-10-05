import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_asset_overview_model.dart';

sealed class BrandOwnerAssetOverviewBranchDetailsState {
  const BrandOwnerAssetOverviewBranchDetailsState();
}

final class BrandOwnerAssetOverviewBranchDetailsInitial
    extends BrandOwnerAssetOverviewBranchDetailsState {
  const BrandOwnerAssetOverviewBranchDetailsInitial();
}

final class BrandOwnerAssetOverviewBranchDetailsLoading
    extends BrandOwnerAssetOverviewBranchDetailsState {
  const BrandOwnerAssetOverviewBranchDetailsLoading();
}

final class BrandOwnerAssetOverviewBranchDetailsSuccess
    extends BrandOwnerAssetOverviewBranchDetailsState {
  final BrandOwnerAssetOverviewBranchModel branch;

  const BrandOwnerAssetOverviewBranchDetailsSuccess(this.branch);
}

final class BrandOwnerAssetOverviewBranchDetailsFailure
    extends BrandOwnerAssetOverviewBranchDetailsState {
  final ApiFailure failure;

  const BrandOwnerAssetOverviewBranchDetailsFailure(this.failure);
}
