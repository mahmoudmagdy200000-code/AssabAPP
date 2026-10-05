import '../../../data/models/brand_owner_asset_overview_model.dart';

sealed class BrandOwnerAssetOverviewSearchState {
  const BrandOwnerAssetOverviewSearchState();
}

final class BrandOwnerAssetOverviewSearchInitial
    extends BrandOwnerAssetOverviewSearchState {
  const BrandOwnerAssetOverviewSearchInitial();
}

final class BrandOwnerAssetOverviewSearchResult
    extends BrandOwnerAssetOverviewSearchState {
  final List<BrandOwnerAssetOverviewBranchModel> branches;
  final List<BrandOwnerAssetOverviewAssetModel> assets;
  final String query;

  const BrandOwnerAssetOverviewSearchResult({
    required this.branches,
    required this.assets,
    required this.query,
  });
}
