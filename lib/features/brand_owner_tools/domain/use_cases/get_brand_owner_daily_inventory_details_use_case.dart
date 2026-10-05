import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_daily_inventory_details_response.dart';
import '../../data/repositories/brand_owner_inventory_management_repository.dart';

@LazySingleton()
class GetBrandOwnerDailyInventoryDetailsUseCase {
  final BrandOwnerInventoryManagementRepository _repository;

  GetBrandOwnerDailyInventoryDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerDailyInventoryDetailsResponse> call({
    required String requestId,
  }) {
    return _repository.getDailyInventoryDetails(requestId: requestId);
  }
}
