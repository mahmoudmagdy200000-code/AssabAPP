import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum FixedAssetsDoneEnum {
  initialCheck('initial_check'),
  cleaning('cleaning');

  final String _value;

  const FixedAssetsDoneEnum(this._value);

  String get value => _value;

  static FixedAssetsDoneEnum fromValue(String value) {
    return FixedAssetsDoneEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case FixedAssetsDoneEnum.initialCheck:
        return context.tr.initialCheck;
      case FixedAssetsDoneEnum.cleaning:
        return context.tr.cleaning;
    }
  }
}
