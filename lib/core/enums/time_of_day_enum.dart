import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum TimeOfDayEnum {
  am('am'),
  pm('pm');

  final String _value;

  const TimeOfDayEnum(this._value);

  String get value => _value;

  static TimeOfDayEnum fromValue(String value) {
    return TimeOfDayEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TimeOfDayEnum value: $value'),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case TimeOfDayEnum.am:
        return context.tr.am;
      case TimeOfDayEnum.pm:
        return context.tr.pm;
    }
  }
}
