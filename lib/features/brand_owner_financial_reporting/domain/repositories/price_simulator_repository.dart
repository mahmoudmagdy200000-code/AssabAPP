import '../../../../core/utils/future_api_result.dart';
import '../entities/price_simulator_item_entity.dart';
import '../entities/price_simulator_item_info_entity.dart';
import '../entities/price_simulator_saved_scenario_entity.dart';
import '../entities/price_simulator_simulation_result_entity.dart';

abstract class PriceSimulatorRepository {
  FutureApiResult<List<PriceSimulatorItemEntity>> getItems();

  FutureApiResult<PriceSimulatorItemInfoEntity> getItemInfo({
    required String branchId,
    required String itemId,
  });

  FutureApiResult<PriceSimulatorSimulationResultEntity> submitSimulation({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  });

  FutureApiResult<List<PriceSimulatorSavedScenarioEntity>> getSavedScenarios();

  FutureApiResult<void> saveScenario({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  });

  FutureApiResult<String> exportScenario({
    required String scenarioId,
    required String formatType,
  });

  FutureApiResult<void> emailScenario({
    required String scenarioId,
    required String email,
  });
}
