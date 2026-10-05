import 'package:equatable/equatable.dart';

import '../../../../../core/strategies/priorities_strategy.dart';

class SelectPriorityState extends Equatable {
  final PrioritiesStrategy? selectedPriority;

  const SelectPriorityState({this.selectedPriority});

  SelectPriorityState copyWith({PrioritiesStrategy? selectedPriority}) {
    return SelectPriorityState(
      selectedPriority: selectedPriority ?? this.selectedPriority,
    );
  }

  @override
  List<Object?> get props => [selectedPriority];
}
