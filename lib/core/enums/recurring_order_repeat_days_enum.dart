import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum RecurringOrderRepeatDaysEnum {
  sun(1),
  mon(2),
  tue(3),
  wed(4),
  thu(5),
  fri(6),
  sat(7);

  final int _value;

  const RecurringOrderRepeatDaysEnum(this._value);
  int get value => _value;

  static RecurringOrderRepeatDaysEnum fromValue(int value) {
    return RecurringOrderRepeatDaysEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => sun,
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case RecurringOrderRepeatDaysEnum.sun:
        return context.tr.sun;
      case RecurringOrderRepeatDaysEnum.mon:
        return context.tr.mon;
      case RecurringOrderRepeatDaysEnum.tue:
        return context.tr.tue;
      case RecurringOrderRepeatDaysEnum.wed:
        return context.tr.wed;
      case RecurringOrderRepeatDaysEnum.thu:
        return context.tr.thu;
      case RecurringOrderRepeatDaysEnum.fri:
        return context.tr.fri;
      case RecurringOrderRepeatDaysEnum.sat:
        return context.tr.sat;
    }
  }
}
