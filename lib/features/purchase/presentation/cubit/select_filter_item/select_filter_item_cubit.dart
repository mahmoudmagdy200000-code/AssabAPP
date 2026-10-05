import 'package:injectable/injectable.dart';

import '../../../../../core/enums/select_filter_item_type.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_filter_item_state.dart';

@injectable
class SelectFilterItemCubit extends SafeCubit<SelectFilterItemState> {
  SelectFilterItemCubit() : super(const SelectFilterItemState());

  void selectFilterItem({
    required SelectFilterItemType filterType,
    required String id,
    String? name,
  }) {
    emit(
      state.copyWith(
        selectedFilterType: filterType,
        selectedId: id,
        selectedName: name,
      ),
    );
  }

  void clearSelection() {
    emit(const SelectFilterItemState());
  }
}
