import 'package:assab/core/enums/priority_type.dart';
import 'package:assab/core/strategies/priority_registry.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/strategies/priorities_strategy.dart';
import '../../helpers/safe_cubit.dart';
import 'select_priority_state.dart';

@injectable
class SelectPriorityCubit extends SafeCubit<SelectPriorityState> {
  SelectPriorityCubit() : super(const SelectPriorityState()) {
    _registerAllPriorities();
  }

  void _registerAllPriorities() {
    PriorityRegistry.register(
      PriorityType.normal.value,
      () => NormalPriorityStrategy(),
    );
    PriorityRegistry.register(
      PriorityType.low.value,
      () => LowPriorityStrategy(),
    );
    PriorityRegistry.register(
      PriorityType.medium.value,
      () => MediumPriorityStrategy(),
    );
    PriorityRegistry.register(
      PriorityType.high.value,
      () => HighPriorityStrategy(),
    );
  }

  void selectPriority(PrioritiesStrategy priority) {
    emit(state.copyWith(selectedPriority: priority));
  }
}
