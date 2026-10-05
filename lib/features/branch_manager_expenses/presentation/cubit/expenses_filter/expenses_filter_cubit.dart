import 'package:assab/core/enums/expenses_filter_keys.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/enums/filter_status.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'expenses_filter_state.dart';

@injectable
class ExpensesFilterCubit extends SafeCubit<ExpensesFilterState> {
  ExpensesFilterCubit()
    : super(
        ExpensesFilterState(
          type: {for (var key in ExpensesFilterKeys.values) key: false},
          status: {for (var s in FilterStatus.values) s: false},
          sortBy: {for (var s in TimeKeys.values) s: false},
        ),
      );

  void updateType(ExpensesFilterKeys selectedType) {
    final updated = {
      for (final key in state.type.keys) key: key == selectedType,
    };
    emit(state.copyWith(type: updated));
  }

  void updateStatus(FilterStatus selectedStatus) {
    final updated = {for (final s in state.status.keys) s: s == selectedStatus};
    emit(state.copyWith(status: updated));
  }

  void updateSortBy(TimeKeys selectedTime) {
    final updated = {for (final s in state.sortBy.keys) s: s == selectedTime};
    emit(state.copyWith(sortBy: updated));
  }

  int get countSelectedFilters {
    final typeCount = state.type.values.where((v) => v).length;
    final statusCount = state.status.values.where((v) => v).length;
    final sortByCount = state.sortBy.values.where((v) => v).length;
    return typeCount + statusCount + sortByCount;
  }

  void resetFilter() {
    emit(
      ExpensesFilterState(
        type: {for (var key in ExpensesFilterKeys.values) key: false},
        status: {for (var s in FilterStatus.values) s: false},
        sortBy: {for (var s in TimeKeys.values) s: false},
      ),
    );
  }

  bool get areAllFiltersValid {
    final hasType = state.type.containsValue(true);
    final hasStatus = state.status.containsValue(true);
    final hasSortBy = state.sortBy.containsValue(true);
    return hasType || hasStatus || hasSortBy;
  }

  ExpensesFilterKeys? get selectedType => state.type.entries
      .firstWhere(
        (e) => e.value,
        orElse: () => const MapEntry(ExpensesFilterKeys.non, false),
      )
      .key;

  FilterStatus? get selectedStatus => state.status.entries
      .firstWhere(
        (e) => e.value,
        orElse: () => const MapEntry(FilterStatus.non, false),
      )
      .key;

  TimeKeys? get selectedSortBy => state.sortBy.entries
      .firstWhere(
        (e) => e.value,
        orElse: () => const MapEntry(TimeKeys.non, false),
      )
      .key;
}
