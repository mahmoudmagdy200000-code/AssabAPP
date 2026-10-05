import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_operational_profitability_entity.dart';

abstract class BrandOwnerOperationalProfitabilityRepository {
  FutureApiResult<OperationalProfitabilityEntity> getOperationalProfitability();

  FutureApiResult<String> exportOperationalProfitability({
    required String formatType,
  });

  FutureApiResult<void> emailOperationalProfitability({
    required String email,
  });
}
