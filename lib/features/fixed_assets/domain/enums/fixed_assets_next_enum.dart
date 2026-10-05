import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum FixedAssetsNextEnum {
  needTechnician('need_technician'),
  halt('halt'),
  replace('replace');

  final String _value;

  const FixedAssetsNextEnum(this._value);

  String get value => _value;

  static FixedAssetsNextEnum fromValue(String value) {
    return FixedAssetsNextEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case FixedAssetsNextEnum.needTechnician:
        return context.tr.needTechnician;
      case FixedAssetsNextEnum.halt:
        return context.tr.halt;
      case FixedAssetsNextEnum.replace:
        return context.tr.replace;
    }
  }
}
