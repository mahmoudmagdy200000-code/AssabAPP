import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class SaveScenarioUseCase {
  final PriceSimulatorRepository _repository;

  SaveScenarioUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) {
    return _repository.saveScenario(
      branchId: branchId,
      itemId: itemId,
      changePrice: changePrice,
      expectedGrowthDecline: expectedGrowthDecline,
    );
  }
}
