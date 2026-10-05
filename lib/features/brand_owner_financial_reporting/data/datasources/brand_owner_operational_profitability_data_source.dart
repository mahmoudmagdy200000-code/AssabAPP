import '../models/brand_owner_operational_profitability_model.dart';
import '../models/export_operational_profitability_request.dart';

abstract class BrandOwnerOperationalProfitabilityDataSource {
  Future<OperationalProfitabilityModel> getOperationalProfitability();

  Future<String> exportOperationalProfitability({
    required ExportOperationalProfitabilityRequest request,
  });

  Future<void> emailOperationalProfitability({
    required ExportOperationalProfitabilityRequest request,
  });
}
