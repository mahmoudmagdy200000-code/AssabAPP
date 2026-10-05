import 'brand_owner_expense_report_filter_entity.dart';

class ExpenseReportBranchEntity {
  final String id;
  final String name;
  final String imageUrl;

  const ExpenseReportBranchEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class ExpenseReportSummaryEntity {
  final ExpenseReportBranchEntity branch;
  final String periodLabel;
  final int totalRequests;
  final double totalAmount;
  final String trendPercent;
  final String trendLabel;
  final bool trendIsUp;

  const ExpenseReportSummaryEntity({
    required this.branch,
    required this.periodLabel,
    required this.totalRequests,
    required this.totalAmount,
    required this.trendPercent,
    required this.trendLabel,
    required this.trendIsUp,
  });
}

class ExpenseReportPaymentMethodEntity {
  final String method;
  final int count;
  final double amount;

  const ExpenseReportPaymentMethodEntity({
    required this.method,
    required this.count,
    required this.amount,
  });
}

class ExpenseReportSupplierEntity {
  final String name;
  final double amount;

  const ExpenseReportSupplierEntity({
    required this.name,
    required this.amount,
  });
}

class ExpenseReportRatioEntity {
  final String type;
  final int count;
  final double amount;

  const ExpenseReportRatioEntity({
    required this.type,
    required this.count,
    required this.amount,
  });
}

class ExpenseReportBranchComparisonEntity {
  final String name;
  final double amount;
  final double maxAmount;

  const ExpenseReportBranchComparisonEntity({
    required this.name,
    required this.amount,
    required this.maxAmount,
  });
}

class ExpenseReportPaymentLogEntity {
  final String method;
  final String subLabel;
  final String branch;
  final String dateTime;
  final double amount;

  const ExpenseReportPaymentLogEntity({
    required this.method,
    required this.subLabel,
    required this.branch,
    required this.dateTime,
    required this.amount,
  });
}

class ExpenseReportCashTransferLogEntity {
  final double totalCashIn;
  final double totalCashOut;
  final int count;
  final List<ExpenseReportPaymentLogEntity> logs;

  const ExpenseReportCashTransferLogEntity({
    required this.totalCashIn,
    required this.totalCashOut,
    required this.count,
    required this.logs,
  });
}

class ExpenseReportQuickSummaryEntity {
  final double amount;
  final String trendPercent;
  final String trendLabel;
  final bool trendIsUp;

  const ExpenseReportQuickSummaryEntity({
    required this.amount,
    required this.trendPercent,
    required this.trendLabel,
    required this.trendIsUp,
  });
}

class BrandOwnerExpenseReportDetailsEntity {
  final ExpenseReportSummaryEntity summary;
  final List<ExpenseReportPaymentMethodEntity> paymentMethods;
  final List<ExpenseReportSupplierEntity> topSuppliers;
  final List<ExpenseReportRatioEntity> expenseRatios;
  final List<ExpenseReportBranchComparisonEntity> branchComparisons;
  final ExpenseReportCashTransferLogEntity cashTransferLog;
  final ExpenseReportQuickSummaryEntity quickSummary;
  final ExpenseReportBranchEntity defaultBranch;
  final BrandOwnerExpenseReportFilterEntity filters;

  const BrandOwnerExpenseReportDetailsEntity({
    required this.summary,
    required this.paymentMethods,
    required this.topSuppliers,
    required this.expenseRatios,
    required this.branchComparisons,
    required this.cashTransferLog,
    required this.quickSummary,
    required this.defaultBranch,
    required this.filters,
  });
}
