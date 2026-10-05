import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_asset_overview_model.dart';
import '../repositories/brand_owner_asset_overview_repository.dart';

@LazySingleton()
class GetBrandOwnerAssetOverviewBranchDetailsUseCase {
  final BrandOwnerAssetOverviewRepository _repository;

  GetBrandOwnerAssetOverviewBranchDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerAssetOverviewBranchModel> call({
    required String branchId,
  }) {
    return _repository.getBranchDetails(branchId: branchId);
  }
}
