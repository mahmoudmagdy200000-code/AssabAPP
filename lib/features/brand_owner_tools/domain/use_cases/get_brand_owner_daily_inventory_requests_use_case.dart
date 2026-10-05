import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_daily_inventory_requests_response.dart';
import '../../data/repositories/brand_owner_inventory_management_repository.dart';

@LazySingleton()
class GetBrandOwnerDailyInventoryRequestsUseCase {
  final BrandOwnerInventoryManagementRepository _repository;

  GetBrandOwnerDailyInventoryRequestsUseCase(this._repository);

  FutureApiResult<BrandOwnerDailyInventoryRequestsResponse> call(int page) {
    return _repository.getDailyInventoryRequests(page: page);
  }
}
