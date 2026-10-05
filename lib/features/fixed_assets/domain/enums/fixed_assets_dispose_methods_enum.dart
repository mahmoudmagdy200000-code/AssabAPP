import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum FixedAssetsDisposeMethodsEnum {
  scrap('scrap'),
  sell('sell'),
  returnToSupplier('return_to_supplier'),
  other('other');

  final String _value;

  const FixedAssetsDisposeMethodsEnum(this._value);

  String get value => _value;

  factory FixedAssetsDisposeMethodsEnum.fromString(String value) {
    return FixedAssetsDisposeMethodsEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid dispose method: $value'),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case FixedAssetsDisposeMethodsEnum.scrap:
        return context.tr.scrap;
      case FixedAssetsDisposeMethodsEnum.sell:
        return context.tr.sell;
      case FixedAssetsDisposeMethodsEnum.returnToSupplier:
        return context.tr.returnToSupplier;
      case FixedAssetsDisposeMethodsEnum.other:
        return context.tr.other;
    }
  }
}
