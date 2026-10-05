import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum PaymentMethod {
  cash,
  supplier,
  custody;

  String paymentMethodToString() {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.supplier:
        return 'supplier';
      case PaymentMethod.custody:
        return 'custody';
    }
  }

  String displayName(BuildContext context) {
    switch (this) {
      case PaymentMethod.cash:
        return context.tr.cash;
      case PaymentMethod.supplier:
        return context.tr.supplier;
      case PaymentMethod.custody:
        return context.tr.custodyBalance;
    }
  }
}

extension PaymentMethodExtension on String {
  PaymentMethod toPaymentMethod() {
    switch (this) {
      case 'cash':
        return PaymentMethod.cash;
      case 'supplier':
        return PaymentMethod.supplier;
      case 'custody':
        return PaymentMethod.custody;
      default:
        return PaymentMethod.cash;
    }
  }
}
