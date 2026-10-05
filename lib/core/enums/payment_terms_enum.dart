import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum PaymentTermsEnum {
  non('non'),
  net7days('net7days'),
  net15days('net15days'),
  net30days('net30days'),
  net45days('net45days');

  final String _value;

  const PaymentTermsEnum(this._value);

  @override
  String toString() => _value;

  static PaymentTermsEnum fromString(String value) {
    return PaymentTermsEnum.values.firstWhere(
      (e) => e._value == value,
      orElse: () => PaymentTermsEnum.non,
    );
  }

  String getString(BuildContext context) {
    switch (this) {
      case PaymentTermsEnum.non:
        return '';
      case PaymentTermsEnum.net7days:
        return context.tr.net7days;
      case PaymentTermsEnum.net15days:
        return context.tr.net15days;
      case PaymentTermsEnum.net30days:
        return context.tr.net30days;
      case PaymentTermsEnum.net45days:
        return context.tr.net45days;
    }
  }
}
