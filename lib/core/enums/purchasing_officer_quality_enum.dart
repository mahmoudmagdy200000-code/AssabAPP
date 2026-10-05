import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum PurchasingOfficerQualityEnum {
  non('non'),
  economy('economy'),
  standard('standard'),
  premium('premium');

  final String _value;

  const PurchasingOfficerQualityEnum(this._value);

  @override
  String toString() => _value;

  static PurchasingOfficerQualityEnum fromString(String value) {
    return PurchasingOfficerQualityEnum.values.firstWhere(
      (e) => e._value == value,
      orElse: () => PurchasingOfficerQualityEnum.non,
    );
  }

  String getString(BuildContext context) {
    switch (this) {
      case PurchasingOfficerQualityEnum.non:
        return '';
      case PurchasingOfficerQualityEnum.economy:
        return context.tr.economy;
      case PurchasingOfficerQualityEnum.standard:
        return context.tr.standard;
      case PurchasingOfficerQualityEnum.premium:
        return context.tr.premium;
    }
  }
}
