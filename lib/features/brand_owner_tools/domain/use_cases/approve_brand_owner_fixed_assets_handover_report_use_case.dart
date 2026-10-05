import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class ApproveBrandOwnerFixedAssetsHandoverReportUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  ApproveBrandOwnerFixedAssetsHandoverReportUseCase(this._repository);

  FutureApiResult<void> call({
    required String requestId,
    required String warningNote,
  }) {
    return _repository.approveHandoverReportRequest(
      requestId: requestId,
      warningNote: warningNote,
    );
  }
}
