import '../../domain/entities/brand_owner_expense_report_details_entity.dart';
import 'brand_owner_expense_report_details_filter_model.dart';

class ExpenseReportBranchModel {
  final String id;
  final String name;
  final String imageUrl;

  const ExpenseReportBranchModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ExpenseReportBranchModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportBranchModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  ExpenseReportBranchEntity toEntity() {
    return ExpenseReportBranchEntity(id: id, name: name, imageUrl: imageUrl);
  }
}

class ExpenseReportSummaryModel {
  final ExpenseReportBranchModel branch;
  final String periodLabel;
  final int totalRequests;
  final double totalAmount;
  final String trendPercent;
  final String trendLabel;
  final bool trendIsUp;

  const ExpenseReportSummaryModel({
    required this.branch,
    required this.periodLabel,
    required this.totalRequests,
    required this.totalAmount,
    required this.trendPercent,
    required this.trendLabel,
    required this.trendIsUp,
  });

  factory ExpenseReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportSummaryModel(
      branch: ExpenseReportBranchModel.fromJson(
        json['branch'] as Map<String, dynamic>? ?? const {},
      ),
      periodLabel: json['period_label']?.toString() ?? '',
      totalRequests: (json['total_requests'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      trendPercent: json['trend_percent']?.toString() ?? '',
      trendLabel: json['trend_label']?.toString() ?? '',
      trendIsUp: json['trend_is_up'] as bool? ?? false,
    );
  }

  ExpenseReportSummaryEntity toEntity() {
    return ExpenseReportSummaryEntity(
      branch: branch.toEntity(),
      periodLabel: periodLabel,
      totalRequests: totalRequests,
      totalAmount: totalAmount,
      trendPercent: trendPercent,
      trendLabel: trendLabel,
      trendIsUp: trendIsUp,
    );
  }
}

class ExpenseReportPaymentMethodModel {
  final String method;
  final int count;
  final double amount;

  const ExpenseReportPaymentMethodModel({
    required this.method,
    required this.count,
    required this.amount,
  });

  factory ExpenseReportPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportPaymentMethodModel(
      method: json['method']?.toString() ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ExpenseReportPaymentMethodEntity toEntity() {
    return ExpenseReportPaymentMethodEntity(
      method: method,
      count: count,
      amount: amount,
    );
  }
}

class ExpenseReportSupplierModel {
  final String name;
  final double amount;

  const ExpenseReportSupplierModel({required this.name, required this.amount});

  factory ExpenseReportSupplierModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportSupplierModel(
      name: json['name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ExpenseReportSupplierEntity toEntity() {
    return ExpenseReportSupplierEntity(name: name, amount: amount);
  }
}

class ExpenseReportRatioModel {
  final String type;
  final int count;
  final double amount;

  const ExpenseReportRatioModel({
    required this.type,
    required this.count,
    required this.amount,
  });

  factory ExpenseReportRatioModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportRatioModel(
      type: json['type']?.toString() ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ExpenseReportRatioEntity toEntity() {
    return ExpenseReportRatioEntity(type: type, count: count, amount: amount);
  }
}

class ExpenseReportBranchComparisonModel {
  final String name;
  final double amount;
  final double maxAmount;

  const ExpenseReportBranchComparisonModel({
    required this.name,
    required this.amount,
    required this.maxAmount,
  });

  factory ExpenseReportBranchComparisonModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExpenseReportBranchComparisonModel(
      name: json['name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      maxAmount: (json['max_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ExpenseReportBranchComparisonEntity toEntity() {
    return ExpenseReportBranchComparisonEntity(
      name: name,
      amount: amount,
      maxAmount: maxAmount,
    );
  }
}

class ExpenseReportPaymentLogModel {
  final String method;
  final String subLabel;
  final String branch;
  final String dateTime;
  final double amount;

  const ExpenseReportPaymentLogModel({
    required this.method,
    required this.subLabel,
    required this.branch,
    required this.dateTime,
    required this.amount,
  });

  factory ExpenseReportPaymentLogModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportPaymentLogModel(
      method: json['method']?.toString() ?? '',
      subLabel: json['sub_label']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      dateTime: json['date_time']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ExpenseReportPaymentLogEntity toEntity() {
    return ExpenseReportPaymentLogEntity(
      method: method,
      subLabel: subLabel,
      branch: branch,
      dateTime: dateTime,
      amount: amount,
    );
  }
}

class ExpenseReportCashTransferLogModel {
  final double totalCashIn;
  final double totalCashOut;
  final int count;
  final List<ExpenseReportPaymentLogModel> logs;

  const ExpenseReportCashTransferLogModel({
    required this.totalCashIn,
    required this.totalCashOut,
    required this.count,
    required this.logs,
  });

  factory ExpenseReportCashTransferLogModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final logsJson = json['logs'] as List<dynamic>? ?? [];

    return ExpenseReportCashTransferLogModel(
      totalCashIn: (json['total_cash_in'] as num?)?.toDouble() ?? 0.0,
      totalCashOut: (json['total_cash_out'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      logs: logsJson
          .map(
            (item) => ExpenseReportPaymentLogModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  ExpenseReportCashTransferLogEntity toEntity() {
    return ExpenseReportCashTransferLogEntity(
      totalCashIn: totalCashIn,
      totalCashOut: totalCashOut,
      count: count,
      logs: logs.map((log) => log.toEntity()).toList(),
    );
  }
}

class ExpenseReportQuickSummaryModel {
  final double amount;
  final String trendPercent;
  final String trendLabel;
  final bool trendIsUp;

  const ExpenseReportQuickSummaryModel({
    required this.amount,
    required this.trendPercent,
    required this.trendLabel,
    required this.trendIsUp,
  });

  factory ExpenseReportQuickSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportQuickSummaryModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      trendPercent: json['trend_percent']?.toString() ?? '',
      trendLabel: json['trend_label']?.toString() ?? '',
      trendIsUp: json['trend_is_up'] as bool? ?? false,
    );
  }

  ExpenseReportQuickSummaryEntity toEntity() {
    return ExpenseReportQuickSummaryEntity(
      amount: amount,
      trendPercent: trendPercent,
      trendLabel: trendLabel,
      trendIsUp: trendIsUp,
    );
  }
}

class BrandOwnerExpenseReportDetailsResponseModel {
  final ExpenseReportSummaryModel summary;
  final List<ExpenseReportPaymentMethodModel> paymentMethods;
  final List<ExpenseReportSupplierModel> topSuppliers;
  final List<ExpenseReportRatioModel> expenseRatios;
  final List<ExpenseReportBranchComparisonModel> branchComparisons;
  final ExpenseReportCashTransferLogModel cashTransferLog;
  final ExpenseReportQuickSummaryModel quickSummary;
  final ExpenseReportBranchModel defaultBranch;
  final BrandOwnerExpenseReportDetailsFilterModel filters;

  const BrandOwnerExpenseReportDetailsResponseModel({
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

  factory BrandOwnerExpenseReportDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final methodsJson = data['payment_methods'] as List<dynamic>? ?? [];
    final suppliersJson = data['top_suppliers'] as List<dynamic>? ?? [];
    final ratiosJson = data['expense_ratios'] as List<dynamic>? ?? [];
    final branchesJson = data['branch_comparisons'] as List<dynamic>? ?? [];
    final filtersJson = data['filters'] as Map<String, dynamic>?;

    return BrandOwnerExpenseReportDetailsResponseModel(
      summary: ExpenseReportSummaryModel.fromJson(
        data['summary'] as Map<String, dynamic>? ?? const {},
      ),

      paymentMethods: methodsJson
          .map(
            (item) => ExpenseReportPaymentMethodModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      topSuppliers: suppliersJson
          .map(
            (item) => ExpenseReportSupplierModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      expenseRatios: ratiosJson
          .map(
            (item) =>
                ExpenseReportRatioModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      branchComparisons: branchesJson
          .map(
            (item) => ExpenseReportBranchComparisonModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      cashTransferLog: ExpenseReportCashTransferLogModel.fromJson(
        data['cash_transfer_log'] as Map<String, dynamic>? ?? const {},
      ),

      quickSummary: ExpenseReportQuickSummaryModel.fromJson(
        data['quick_summary'] as Map<String, dynamic>? ?? const {},
      ),

      defaultBranch: ExpenseReportBranchModel.fromJson(
        data['default_branch'] as Map<String, dynamic>? ?? const {},
      ),

      filters: BrandOwnerExpenseReportDetailsFilterModel(
        type: filtersJson?['type']?.toString(),
        status: filtersJson?['status']?.toString(),
        month: (filtersJson?['month'] as num?)?.toInt(),
        year: (filtersJson?['year'] as num?)?.toInt(),
        branchId: filtersJson?['branch_id']?.toString(),
        branchName: filtersJson?['branch_name']?.toString(),
      ),
    );
  }

  BrandOwnerExpenseReportDetailsEntity toEntity() {
    return BrandOwnerExpenseReportDetailsEntity(
      summary: summary.toEntity(),
      paymentMethods: paymentMethods
          .map((method) => method.toEntity())
          .toList(),
      topSuppliers: topSuppliers
          .map((supplier) => supplier.toEntity())
          .toList(),
      expenseRatios: expenseRatios.map((ratio) => ratio.toEntity()).toList(),
      branchComparisons: branchComparisons
          .map((comparison) => comparison.toEntity())
          .toList(),
      cashTransferLog: cashTransferLog.toEntity(),
      quickSummary: quickSummary.toEntity(),
      defaultBranch: defaultBranch.toEntity(),
      filters: filters.toEntity(),
    );
  }
}
