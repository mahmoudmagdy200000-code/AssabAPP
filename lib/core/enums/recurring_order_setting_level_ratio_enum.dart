import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum RecurringOrderSettingLevelRatioEnum {
  l10Percent('10'),
  l20Percent('20'),
  l40Percent('40'),
  custom('Custom');

  final String _value;

  const RecurringOrderSettingLevelRatioEnum(this._value);

  String get value => _value;

  static RecurringOrderSettingLevelRatioEnum fromValue(String value) {
    return RecurringOrderSettingLevelRatioEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid RecurringOrderSettingLevelRatioEnum value: $value',
      ),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case RecurringOrderSettingLevelRatioEnum.l10Percent:
        return '10%';
      case RecurringOrderSettingLevelRatioEnum.l20Percent:
        return '20%';
      case RecurringOrderSettingLevelRatioEnum.l40Percent:
        return '40%';
      case RecurringOrderSettingLevelRatioEnum.custom:
        return context.tr.custom;
    }
  }
}
