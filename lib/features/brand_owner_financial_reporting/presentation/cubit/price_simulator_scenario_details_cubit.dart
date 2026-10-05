import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/email_scenario_usecase.dart';
import '../../domain/usecases/export_scenario_usecase.dart';
import 'price_simulator_scenario_details_state.dart';

@injectable
class PriceSimulatorScenarioDetailsCubit
    extends SafeCubit<PriceSimulatorScenarioDetailsState> {
  final ExportScenarioUseCase _exportUseCase;
  final EmailScenarioUseCase _emailUseCase;

  PriceSimulatorScenarioDetailsCubit(
    this._exportUseCase,
    this._emailUseCase,
  ) : super(const PriceSimulatorScenarioDetailsInit());

  Future<void> exportPdf(String scenarioId) async {
    await _export(scenarioId, 'pdf');
  }

  Future<void> exportExcel(String scenarioId) async {
    await _export(scenarioId, 'excel');
  }

  Future<void> _export(String scenarioId, String formatType) async {
    emit(const PriceSimulatorScenarioDetailsExportLoading());

    final result = await _exportUseCase(
      scenarioId: scenarioId,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) =>
          emit(PriceSimulatorScenarioDetailsExportSuccess(fileUrl)),
      failure: (failure) =>
          emit(PriceSimulatorScenarioDetailsExportFailure(failure)),
    );
  }

  Future<void> emailScenario({
    required String scenarioId,
    required String email,
  }) async {
    emit(const PriceSimulatorScenarioDetailsEmailLoading());

    final result = await _emailUseCase(
      scenarioId: scenarioId,
      email: email,
    );

    handle(
      result,
      success: (_) =>
          emit(const PriceSimulatorScenarioDetailsEmailSuccess()),
      failure: (failure) =>
          emit(PriceSimulatorScenarioDetailsEmailFailure(failure)),
    );
  }
}
