import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

enum BrandOwnerExpensesPaymentMethodsEnum {
  cash('cash'),
  custody('custody'),
  supplier('supplier');

  final String _value;

  const BrandOwnerExpensesPaymentMethodsEnum(this._value);

  String get value => _value;

  static BrandOwnerExpensesPaymentMethodsEnum fromValue(String value) {
    return BrandOwnerExpensesPaymentMethodsEnum.values.firstWhere(
      (element) => element.value.toLowerCase() == value.toLowerCase(),
      orElse: () => BrandOwnerExpensesPaymentMethodsEnum.cash,
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case BrandOwnerExpensesPaymentMethodsEnum.cash:
        return context.tr.cash;
      case BrandOwnerExpensesPaymentMethodsEnum.custody:
        return context.tr.custody;
      case BrandOwnerExpensesPaymentMethodsEnum.supplier:
        return context.tr.supplier;
    }
  }

  String get icon {
    switch (this) {
      case BrandOwnerExpensesPaymentMethodsEnum.cash:
        return AppAssets.cash;
      case BrandOwnerExpensesPaymentMethodsEnum.custody:
        return AppAssets.custody;
      case BrandOwnerExpensesPaymentMethodsEnum.supplier:
        return AppAssets.personSvg;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case BrandOwnerExpensesPaymentMethodsEnum.cash:
        return context.theme.primaryColor.withValues(alpha: 0.4);
      case BrandOwnerExpensesPaymentMethodsEnum.custody:
        return context.customColor.text1;
      case BrandOwnerExpensesPaymentMethodsEnum.supplier:
        return context.customColor.text3.withValues(alpha: 0.4);
    }
  }
}
