class CashierBreakdownEntity {
  final String cashierId;
  final String? cashierShiftId;
  final int? expectedRevision;
  final String cashierName;
  double cashCollected;
  double cardPayments;
  double deliveryAppPayments;
  double variance;
  double totalSales;

  // Authoritative server-provided baselines to track manager modifications
  final double initialCashCollected;
  final double initialCardPayments;
  final double initialDeliveryAppPayments;
  final double initialTotalSales;
  final String? reason;

  CashierBreakdownEntity({
    required this.cashierId,
    this.cashierShiftId,
    this.expectedRevision,
    required this.cashierName,
    required this.cashCollected,
    required this.cardPayments,
    required this.deliveryAppPayments,
    required this.variance,
    required this.totalSales,
    double? initialCashCollected,
    double? initialCardPayments,
    double? initialDeliveryAppPayments,
    double? initialTotalSales,
    this.reason,
  })  : initialCashCollected = initialCashCollected ?? cashCollected,
        initialCardPayments = initialCardPayments ?? cardPayments,
        initialDeliveryAppPayments =
            initialDeliveryAppPayments ?? deliveryAppPayments,
        initialTotalSales = initialTotalSales ?? totalSales;

  /// True if manager explicitly altered any financial field from the server's authoritative state
  bool get isModified =>
      (cashCollected - initialCashCollected).abs() > 0.001 ||
      (cardPayments - initialCardPayments).abs() > 0.001 ||
      (deliveryAppPayments - initialDeliveryAppPayments).abs() > 0.001 ||
      (totalSales - initialTotalSales).abs() > 0.001;

  /// Strictly for UI display. Must NEVER be serialized as the write payload `sales`.
  double get cashierTotal {
    return (cashCollected + cardPayments + deliveryAppPayments) -
        (variance.abs());
  }

  CashierBreakdownEntity copyWith({
    String? cashierId,
    String? cashierShiftId,
    int? expectedRevision,
    String? cashierName,
    double? cashCollected,
    double? cardPayments,
    double? deliveryAppPayments,
    double? variance,
    double? totalSales,
    double? initialCashCollected,
    double? initialCardPayments,
    double? initialDeliveryAppPayments,
    double? initialTotalSales,
    String? reason,
  }) {
    return CashierBreakdownEntity(
      cashierId: cashierId ?? this.cashierId,
      cashierShiftId: cashierShiftId ?? this.cashierShiftId,
      expectedRevision: expectedRevision ?? this.expectedRevision,
      cashierName: cashierName ?? this.cashierName,
      cashCollected: cashCollected ?? this.cashCollected,
      cardPayments: cardPayments ?? this.cardPayments,
      deliveryAppPayments: deliveryAppPayments ?? this.deliveryAppPayments,
      variance: variance ?? this.variance,
      totalSales: totalSales ?? this.totalSales,
      initialCashCollected: initialCashCollected ?? this.initialCashCollected,
      initialCardPayments: initialCardPayments ?? this.initialCardPayments,
      initialDeliveryAppPayments:
          initialDeliveryAppPayments ?? this.initialDeliveryAppPayments,
      initialTotalSales: initialTotalSales ?? this.initialTotalSales,
      reason: reason ?? this.reason,
    );
  }
}
