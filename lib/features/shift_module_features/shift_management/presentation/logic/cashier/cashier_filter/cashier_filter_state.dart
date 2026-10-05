part of 'cashier_filter_cubit.dart';

class CashierFilterState extends Equatable {
  final DateFilterOption? dateFilter;
  final CashierStatusFilter? statusFilter;

  const CashierFilterState({this.dateFilter, this.statusFilter});
  factory CashierFilterState.initial() => const CashierFilterState();

  CashierFilterState copyWith({
    DateFilterOption? dateFilter,
    CashierStatusFilter? statusFilter,
  }) {
    return CashierFilterState(
      dateFilter: dateFilter ?? this.dateFilter,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  bool get hasFilters => statusFilter != null || dateFilter != null;

  @override
  List<Object?> get props => [dateFilter, statusFilter];
}
