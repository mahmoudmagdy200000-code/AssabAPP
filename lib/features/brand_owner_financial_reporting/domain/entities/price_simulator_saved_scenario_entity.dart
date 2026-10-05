import 'package:equatable/equatable.dart';

import 'price_simulator_simulation_result_entity.dart';

class PriceSimulatorSavedScenarioEntity extends Equatable {
  final String id;
  final String itemName;
  final double newPrice;
  final String dateTime;
  final PriceSimulatorSimulationResultEntity details;

  const PriceSimulatorSavedScenarioEntity({
    required this.id,
    required this.itemName,
    required this.newPrice,
    required this.dateTime,
    required this.details,
  });

  @override
  List<Object> get props => [id, itemName, newPrice, dateTime, details];
}
