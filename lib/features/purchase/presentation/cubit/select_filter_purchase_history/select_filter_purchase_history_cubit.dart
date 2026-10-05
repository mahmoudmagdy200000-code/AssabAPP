import 'package:assab/core/enums/filter_purchase_history_type_enum.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/enums/request_perspective_enum.dart';
import '../../../../../core/enums/time_keys.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_filter_purchase_history_state.dart';

@injectable
class SelectFilterPurchaseHistoryCubit
    extends SafeCubit<SelectFilterPurchaseHistoryState> {
  SelectFilterPurchaseHistoryCubit()
    : super(const SelectFilterPurchaseHistoryState());

  void selectRequestPerspective(RequestPerspectiveEnum perspective) {
    emit(state.copyWith(selectedPerspective: perspective));
  }

  void selectType(FilterPurchaseHistoryTypeEnum type) {
    emit(state.copyWith(selectedType: type));
  }

  void selectTime(TimeKeys time) {
    emit(state.copyWith(selectedTime: time));
  }

  void clearFilters() {
    emit(const SelectFilterPurchaseHistoryState());
  }
}
