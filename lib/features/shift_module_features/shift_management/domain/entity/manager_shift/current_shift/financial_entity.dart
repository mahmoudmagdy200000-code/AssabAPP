class FinancialEntity {
  final num totalSales;
  final num netSales;
  final num vatAmount;
  final num cashCollected;
  final num cardPayments;
  final num aggregatorPayments;

  FinancialEntity({
    required this.totalSales,
    required this.netSales,
    required this.vatAmount,
    required this.cashCollected,
    required this.cardPayments,
    required this.aggregatorPayments,
  });
}
