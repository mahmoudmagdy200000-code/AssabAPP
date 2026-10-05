import '../../features/recurring_orders/domain/strategies/recurring_order_status_strategy.dart';

enum RecurringOrderStatusEnum {
  inProgress('in_progress'),
  pending('pending'),
  paused('paused'),
  generated('generated'),
  completed('completed'),
  canceled('canceled');

  final String _value;

  const RecurringOrderStatusEnum(this._value);

  String get value => _value;

  factory RecurringOrderStatusEnum.fromString(String value) {
    return RecurringOrderStatusEnum.values.firstWhere(
      (e) => e._value.toLowerCase() == value.toLowerCase(),
      orElse: () => pending,
    );
  }

  RecurringOrderStatusStrategy get strategy {
    switch (this) {
      case RecurringOrderStatusEnum.inProgress:
        return InProgressRecurringOrderStatusStrategy();
      case RecurringOrderStatusEnum.pending:
        return PendingRecurringOrderStatusStrategy();
      case RecurringOrderStatusEnum.paused:
        return PausedRecurringOrderStatusStrategy();
      case RecurringOrderStatusEnum.generated:
        return GeneratedRecurringOrderStatusStrategy();
      case RecurringOrderStatusEnum.completed:
        return CompletedRecurringOrderStatusStrategy();
      case RecurringOrderStatusEnum.canceled:
        return CanceledRecurringOrderStatusStrategy();
    }
  }
}
