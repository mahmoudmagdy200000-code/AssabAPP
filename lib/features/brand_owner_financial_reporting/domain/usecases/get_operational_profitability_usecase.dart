import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_operational_profitability_entity.dart';
import '../repositories/brand_owner_operational_profitability_repository.dart';

@LazySingleton()
class GetOperationalProfitabilityUseCase {
  final BrandOwnerOperationalProfitabilityRepository _repository;

  GetOperationalProfitabilityUseCase(this._repository);

  Future<ApiResult<OperationalProfitabilityEntity>> call() {
    return _repository.getOperationalProfitability();
  }
}
