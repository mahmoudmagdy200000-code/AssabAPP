import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class EmailScenarioUseCase {
  final PriceSimulatorRepository _repository;

  EmailScenarioUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String scenarioId,
    required String email,
  }) {
    return _repository.emailScenario(
      scenarioId: scenarioId,
      email: email,
    );
  }
}
