import '../strategies/expenses_strategy.dart';

class ExpensesEntity {
  final String id;
  final String expenseName;
  final ExpensesStrategy expenseType;
  final double amount;
  final String date;
  final String time;
  final String status;
  final String createdAt;

  ExpensesEntity({
    required this.id,
    required this.expenseName,
    required this.expenseType,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
  });
}
