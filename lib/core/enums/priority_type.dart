import 'package:assab/core/strategies/priorities_strategy.dart';

enum PriorityType {
  normal('normal'),
  low('low'),
  medium('medium'),
  high('high');

  final String _value;

  const PriorityType(this._value);

  String get value => _value;

  static PriorityType fromValue(String value) {
    return PriorityType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => PriorityType.normal,
    );
  }

  static PrioritiesStrategy getPriorityStrategy(PriorityType type) {
    switch (type) {
      case PriorityType.low:
        return LowPriorityStrategy();
      case PriorityType.medium:
        return MediumPriorityStrategy();
      case PriorityType.high:
        return HighPriorityStrategy();
      case PriorityType.normal:
        return NormalPriorityStrategy();
    }
  }
}
