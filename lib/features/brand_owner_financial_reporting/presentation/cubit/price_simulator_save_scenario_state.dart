import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class PriceSimulatorSaveScenarioState extends Equatable {
  const PriceSimulatorSaveScenarioState();

  @override
  List<Object> get props => [];
}

final class PriceSimulatorSaveScenarioInit
    extends PriceSimulatorSaveScenarioState {
  const PriceSimulatorSaveScenarioInit();
}

final class PriceSimulatorSaveScenarioLoading
    extends PriceSimulatorSaveScenarioState {
  const PriceSimulatorSaveScenarioLoading();
}

final class PriceSimulatorSaveScenarioSuccess
    extends PriceSimulatorSaveScenarioState {
  const PriceSimulatorSaveScenarioSuccess();
}

final class PriceSimulatorSaveScenarioFailure
    extends PriceSimulatorSaveScenarioState {
  final ApiFailure failure;

  const PriceSimulatorSaveScenarioFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
