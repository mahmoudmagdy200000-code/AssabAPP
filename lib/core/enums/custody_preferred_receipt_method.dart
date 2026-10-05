import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../strategies/custody_preferred_receipt_method_strategy.dart';

enum CustodyPreferredReceiptMethod {
  bankTransfer('bank_transfer'),
  cashHandover('cash_handover');

  final String _value;

  const CustodyPreferredReceiptMethod(this._value);

  String get value => _value;

  static CustodyPreferredReceiptMethod fromValue(String value) {
    return CustodyPreferredReceiptMethod.values.firstWhere(
      (element) => element.value == value,
    );
  }

  CustodyPreferredReceiptMethodStrategy get strategy {
    switch (this) {
      case CustodyPreferredReceiptMethod.bankTransfer:
        return BankTransferPreferredReceiptMethodStrategy();
      case CustodyPreferredReceiptMethod.cashHandover:
        return CashHandoverPreferredReceiptMethodStrategy();
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case CustodyPreferredReceiptMethod.bankTransfer:
        return context.tr.bankTransfer;
      case CustodyPreferredReceiptMethod.cashHandover:
        return context.tr.cashHandover;
    }
  }

  String get icon {
    switch (this) {
      case CustodyPreferredReceiptMethod.bankTransfer:
        return AppAssets.bankSvg;
      case CustodyPreferredReceiptMethod.cashHandover:
        return AppAssets.cashHandoverSvg;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case CustodyPreferredReceiptMethod.bankTransfer:
        return context.theme.primaryColor.withValues(alpha: 0.4);
      case CustodyPreferredReceiptMethod.cashHandover:
        return context.customColor.text1;
    }
  }
}
