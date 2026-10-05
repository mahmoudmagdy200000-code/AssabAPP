import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_operational_profitability_repository.dart';

@LazySingleton()
class ExportOperationalProfitabilityUseCase {
  final BrandOwnerOperationalProfitabilityRepository _repository;

  ExportOperationalProfitabilityUseCase(this._repository);

  Future<ApiResult<String>> call({
    required String formatType,
  }) {
    return _repository.exportOperationalProfitability(
      formatType: formatType,
    );
  }

  Future<ApiResult<void>> emailReport({
    required String email,
  }) {
    return _repository.emailOperationalProfitability(
      email: email,
    );
  }
}
