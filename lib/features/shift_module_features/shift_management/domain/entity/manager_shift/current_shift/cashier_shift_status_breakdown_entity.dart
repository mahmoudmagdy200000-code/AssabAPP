class CashierShiftStatusBreakdownEntity {
  final int notStarted;
  final int inProgress;
  final int completed;
  final int reassigned;

  CashierShiftStatusBreakdownEntity({
    required this.notStarted,
    required this.inProgress,
    required this.completed,
    required this.reassigned,
  });
}
