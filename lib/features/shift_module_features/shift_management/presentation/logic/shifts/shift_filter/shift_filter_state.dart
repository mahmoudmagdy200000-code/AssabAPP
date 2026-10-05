part of 'shift_filter_cubit.dart';

@immutable
class ShiftFilterState {
  final ShiftStatus? status;
  final DateFilterOption? dateFilter;
  final String? managerId;

  const ShiftFilterState({this.status, this.dateFilter, this.managerId});

  bool get hasFilters =>
      status != null || dateFilter != null || managerId != null;

  ShiftFilterState copyWith({
    ShiftStatus? status,
    DateFilterOption? dateFilter,
    String? managerId,
  }) {
    return ShiftFilterState(
      status: status ?? this.status,
      dateFilter: dateFilter ?? this.dateFilter,
      managerId: managerId ?? this.managerId,
    );
  }
}
