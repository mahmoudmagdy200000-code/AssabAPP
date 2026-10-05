import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class ExportScenarioUseCase {
  final PriceSimulatorRepository _repository;

  ExportScenarioUseCase(this._repository);

  Future<ApiResult<String>> call({
    required String scenarioId,
    required String formatType,
  }) {
    return _repository.exportScenario(
      scenarioId: scenarioId,
      formatType: formatType,
    );
  }
}
