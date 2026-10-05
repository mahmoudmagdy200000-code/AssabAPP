import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_asset_overview_model.dart';
import '../repositories/brand_owner_asset_overview_repository.dart';

@LazySingleton()
class ExportBrandOwnerAssetOverviewReportUseCase {
  final BrandOwnerAssetOverviewRepository _repository;

  ExportBrandOwnerAssetOverviewReportUseCase(this._repository);

  FutureApiResult<BrandOwnerAssetOverviewExportResponseModel> call({
    required BrandOwnerAssetOverviewExportRequestModel request,
  }) {
    return _repository.exportReport(request: request);
  }
}
