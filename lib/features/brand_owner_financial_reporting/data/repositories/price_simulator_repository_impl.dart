import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/price_simulator_item_entity.dart';
import '../../domain/entities/price_simulator_item_info_entity.dart';
import '../../domain/entities/price_simulator_saved_scenario_entity.dart';
import '../../domain/entities/price_simulator_simulation_result_entity.dart';
import '../../domain/repositories/price_simulator_repository.dart';
import '../datasources/price_simulator_data_source.dart';

@LazySingleton(as: PriceSimulatorRepository)
class PriceSimulatorRepositoryImpl
    with RepositoryMixin
    implements PriceSimulatorRepository {
  final PriceSimulatorDataSource _dataSource;

  PriceSimulatorRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<List<PriceSimulatorItemEntity>> getItems() {
    return execute(() async {
      final models = await _dataSource.getItems();
      return models;
    });
  }

  @override
  FutureApiResult<PriceSimulatorItemInfoEntity> getItemInfo({
    required String branchId,
    required String itemId,
  }) {
    return execute(() async {
      return await _dataSource.getItemInfo(branchId: branchId, itemId: itemId);
    });
  }

  @override
  FutureApiResult<PriceSimulatorSimulationResultEntity> submitSimulation({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) {
    return execute(() async {
      return await _dataSource.submitSimulation(
        branchId: branchId,
        itemId: itemId,
        changePrice: changePrice,
        expectedGrowthDecline: expectedGrowthDecline,
      );
    });
  }

  @override
  FutureApiResult<List<PriceSimulatorSavedScenarioEntity>>
      getSavedScenarios() {
    return execute(() async {
      return await _dataSource.getSavedScenarios();
    });
  }

  @override
  FutureApiResult<void> saveScenario({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) {
    return execute(() async {
      return await _dataSource.saveScenario(
        branchId: branchId,
        itemId: itemId,
        changePrice: changePrice,
        expectedGrowthDecline: expectedGrowthDecline,
      );
    });
  }

  @override
  FutureApiResult<String> exportScenario({
    required String scenarioId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportScenario(
        scenarioId: scenarioId,
        formatType: formatType,
      );
    });
  }

  @override
  FutureApiResult<void> emailScenario({
    required String scenarioId,
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailScenario(
        scenarioId: scenarioId,
        email: email,
      );
    });
  }
}
