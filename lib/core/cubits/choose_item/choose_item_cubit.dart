import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';
import 'choose_item_state.dart';

@injectable
class ChooseItemCubit extends SafeCubit<ChooseItemState> {
  ChooseItemCubit() : super(const ChooseItemState());

  void selectItem(int index) {
    emit(
      state.copyWith(
        selectedIndex: index,
        selectedSubIndex: state.selectedSubIndex,
      ),
    );
  }

  void selectSubItem(int index) {
    emit(
      state.copyWith(
        selectedSubIndex: index,
        selectedIndex: state.selectedIndex,
      ),
    );
  }

  void reset() {
    emit(const ChooseItemState());
  }

  void initTempSelection() {
    emit(state.copyWith(tempSelectedIndex: state.selectedIndex));
  }

  void selectTempItem(int index) {
    emit(state.copyWith(tempSelectedIndex: index));
  }

  void confirmTempSelection({int? subIndex}) {
    emit(state.copyWith(selectedIndex: subIndex ?? state.tempSelectedIndex));
  }

  void clearTempSelection() {
    emit(state.copyWith(tempSelectedIndex: state.selectedIndex));
  }
}
