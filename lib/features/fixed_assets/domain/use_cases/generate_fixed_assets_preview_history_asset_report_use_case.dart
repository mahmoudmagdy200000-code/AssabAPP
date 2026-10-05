import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/fixed_asset_preview_generate_report_response.dart';
import '../../data/repositories/fixed_assets_repository.dart';

@LazySingleton()
class GenerateFixedAssetsPreviewHistoryAssetReportUseCase {
  final FixedAssetsRepository _repository;

  GenerateFixedAssetsPreviewHistoryAssetReportUseCase(this._repository);

  FutureApiResult<FixedAssetPreviewGenerateReportResponse> call({
    required String assetId,
  }) {
    return _repository.generateAssetHistoryReport(assetId: assetId);
  }
}
