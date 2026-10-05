import 'package:assab/core/strategies/priorities_strategy.dart';

class PriorityRegistry {
  static final Map<String, PrioritiesStrategy Function()> _priorities = {};

  static void register(String type, PrioritiesStrategy Function() creator) {
    _priorities[type] = creator;
  }

  static PrioritiesStrategy fromType(String type) {
    final creator = _priorities[type];

    if (creator == null) {
      throw Exception('Unknown priority type: $type');
    }

    return creator();
  }

  static List<PrioritiesStrategy> get getAllPriorities {
    return _priorities.values.map((creator) => creator()).toList();
  }
}
