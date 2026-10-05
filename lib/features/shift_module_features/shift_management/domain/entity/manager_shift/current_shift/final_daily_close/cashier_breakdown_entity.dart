class CashierBreakdownEntity {
  final String cashierId;
  final String cashierName;
  double cashCollected;
  double cardPayments;
  double deliveryAppPayments;
  double variance;
  double totalSales;

  CashierBreakdownEntity({
    required this.cashierId,
    required this.cashierName,
    required this.cashCollected,
    required this.cardPayments,
    required this.deliveryAppPayments,
    required this.variance,
    required this.totalSales,
  });

  double get cashierTotal {
    return (cashCollected + cardPayments + deliveryAppPayments) -
        (variance.abs());
  }

  CashierBreakdownEntity copyWith({
    double? cashCollected,
    double? cardPayments,
    double? deliveryAppPayments,
    double? variance,
    double? totalSales,
  }) {
    return CashierBreakdownEntity(
      cashierId: cashierId,
      cashierName: cashierName,
      cashCollected: cashCollected ?? this.cashCollected,
      cardPayments: cardPayments ?? this.cardPayments,
      deliveryAppPayments: deliveryAppPayments ?? this.deliveryAppPayments,
      variance: variance ?? this.variance,
      totalSales: totalSales ?? this.totalSales,
    );
  }
}
