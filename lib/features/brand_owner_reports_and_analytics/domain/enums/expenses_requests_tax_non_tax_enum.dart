import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum ExpensesRequestsTaxNonTaxEnum {
  tax('tax'),
  nonTax('non_tax');

  final String _value;

  const ExpensesRequestsTaxNonTaxEnum(this._value);

  String get value => _value;

  Color expensesColor(BuildContext context) {
    switch (this) {
      case ExpensesRequestsTaxNonTaxEnum.tax:
        return context.theme.primaryColor;
      case ExpensesRequestsTaxNonTaxEnum.nonTax:
        return context.theme.primaryColor.withValues(alpha: 0.4);
    }
  }

  String expensesLabel(BuildContext context) {
    switch (this) {
      case ExpensesRequestsTaxNonTaxEnum.tax:
        return context.tr.taxRequests;
      case ExpensesRequestsTaxNonTaxEnum.nonTax:
        return context.tr.nonTaxRequests;
    }
  }
}
