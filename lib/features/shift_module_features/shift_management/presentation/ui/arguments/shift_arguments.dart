class ShiftArguments {
  final String shiftId;
  final double totalSales;
  final double cashCollected;
  final double cardPayment;
  final double deliveryApps;
  final double? variance;
  final String? nextCashier;
  final bool? isCashier;

  const ShiftArguments({
    required this.totalSales,
    required this.cashCollected,
    required this.cardPayment,
    required this.deliveryApps,
    required this.shiftId,
    this.isCashier,
    this.variance,
    this.nextCashier,
  });
}
