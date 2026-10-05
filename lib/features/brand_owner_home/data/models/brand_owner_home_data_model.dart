// ---------------------------------------------------------------------------
// brand_owner_home_data_model.dart
// ---------------------------------------------------------------------------

/// Trend stats for a single granularity (daily / weekly / monthly).
/// Keeps the main model clean — summary fields don't re-fetch when the
/// user toggles granularity; only the active GranularityTrendData changes.
class GranularityTrendData {
  final String trendPeriod;
  final int approved;
  final double totalAmount;
  final double increasePercentage;
  final List<double> chartData;

  const GranularityTrendData({
    required this.trendPeriod,
    required this.approved,
    required this.totalAmount,
    required this.increasePercentage,
    required this.chartData,
  });

  factory GranularityTrendData.fromJson(Map<String, dynamic> json) {
    return GranularityTrendData(
      trendPeriod: json['trend_period'] as String? ?? '',
      approved: (json['approved'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      increasePercentage:
          (json['increase_percentage'] as num?)?.toDouble() ?? 0.0,
      chartData:
          (json['chart_data'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'trend_period': trendPeriod,
    'approved': approved,
    'total_amount': totalAmount,
    'increase_percentage': increasePercentage,
    'chart_data': chartData,
  };

  GranularityTrendData copyWith({
    String? trendPeriod,
    int? approved,
    double? totalAmount,
    double? increasePercentage,
    List<double>? chartData,
  }) {
    return GranularityTrendData(
      trendPeriod: trendPeriod ?? this.trendPeriod,
      approved: approved ?? this.approved,
      totalAmount: totalAmount ?? this.totalAmount,
      increasePercentage: increasePercentage ?? this.increasePercentage,
      chartData: chartData ?? this.chartData,
    );
  }

  // ── Mock helpers ──────────────────────────────────────────────────────────

  static GranularityTrendData mockDaily({int month = 6, int year = 2026}) =>
      GranularityTrendData(
        trendPeriod: _monthName(month, year, granularity: 'daily'),
        approved: 5,
        totalAmount: 2000.0,
        increasePercentage: 12.5,
        chartData: [10000.0, 25000.0, 50000.0, 75000.0],
      );

  static GranularityTrendData mockWeekly({int month = 6, int year = 2026}) =>
      GranularityTrendData(
        trendPeriod: _monthName(month, year, granularity: 'weekly'),
        approved: 18,
        totalAmount: 9500.0,
        increasePercentage: 8.0,
        chartData: [20000.0, 40000.0, 30000.0, 60000.0, 80000.0],
      );

  static GranularityTrendData mockMonthly({int month = 6, int year = 2026}) =>
      GranularityTrendData(
        trendPeriod: _monthName(month, year, granularity: 'monthly'),
        approved: 65,
        totalAmount: 38000.0,
        increasePercentage: 15.3,
        chartData: [15000.0, 30000.0, 45000.0, 60000.0],
      );
}

// ---------------------------------------------------------------------------

class BrandOwnerHomeDataModel {
  // ── Invoice summary (stable per branch + month filter) ───────────────────
  final int approvedInvoices;
  final double totalInvoiceAmount;
  final int pendingInvoices;

  // ── Expense summary (stable per branch + month filter) ───────────────────
  final int approvedExpenses;
  final double totalExpenseAmount;
  final int pendingExpenses;

  // ── Granularity-keyed trend data ─────────────────────────────────────────
  /// Keys: 'daily' | 'weekly' | 'monthly'
  /// The screen reads whichever key the PagingCubit selects; no extra network
  /// call is needed when the user toggles between granularities.
  final Map<String, GranularityTrendData> granularityChartData;

  // ── Response context ─────────────────────────────────────────────────────
  final int responseMonth;
  final int responseYear;
  final String responseBranchName;

  const BrandOwnerHomeDataModel({
    required this.approvedInvoices,
    required this.totalInvoiceAmount,
    required this.pendingInvoices,
    required this.approvedExpenses,
    required this.totalExpenseAmount,
    required this.pendingExpenses,
    required this.granularityChartData,
    required this.responseMonth,
    required this.responseYear,
    required this.responseBranchName,
  });

  // ── Convenience getters ──────────────────────────────────────────────────

  GranularityTrendData? trendFor(String granularity) =>
      granularityChartData[granularity];

  GranularityTrendData get dailyTrend =>
      granularityChartData['daily'] ?? GranularityTrendData.mockDaily();

  GranularityTrendData get weeklyTrend =>
      granularityChartData['weekly'] ?? GranularityTrendData.mockWeekly();

  GranularityTrendData get monthlyTrend =>
      granularityChartData['monthly'] ?? GranularityTrendData.mockMonthly();

  // ── fromJson ─────────────────────────────────────────────────────────────

  factory BrandOwnerHomeDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawTrends =
        data['granularity_chart_data'] as Map<String, dynamic>? ?? {};

    final granularityChartData = <String, GranularityTrendData>{
      for (final entry in rawTrends.entries)
        entry.key: GranularityTrendData.fromJson(
          entry.value as Map<String, dynamic>,
        ),
    };

    return BrandOwnerHomeDataModel(
      approvedInvoices: (data['approved_invoices'] as num?)?.toInt() ?? 0,
      totalInvoiceAmount:
          (data['total_invoice_amount'] as num?)?.toDouble() ?? 0.0,
      pendingInvoices: (data['pending_invoices'] as num?)?.toInt() ?? 0,
      approvedExpenses: (data['approved_expenses'] as num?)?.toInt() ?? 0,
      totalExpenseAmount:
          (data['total_expense_amount'] as num?)?.toDouble() ?? 0.0,
      pendingExpenses: (data['pending_expenses'] as num?)?.toInt() ?? 0,
      granularityChartData: granularityChartData,
      responseMonth: (data['response_month'] as num?)?.toInt() ?? 0,
      responseYear: (data['response_year'] as num?)?.toInt() ?? 0,
      responseBranchName: (data['response_branch_name'] as String?) ?? '',
    );
  }

  // ── toJson ───────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'approved_invoices': approvedInvoices,
    'total_invoice_amount': totalInvoiceAmount,
    'pending_invoices': pendingInvoices,
    'approved_expenses': approvedExpenses,
    'total_expense_amount': totalExpenseAmount,
    'pending_expenses': pendingExpenses,
    'granularity_chart_data': {
      for (final entry in granularityChartData.entries)
        entry.key: entry.value.toJson(),
    },
    'response_month': responseMonth,
    'response_year': responseYear,
    'response_branch_name': responseBranchName,
  };

  // ── copyWith ─────────────────────────────────────────────────────────────

  BrandOwnerHomeDataModel copyWith({
    int? approvedInvoices,
    double? totalInvoiceAmount,
    int? pendingInvoices,
    int? approvedExpenses,
    double? totalExpenseAmount,
    int? pendingExpenses,
    Map<String, GranularityTrendData>? granularityChartData,
    int? responseMonth,
    int? responseYear,
    String? responseBranchName,
  }) {
    return BrandOwnerHomeDataModel(
      approvedInvoices: approvedInvoices ?? this.approvedInvoices,
      totalInvoiceAmount: totalInvoiceAmount ?? this.totalInvoiceAmount,
      pendingInvoices: pendingInvoices ?? this.pendingInvoices,
      approvedExpenses: approvedExpenses ?? this.approvedExpenses,
      totalExpenseAmount: totalExpenseAmount ?? this.totalExpenseAmount,
      pendingExpenses: pendingExpenses ?? this.pendingExpenses,
      granularityChartData: granularityChartData ?? this.granularityChartData,
      responseMonth: responseMonth ?? this.responseMonth,
      responseYear: responseYear ?? this.responseYear,
      responseBranchName: responseBranchName ?? this.responseBranchName,
    );
  }

  // ── Mock ─────────────────────────────────────────────────────────────────

  static BrandOwnerHomeDataModel mock({
    int? branchId,
    int month = 6,
    int year = 2026,
  }) {
    return BrandOwnerHomeDataModel(
      approvedInvoices: 12,
      totalInvoiceAmount: 45000.0,
      pendingInvoices: 3,
      approvedExpenses: 8,
      totalExpenseAmount: 28500.0,
      pendingExpenses: 5,
      granularityChartData: {
        'daily': GranularityTrendData.mockDaily(month: month, year: year),
        'weekly': GranularityTrendData.mockWeekly(month: month, year: year),
        'monthly': GranularityTrendData.mockMonthly(month: month, year: year),
      },
      responseMonth: month,
      responseYear: year,
      responseBranchName: 'Branch ${branchId ?? 1}',
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

const _monthNames = [
  '', // 1-indexed
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String _monthName(int month, int year, {required String granularity}) {
  final name = _monthNames[month.clamp(1, 12)];
  return switch (granularity) {
    'daily' => '$name 5 (Week 1)',
    'weekly' => '$name $year (Week 1-4)',
    _ => '$name $year',
  };
}
