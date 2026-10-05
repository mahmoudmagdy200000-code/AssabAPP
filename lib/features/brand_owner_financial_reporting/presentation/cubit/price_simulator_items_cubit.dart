import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_price_simulator_items_usecase.dart';
import 'price_simulator_items_state.dart';

@injectable
class PriceSimulatorItemsCubit
    extends SafeCubit<PriceSimulatorItemsState> {
  final GetPriceSimulatorItemsUseCase _useCase;

  PriceSimulatorItemsCubit(this._useCase)
    : super(const PriceSimulatorItemsInit());

  Future<void> loadItems() async {
    emit(const PriceSimulatorItemsLoading());

    final result = await _useCase();

    handle(
      result,
      success: (items) => emit(PriceSimulatorItemsSuccess(
        items: items,
        filteredItems: items,
      )),
      failure: (failure) =>
          emit(PriceSimulatorItemsFailure(failure)),
    );
  }

  void search(String query) {
    final currentState = state;
    if (currentState is! PriceSimulatorItemsSuccess) return;

    final filtered = query.isEmpty
        ? currentState.items
        : currentState
            .items
            .where(
              (item) =>
                  item.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    emit(PriceSimulatorItemsSuccess(
      items: currentState.items,
      filteredItems: filtered,
      searchQuery: query,
    ));
  }
}
