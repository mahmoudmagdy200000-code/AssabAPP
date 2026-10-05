import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/fixed_asset_preview_asset_history_response.dart';
import '../../data/repositories/fixed_assets_repository.dart';

@LazySingleton()
class GetFixedAssetsPreviewHistoryAssetUseCase {
  final FixedAssetsRepository _repository;

  GetFixedAssetsPreviewHistoryAssetUseCase(this._repository);

  FutureApiResult<FixedAssetPreviewAssetHistoryResponse> call({
    required String assetId,
  }) {
    return _repository.getAssetHistory(assetId: assetId);
  }
}
