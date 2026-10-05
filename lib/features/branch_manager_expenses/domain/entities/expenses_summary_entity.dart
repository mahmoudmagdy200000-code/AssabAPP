class ExpensesSummaryEntity {
  final int totalExpenses;
  final double totalAmount;
  final double quickCashTotal;
  final double singleInvoiceTotal;
  final double groupedInvoiceTotal;
  final double preApprovalTotal;

  ExpensesSummaryEntity({
    required this.totalExpenses,
    required this.totalAmount,
    required this.quickCashTotal,
    required this.singleInvoiceTotal,
    required this.groupedInvoiceTotal,
    required this.preApprovalTotal,
  });

  factory ExpensesSummaryEntity.empty() {
    return ExpensesSummaryEntity(
      totalExpenses: 0,
      totalAmount: 0.0,
      quickCashTotal: 0.0,
      singleInvoiceTotal: 0.0,
      groupedInvoiceTotal: 0.0,
      preApprovalTotal: 0.0,
    );
  }
}
