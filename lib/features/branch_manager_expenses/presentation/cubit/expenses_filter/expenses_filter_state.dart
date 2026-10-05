import 'package:assab/core/enums/expenses_filter_keys.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/enums/filter_status.dart';

class ExpensesFilterState extends Equatable {
  final Map<ExpensesFilterKeys, bool> type;
  final Map<FilterStatus, bool> status;
  final Map<TimeKeys, bool> sortBy;

  const ExpensesFilterState({
    required this.type,
    required this.status,
    required this.sortBy,
  });

  ExpensesFilterState copyWith({
    Map<ExpensesFilterKeys, bool>? type,
    Map<FilterStatus, bool>? status,
    Map<TimeKeys, bool>? sortBy,
  }) {
    return ExpensesFilterState(
      type: type ?? this.type,
      status: status ?? this.status,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object> get props => [type, status, sortBy];
}
