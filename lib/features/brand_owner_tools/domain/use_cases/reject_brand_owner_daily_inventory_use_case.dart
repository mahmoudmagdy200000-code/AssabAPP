import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/repositories/brand_owner_inventory_management_repository.dart';

@LazySingleton()
class RejectBrandOwnerDailyInventoryUseCase {
  final BrandOwnerInventoryManagementRepository _repository;

  RejectBrandOwnerDailyInventoryUseCase(this._repository);

  FutureApiResult<void> call({required String requestId}) {
    return _repository.rejectDailyInventoryRequest(requestId: requestId);
  }
}
