import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class PriceSimulatorScenarioDetailsState extends Equatable {
  const PriceSimulatorScenarioDetailsState();

  @override
  List<Object> get props => [];
}

final class PriceSimulatorScenarioDetailsInit
    extends PriceSimulatorScenarioDetailsState {
  const PriceSimulatorScenarioDetailsInit();
}

final class PriceSimulatorScenarioDetailsExportLoading
    extends PriceSimulatorScenarioDetailsState {
  const PriceSimulatorScenarioDetailsExportLoading();
}

final class PriceSimulatorScenarioDetailsExportSuccess
    extends PriceSimulatorScenarioDetailsState {
  final String fileUrl;

  const PriceSimulatorScenarioDetailsExportSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class PriceSimulatorScenarioDetailsExportFailure
    extends PriceSimulatorScenarioDetailsState {
  final ApiFailure failure;

  const PriceSimulatorScenarioDetailsExportFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class PriceSimulatorScenarioDetailsEmailLoading
    extends PriceSimulatorScenarioDetailsState {
  const PriceSimulatorScenarioDetailsEmailLoading();
}

final class PriceSimulatorScenarioDetailsEmailSuccess
    extends PriceSimulatorScenarioDetailsState {
  const PriceSimulatorScenarioDetailsEmailSuccess();
}

final class PriceSimulatorScenarioDetailsEmailFailure
    extends PriceSimulatorScenarioDetailsState {
  final ApiFailure failure;

  const PriceSimulatorScenarioDetailsEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
