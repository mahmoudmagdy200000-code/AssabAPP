import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum RecurringSettingRepeatType {
  byDate('by_date'),
  byPattern('by_pattern');

  final String _value;

  const RecurringSettingRepeatType(this._value);

  String get value => _value;

  static RecurringSettingRepeatType fromValue(String value) {
    return RecurringSettingRepeatType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RecurringSettingRepeatType.byDate,
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case RecurringSettingRepeatType.byDate:
        return context.tr.byDate;
      case RecurringSettingRepeatType.byPattern:
        return context.tr.byPattern;
    }
  }
}
