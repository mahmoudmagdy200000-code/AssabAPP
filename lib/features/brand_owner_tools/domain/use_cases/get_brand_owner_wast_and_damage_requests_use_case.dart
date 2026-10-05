import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_wast_and_damage_requests_response.dart';
import '../../data/repositories/brand_owner_inventory_management_repository.dart';

@LazySingleton()
class GetBrandOwnerWastAndDamageRequestsUseCase {
  final BrandOwnerInventoryManagementRepository _repository;

  GetBrandOwnerWastAndDamageRequestsUseCase(this._repository);

  FutureApiResult<BrandOwnerWastAndDamageRequestsResponse> call(int page) {
    return _repository.getWastAndDamageRequests(page: page);
  }
}
