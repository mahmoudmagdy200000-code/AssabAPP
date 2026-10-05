class ExportExpenseReportRequest {
  final String expenseType;
  final int year;
  final int monthNumber;
  final String formatType;

  const ExportExpenseReportRequest({
    required this.expenseType,
    required this.year,
    required this.monthNumber,
    required this.formatType,
  });

  Map<String, dynamic> toJson() {
    return {
      'expense_type': expenseType,
      'year': year,
      'month_number': monthNumber,
      'format_type': formatType,
    };
  }
}
