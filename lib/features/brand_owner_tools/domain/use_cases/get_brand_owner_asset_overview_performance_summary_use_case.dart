import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_asset_overview_model.dart';
import '../repositories/brand_owner_asset_overview_repository.dart';

@LazySingleton()
class GetBrandOwnerAssetOverviewPerformanceSummaryUseCase {
  final BrandOwnerAssetOverviewRepository _repository;

  GetBrandOwnerAssetOverviewPerformanceSummaryUseCase(this._repository);

  FutureApiResult<BrandOwnerAssetOverviewPerformanceSummaryModel> call() {
    return _repository.getPerformanceSummary();
  }
}
