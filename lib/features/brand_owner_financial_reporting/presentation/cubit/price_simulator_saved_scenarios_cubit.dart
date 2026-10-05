import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_saved_scenarios_usecase.dart';
import 'price_simulator_saved_scenarios_state.dart';

@injectable
class PriceSimulatorSavedScenariosCubit
    extends SafeCubit<PriceSimulatorSavedScenariosState> {
  final GetSavedScenariosUseCase _useCase;

  PriceSimulatorSavedScenariosCubit(this._useCase)
    : super(const PriceSimulatorSavedScenariosInit());

  Future<void> loadScenarios() async {
    emit(const PriceSimulatorSavedScenariosLoading());

    final result = await _useCase();

    handle(
      result,
      success: (scenarios) => emit(PriceSimulatorSavedScenariosSuccess(
        scenarios: scenarios,
        filteredScenarios: scenarios,
      )),
      failure: (failure) =>
          emit(PriceSimulatorSavedScenariosFailure(failure)),
    );
  }

  void search(String query) {
    final currentState = state;
    if (currentState is! PriceSimulatorSavedScenariosSuccess) return;

    final filtered = query.isEmpty
        ? currentState.scenarios
        : currentState
            .scenarios
            .where(
              (scenario) =>
                  scenario.itemName
                      .toLowerCase()
                      .contains(query.toLowerCase()),
            )
            .toList();

    emit(PriceSimulatorSavedScenariosSuccess(
      scenarios: currentState.scenarios,
      filteredScenarios: filtered,
      searchQuery: query,
    ));
  }
}
