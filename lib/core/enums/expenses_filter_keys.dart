import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum ExpensesFilterKeys {
  all(''),
  draft('draft'),
  quickCash('quick_cash'),
  singleInvoice('single_invoice'),
  groupedInvoice('grouped_invoice'),
  preApproval('pre_approval'),
  non('');

  final String _key;
  const ExpensesFilterKeys(this._key);

  String get key => _key;

  String? getDisplayName(BuildContext context) {
    switch (this) {
      case ExpensesFilterKeys.all:
        return context.tr.all;
      case ExpensesFilterKeys.draft:
        return context.tr.draft;
      case ExpensesFilterKeys.quickCash:
        return context.tr.quickCashExpense;
      case ExpensesFilterKeys.singleInvoice:
        return context.tr.singleInvoice;
      case ExpensesFilterKeys.groupedInvoice:
        return context.tr.groupedInvoices;
      case ExpensesFilterKeys.preApproval:
        return context.tr.preApprovalRequest;
      case ExpensesFilterKeys.non:
        return null;
    }
  }
}
