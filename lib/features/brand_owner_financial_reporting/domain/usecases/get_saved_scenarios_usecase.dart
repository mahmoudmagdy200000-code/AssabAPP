import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/price_simulator_saved_scenario_entity.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class GetSavedScenariosUseCase {
  final PriceSimulatorRepository _repository;

  GetSavedScenariosUseCase(this._repository);

  Future<ApiResult<List<PriceSimulatorSavedScenarioEntity>>> call() {
    return _repository.getSavedScenarios();
  }
}
