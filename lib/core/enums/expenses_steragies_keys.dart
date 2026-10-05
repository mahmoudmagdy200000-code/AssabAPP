import '../../features/branch_manager_expenses/domain/strategies/expenses_strategy.dart';

enum ExpensesStrategiesKeys {
  quickCash('quick_cash'),
  preApproval('pre_approval'),
  singleInvoice('single_invoice'),
  groupedInvoice('grouped_invoice');

  final String _key;

  const ExpensesStrategiesKeys(this._key);

  String get key => _key;

  static ExpensesStrategiesKeys fromType(String key) {
    return ExpensesStrategiesKeys.values.firstWhere(
      (element) => element.key.toLowerCase() == key.toLowerCase(),
      orElse: () => throw Exception('Unknown expense strategy key: $key'),
    );
  }

  ExpensesStrategy get strategy {
    switch (this) {
      case ExpensesStrategiesKeys.quickCash:
        return QuickCashExpensesStrategy();
      case ExpensesStrategiesKeys.preApproval:
        return PreApprovalExpensesStrategy();
      case ExpensesStrategiesKeys.singleInvoice:
        return SingleInvoiceExpensesStrategy();
      case ExpensesStrategiesKeys.groupedInvoice:
        return GroupedInvoiceExpensesStrategy();
    }
  }
}
