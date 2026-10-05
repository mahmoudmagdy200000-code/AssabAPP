import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/save_scenario_usecase.dart';
import 'price_simulator_save_scenario_state.dart';

@injectable
class PriceSimulatorSaveScenarioCubit
    extends SafeCubit<PriceSimulatorSaveScenarioState> {
  final SaveScenarioUseCase _useCase;

  PriceSimulatorSaveScenarioCubit(this._useCase)
    : super(const PriceSimulatorSaveScenarioInit());

  Future<void> saveScenario({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) async {
    emit(const PriceSimulatorSaveScenarioLoading());

    final apiResult = await _useCase(
      branchId: branchId,
      itemId: itemId,
      changePrice: changePrice,
      expectedGrowthDecline: expectedGrowthDecline,
    );

    handle(
      apiResult,
      success: (_) => emit(const PriceSimulatorSaveScenarioSuccess()),
      failure: (failure) =>
          emit(PriceSimulatorSaveScenarioFailure(failure)),
    );
  }
}
