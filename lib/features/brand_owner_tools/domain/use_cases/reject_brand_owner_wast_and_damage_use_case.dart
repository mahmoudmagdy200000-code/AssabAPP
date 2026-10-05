import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/repositories/brand_owner_inventory_management_repository.dart';

@LazySingleton()
class RejectBrandOwnerWastAndDamageUseCase {
  final BrandOwnerInventoryManagementRepository _repository;

  RejectBrandOwnerWastAndDamageUseCase(this._repository);

  FutureApiResult<void> call({required String requestId}) {
    return _repository.rejectWastAndDamageRequest(requestId: requestId);
  }
}
