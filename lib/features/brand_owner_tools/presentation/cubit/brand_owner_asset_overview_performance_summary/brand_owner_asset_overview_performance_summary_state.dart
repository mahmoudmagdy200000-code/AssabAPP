import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_asset_overview_model.dart';

sealed class BrandOwnerAssetOverviewPerformanceSummaryState {
  const BrandOwnerAssetOverviewPerformanceSummaryState();
}

final class BrandOwnerAssetOverviewPerformanceSummaryInitial
    extends BrandOwnerAssetOverviewPerformanceSummaryState {
  const BrandOwnerAssetOverviewPerformanceSummaryInitial();
}

final class BrandOwnerAssetOverviewPerformanceSummaryLoading
    extends BrandOwnerAssetOverviewPerformanceSummaryState {
  const BrandOwnerAssetOverviewPerformanceSummaryLoading();
}

final class BrandOwnerAssetOverviewPerformanceSummarySuccess
    extends BrandOwnerAssetOverviewPerformanceSummaryState {
  final BrandOwnerAssetOverviewPerformanceSummaryModel summary;

  const BrandOwnerAssetOverviewPerformanceSummarySuccess(this.summary);
}

final class BrandOwnerAssetOverviewPerformanceSummaryFailure
    extends BrandOwnerAssetOverviewPerformanceSummaryState {
  final ApiFailure failure;

  const BrandOwnerAssetOverviewPerformanceSummaryFailure(this.failure);
}
