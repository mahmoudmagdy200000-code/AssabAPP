import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum RecurringOrderSmartSettingsEnum {
  autoAdjustQuantitiesBasedOnConsumption(
    'auto_adjust_quantities_based_on_consumption',
  ),
  freezeDuringHolidaysAndEvents('freeze_during_holidays_and_events'),
  notifyWhenPricesChange('notify_when_prices_change');

  final String _value;

  const RecurringOrderSmartSettingsEnum(this._value);

  String get value => _value;

  static RecurringOrderSmartSettingsEnum fromValue(String value) {
    return RecurringOrderSmartSettingsEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid RecurringOrderSmartSettingsEnum value: $value',
      ),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case RecurringOrderSmartSettingsEnum
          .autoAdjustQuantitiesBasedOnConsumption:
        return context.tr.autoAdjustQuantitiesBasedOnConsumption;
      case RecurringOrderSmartSettingsEnum.freezeDuringHolidaysAndEvents:
        return context.tr.freezeDuringHolidaysAndEvents;
      case RecurringOrderSmartSettingsEnum.notifyWhenPricesChange:
        return context.tr.notifyWhenPricesChange;
    }
  }
}
