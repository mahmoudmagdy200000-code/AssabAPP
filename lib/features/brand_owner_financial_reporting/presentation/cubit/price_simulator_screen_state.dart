import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/price_simulator_item_info_entity.dart';
import '../../domain/entities/price_simulator_simulation_result_entity.dart';

sealed class PriceSimulatorScreenState extends Equatable {
  const PriceSimulatorScreenState();

  @override
  List<Object> get props => [];
}

final class PriceSimulatorScreenInit extends PriceSimulatorScreenState {
  const PriceSimulatorScreenInit();
}

final class PriceSimulatorScreenItemInfoLoading
    extends PriceSimulatorScreenState {
  const PriceSimulatorScreenItemInfoLoading();
}

final class PriceSimulatorScreenItemInfoFailure
    extends PriceSimulatorScreenState {
  final ApiFailure failure;

  const PriceSimulatorScreenItemInfoFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class PriceSimulatorScreenItemInfoSuccess
    extends PriceSimulatorScreenState {
  final PriceSimulatorItemInfoEntity itemInfo;
  final double changePrice;
  final double expectedGrowthDecline;

  const PriceSimulatorScreenItemInfoSuccess({
    required this.itemInfo,
    this.changePrice = 1,
    this.expectedGrowthDecline = 5.0,
  });

  @override
  List<Object> get props => [itemInfo, changePrice, expectedGrowthDecline];
}

final class PriceSimulatorScreenSimulationLoading
    extends PriceSimulatorScreenState {
  const PriceSimulatorScreenSimulationLoading();
}

final class PriceSimulatorScreenSimulationSuccess
    extends PriceSimulatorScreenState {
  final PriceSimulatorSimulationResultEntity result;
  final String branchId;
  final String itemId;
  final double changePrice;
  final double expectedGrowthDecline;

  const PriceSimulatorScreenSimulationSuccess({
    required this.result,
    required this.branchId,
    required this.itemId,
    required this.changePrice,
    required this.expectedGrowthDecline,
  });

  @override
  List<Object> get props => [
    result,
    branchId,
    itemId,
    changePrice,
    expectedGrowthDecline,
  ];
}

final class PriceSimulatorScreenSimulationFailure
    extends PriceSimulatorScreenState {
  final ApiFailure failure;

  const PriceSimulatorScreenSimulationFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
