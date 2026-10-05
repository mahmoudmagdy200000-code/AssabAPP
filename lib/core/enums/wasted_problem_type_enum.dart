import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum WastedProblemTypeEnum {
  waste('waste'),
  damage('damage');

  final String _value;

  const WastedProblemTypeEnum(this._value);

  String get value => _value;

  static WastedProblemTypeEnum fromString(String value) {
    return WastedProblemTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => waste,
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case WastedProblemTypeEnum.waste:
        return context.tr.waste;
      case WastedProblemTypeEnum.damage:
        return context.tr.damage;
    }
  }
}
