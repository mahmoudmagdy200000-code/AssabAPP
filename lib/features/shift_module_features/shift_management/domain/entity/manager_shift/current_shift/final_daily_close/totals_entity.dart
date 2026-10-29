import 'cashier_breakdown_entity.dart';

class TotalsEntity {
  double totalCashCollected;
  double totalCardPayments;
  double totalDeliveryApps;
  double totalVariance;
  double totalSales;

  TotalsEntity({
    required this.totalCashCollected,
    required this.totalCardPayments,
    required this.totalDeliveryApps,
    required this.totalVariance,
    required this.totalSales,
  });

  factory TotalsEntity.fromCashiers(List<CashierBreakdownEntity> cashiers) {
    return TotalsEntity(
      totalCashCollected: cashiers.fold(0, (sum, c) => sum + c.cashCollected),
      totalCardPayments: cashiers.fold(0, (sum, c) => sum + c.cardPayments),
      totalDeliveryApps: cashiers.fold(
        0,
        (sum, c) => sum + c.deliveryAppPayments,
      ),
      totalVariance: cashiers.fold(0, (sum, c) => sum + c.variance.abs()),
      totalSales: cashiers.fold(0, (sum, c) => sum + c.totalSales),
    );
  }

  double get totalOfTotals {
    return (totalCashCollected + totalCardPayments + totalDeliveryApps) -
        totalVariance;
  }
}
