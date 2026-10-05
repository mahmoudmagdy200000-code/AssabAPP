import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/price_simulator_simulation_result_entity.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class SubmitPriceSimulationUseCase {
  final PriceSimulatorRepository _repository;

  SubmitPriceSimulationUseCase(this._repository);

  Future<ApiResult<PriceSimulatorSimulationResultEntity>> call({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) {
    return _repository.submitSimulation(
      branchId: branchId,
      itemId: itemId,
      changePrice: changePrice,
      expectedGrowthDecline: expectedGrowthDecline,
    );
  }
}
