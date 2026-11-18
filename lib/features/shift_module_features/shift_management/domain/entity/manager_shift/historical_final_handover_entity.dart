class HistoricalCashierBreakdownItemEntity {
  const HistoricalCashierBreakdownItemEntity({
    required this.cashierName,
    required this.totalSales,
    required this.cashCollected,
    required this.handoverAmount,
    required this.variance,
    required this.status,
  });

  final String cashierName;
  final double totalSales;
  final double cashCollected;
  final double handoverAmount;
  final double variance;
  final String status;

  factory HistoricalCashierBreakdownItemEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    double toDouble(dynamic v) =>
        v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '') ?? 0);

    return HistoricalCashierBreakdownItemEntity(
      cashierName:
          (json['cashier_name'] ?? json['name'] ?? 'N/A').toString(),
      totalSales: toDouble(json['total_sales']),
      cashCollected: toDouble(json['cash_collected']),
      handoverAmount: toDouble(json['handover_amount']),
      variance: toDouble(json['variance']),
      status: (json['status'] ?? '').toString(),
    );
  }
}

class HistoricalFinalHandoverEntity {
  const HistoricalFinalHandoverEntity({
    required this.shiftId,
    required this.shiftDate,
    required this.shiftStatus,
    required this.branchName,
    required this.managerName,
    required this.handoverAmount,
    required this.handoverStatus,
    required this.handoverFrom,
    required this.handoverTo,
    required this.handoverDate,
    required this.handoverTime,
    required this.handoverNotes,
    required this.variance,
    required this.totalSales,
    required this.netSales,
    required this.vatAmount,
    required this.cashCollected,
    required this.cardPayments,
    required this.aggregatorPayments,
    required this.dailyCloseSubmitted,
    this.dailyCloseSubmittedAt,
    required this.cashierBreakdown,
  });

  final String shiftId;
  final String shiftDate;
  final String shiftStatus;
  final String branchName;
  final String managerName;
  final double handoverAmount;
  final String handoverStatus;
  final String handoverFrom;
  final String handoverTo;
  final String handoverDate;
  final String handoverTime;
  final String? handoverNotes;
  final double variance;
  final double totalSales;
  final double netSales;
  final double vatAmount;
  final double cashCollected;
  final double cardPayments;
  final double aggregatorPayments;
  final bool dailyCloseSubmitted;
  final String? dailyCloseSubmittedAt;
  final List<HistoricalCashierBreakdownItemEntity> cashierBreakdown;

  factory HistoricalFinalHandoverEntity.fromApiPayload(
    Map<String, dynamic> data,
  ) {
    Map<String, dynamic> asMap(dynamic v) => v is Map<String, dynamic>
        ? v
        : (v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{});
    double toDouble(dynamic v) =>
        v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '') ?? 0);

    final shift = asMap(data['shift']);
    final handover = asMap(data['handover']);
    final financial = asMap(data['financial_summary']);
    final dailyClose = asMap(data['daily_close_status']);
    final rawBreakdown = data['cashier_breakdown'] is List
        ? (data['cashier_breakdown'] as List)
        : const [];

    return HistoricalFinalHandoverEntity(
      shiftId: (shift['id'] ?? '').toString(),
      shiftDate: (shift['shift_date'] ?? '').toString(),
      shiftStatus: (shift['status'] ?? '').toString(),
      branchName: (shift['branch_name'] ?? 'N/A').toString(),
      managerName: (shift['manager_name'] ?? 'N/A').toString(),
      handoverAmount: toDouble(handover['handover_amount']),
      handoverStatus: (handover['status'] ?? '').toString(),
      handoverFrom: (handover['handover_from'] ?? 'N/A').toString(),
      handoverTo: (handover['handover_to'] ?? 'N/A').toString(),
      handoverDate: (handover['handover_date'] ?? '').toString(),
      handoverTime: (handover['handover_time'] ?? '').toString(),
      handoverNotes: handover['handover_notes']?.toString(),
      variance: toDouble(handover['variance']),
      totalSales: toDouble(financial['total_sales']),
      netSales: toDouble(financial['net_sales']),
      vatAmount: toDouble(financial['vat_amount']),
      cashCollected: toDouble(financial['cash_collected']),
      cardPayments: toDouble(financial['card_payments']),
      aggregatorPayments: toDouble(financial['aggregator_payments']),
      dailyCloseSubmitted: dailyClose['is_submitted'] == true,
      dailyCloseSubmittedAt: dailyClose['submitted_at']?.toString(),
      cashierBreakdown: rawBreakdown
          .map((item) => HistoricalCashierBreakdownItemEntity.fromJson(asMap(item)))
          .toList(),
    );
  }
}
