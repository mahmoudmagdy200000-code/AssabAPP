import '../models/price_simulator_item_info_model.dart';
import '../models/price_simulator_item_model.dart';
import '../models/price_simulator_saved_scenario_model.dart';
import '../models/price_simulator_simulation_result_model.dart';

abstract class PriceSimulatorDataSource {
  Future<List<PriceSimulatorItemModel>> getItems();

  Future<PriceSimulatorItemInfoModel> getItemInfo({
    required String branchId,
    required String itemId,
  });

  Future<PriceSimulatorSimulationResultModel> submitSimulation({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  });

  Future<List<PriceSimulatorSavedScenarioModel>> getSavedScenarios();

  Future<void> saveScenario({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  });

  Future<String> exportScenario({
    required String scenarioId,
    required String formatType,
  });

  Future<void> emailScenario({
    required String scenarioId,
    required String email,
  });
}
