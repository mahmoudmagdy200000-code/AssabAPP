import 'package:flutter/material.dart';

import '../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../ui/filters/date_filter.dart';

part 'shift_filter_state.dart';

class ShiftFilterCubit extends SafeCubit<ShiftFilterState> {
  ShiftFilterCubit() : super(const ShiftFilterState());

  void setStatus(ShiftStatus? status) {
    emit(state.copyWith(status: status));
  }

  void setDateFilter(DateFilterOption? dateFilter) {
    emit(state.copyWith(dateFilter: dateFilter));
  }

  void setSelectedManager(String? managerId) {
    emit(state.copyWith(managerId: managerId));
  }

  void resetFilters() {
    emit(const ShiftFilterState());
  }

  bool get hasFilters =>
      state.status != null ||
      state.dateFilter != null ||
      state.managerId != null;
}
