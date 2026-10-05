class ShiftStatisticsEntity {
  final int? totalCashierShifts;
  final int? completedCashierShifts;
  final int? pendingCashierShifts;
  final num completionRate;

  ShiftStatisticsEntity({
    required this.totalCashierShifts,
    required this.completedCashierShifts,
    required this.pendingCashierShifts,
    required this.completionRate,
  });
}
