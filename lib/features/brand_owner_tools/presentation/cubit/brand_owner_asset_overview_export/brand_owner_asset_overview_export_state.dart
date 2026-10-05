import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_asset_overview_model.dart';

sealed class BrandOwnerAssetOverviewExportState {
  const BrandOwnerAssetOverviewExportState();
}

final class BrandOwnerAssetOverviewExportInitial
    extends BrandOwnerAssetOverviewExportState {
  const BrandOwnerAssetOverviewExportInitial();
}

final class BrandOwnerAssetOverviewExportLoading
    extends BrandOwnerAssetOverviewExportState {
  const BrandOwnerAssetOverviewExportLoading();
}

final class BrandOwnerAssetOverviewExportSuccess
    extends BrandOwnerAssetOverviewExportState {
  final BrandOwnerAssetOverviewExportResponseModel response;

  const BrandOwnerAssetOverviewExportSuccess(this.response);
}

final class BrandOwnerAssetOverviewExportFailure
    extends BrandOwnerAssetOverviewExportState {
  final ApiFailure failure;

  const BrandOwnerAssetOverviewExportFailure(this.failure);
}
