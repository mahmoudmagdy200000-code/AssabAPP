import 'package:assab/core/enums/custody_requests_status_enum.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'select_filter_custody_requests_state.dart';

@injectable
class SelectFilterCustodyRequestsCubit
    extends SafeCubit<SelectFilterCustodyRequestsState> {
  SelectFilterCustodyRequestsCubit()
    : super(const SelectFilterCustodyRequestsState());

  void setStatus(CustodyRequestsStatusEnum status) {
    emit(state.copyWith(status: status));
  }

  void setDate(TimeKeys time) {
    emit(state.copyWith(time: time));
  }

  void clearFilters() {
    emit(const SelectFilterCustodyRequestsState());
  }
}
