class DailyTotalsEntity {
  final double totalCashCollected;
  final double totalCardPayments;
  final double totalDeliveryApps;
  final double totalVariance;
  final double totalSales;
  final String shiftDate;

  const DailyTotalsEntity({
    required this.totalCashCollected,
    required this.totalCardPayments,
    required this.totalDeliveryApps,
    required this.totalVariance,
    required this.totalSales,
    required this.shiftDate,
  });
}
