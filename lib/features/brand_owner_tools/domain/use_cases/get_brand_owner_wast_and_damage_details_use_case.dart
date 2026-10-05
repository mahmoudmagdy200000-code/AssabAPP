import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_wast_and_damage_details_response.dart';
import '../../data/repositories/brand_owner_inventory_management_repository.dart';

@LazySingleton()
class GetBrandOwnerWastAndDamageDetailsUseCase {
  final BrandOwnerInventoryManagementRepository _repository;

  GetBrandOwnerWastAndDamageDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerWastAndDamageDetailsResponse> call({
    required String requestId,
  }) {
    return _repository.getWastAndDamageDetails(requestId: requestId);
  }
}
