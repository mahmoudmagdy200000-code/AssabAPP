import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/price_simulator_saved_scenario_entity.dart';

sealed class PriceSimulatorSavedScenariosState extends Equatable {
  const PriceSimulatorSavedScenariosState();

  @override
  List<Object> get props => [];
}

final class PriceSimulatorSavedScenariosInit
    extends PriceSimulatorSavedScenariosState {
  const PriceSimulatorSavedScenariosInit();
}

final class PriceSimulatorSavedScenariosLoading
    extends PriceSimulatorSavedScenariosState {
  const PriceSimulatorSavedScenariosLoading();
}

final class PriceSimulatorSavedScenariosSuccess
    extends PriceSimulatorSavedScenariosState {
  final List<PriceSimulatorSavedScenarioEntity> scenarios;
  final List<PriceSimulatorSavedScenarioEntity> filteredScenarios;
  final String searchQuery;

  const PriceSimulatorSavedScenariosSuccess({
    required this.scenarios,
    required this.filteredScenarios,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [scenarios, filteredScenarios, searchQuery];
}

final class PriceSimulatorSavedScenariosFailure
    extends PriceSimulatorSavedScenariosState {
  final ApiFailure failure;

  const PriceSimulatorSavedScenariosFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
