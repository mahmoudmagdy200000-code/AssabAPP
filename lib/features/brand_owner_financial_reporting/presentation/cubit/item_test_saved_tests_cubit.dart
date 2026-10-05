import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_saved_item_tests_usecase.dart';
import 'item_test_saved_tests_state.dart';

@injectable
class ItemTestSavedTestsCubit extends SafeCubit<ItemTestSavedTestsState> {
  final GetSavedItemTestsUseCase _useCase;

  ItemTestSavedTestsCubit(this._useCase)
    : super(const ItemTestSavedTestsInit());

  Future<void> loadSavedTests() async {
    emit(const ItemTestSavedTestsLoading());

    final result = await _useCase();

    handle(
      result,
      success: (tests) => emit(ItemTestSavedTestsSuccess(
        tests: tests,
        filteredTests: tests,
      )),
      failure: (failure) => emit(ItemTestSavedTestsFailure(failure)),
    );
  }

  void search(String query) {
    final currentState = state;
    if (currentState is! ItemTestSavedTestsSuccess) return;

    final filtered = query.isEmpty
        ? currentState.tests
        : currentState
            .tests
            .where(
              (test) =>
                  test.itemName.toLowerCase().contains(query.toLowerCase()) ||
                  test.branchName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    emit(ItemTestSavedTestsSuccess(
      tests: currentState.tests,
      filteredTests: filtered,
      searchQuery: query,
    ));
  }
}
