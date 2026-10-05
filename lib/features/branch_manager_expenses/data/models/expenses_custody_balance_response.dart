class ExpensesCustodyBalanceResponse {
  final double balance;

  ExpensesCustodyBalanceResponse({required this.balance});

  factory ExpensesCustodyBalanceResponse.fromJson(Map<String, dynamic> json) {
    return ExpensesCustodyBalanceResponse(
      balance: (json['data']['balance'] as num).toDouble(),
    );
  }
}
