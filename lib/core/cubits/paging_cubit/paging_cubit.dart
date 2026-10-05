import '../../helpers/safe_cubit.dart';
import 'paging_state.dart';

class PagingCubit extends SafeCubit<PagingState> {
  PagingCubit({required int totalSteps, int initialIndex = 0})
    : super(PagingState(currentIndex: initialIndex, totalSteps: totalSteps));

  void nextStep() {
    if (!state.isLastStep) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void previousStep() {
    if (!state.isFirstStep) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  void goToStep(int index) {
    if (index >= 0 && index < state.totalSteps) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  void reset() {
    emit(state.copyWith(currentIndex: 0));
  }

  void updateTotalSteps(int newTotalSteps) {
    emit(state.copyWith(totalSteps: newTotalSteps));
  }
}
