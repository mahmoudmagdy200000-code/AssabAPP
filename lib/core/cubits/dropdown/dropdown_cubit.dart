import '../../helpers/safe_cubit.dart';
import 'dropdown_state.dart';

class DropdownCubit<T> extends SafeCubit<DropdownState<T>> {
  DropdownCubit({T? initialValue})
    : super(DropdownState<T>(value: initialValue));

  void open() {
    if (!state.isOpen) {
      emit(state.copyWith(isOpen: true));
    }
  }

  void closeDropdown() {
    if (state.isOpen) {
      emit(state.copyWith(isOpen: false));
    }
  }

  void toggle() {
    state.isOpen ? closeDropdown() : open();
  }

  void select(T value) {
    emit(DropdownState<T>(value: value, isOpen: false));
  }

  void clear() {
    emit(DropdownState<T>(value: null, isOpen: false));
  }
}
