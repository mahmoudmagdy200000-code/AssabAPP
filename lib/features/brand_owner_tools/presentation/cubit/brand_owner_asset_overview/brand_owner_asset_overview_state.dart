import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_asset_overview_model.dart';

sealed class BrandOwnerAssetOverviewState {
  const BrandOwnerAssetOverviewState();
}

final class BrandOwnerAssetOverviewInitial
    extends BrandOwnerAssetOverviewState {
  const BrandOwnerAssetOverviewInitial();
}

final class BrandOwnerAssetOverviewLoading
    extends BrandOwnerAssetOverviewState {
  const BrandOwnerAssetOverviewLoading();
}

final class BrandOwnerAssetOverviewSuccess
    extends BrandOwnerAssetOverviewState {
  final BrandOwnerAssetOverviewResponseModel overview;

  const BrandOwnerAssetOverviewSuccess(this.overview);
}

final class BrandOwnerAssetOverviewFailure
    extends BrandOwnerAssetOverviewState {
  final ApiFailure failure;

  const BrandOwnerAssetOverviewFailure(this.failure);
}
