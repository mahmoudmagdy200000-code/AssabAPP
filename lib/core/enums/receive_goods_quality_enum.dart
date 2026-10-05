import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum ReceiveGoodsQualityEnum {
  non('non'),
  excellent('excellent'),
  normal('normal'),
  poor('poor');

  final String _value;

  const ReceiveGoodsQualityEnum(this._value);

  @override
  String toString() => _value;

  static ReceiveGoodsQualityEnum fromString(String value) {
    return ReceiveGoodsQualityEnum.values.firstWhere(
      (e) => e._value == value,
      orElse: () => ReceiveGoodsQualityEnum.non,
    );
  }

  String getString(BuildContext context) {
    switch (this) {
      case ReceiveGoodsQualityEnum.non:
        return '';
      case ReceiveGoodsQualityEnum.excellent:
        return context.tr.excellent;
      case ReceiveGoodsQualityEnum.normal:
        return context.tr.normal;
      case ReceiveGoodsQualityEnum.poor:
        return context.tr.poor;
    }
  }
}
