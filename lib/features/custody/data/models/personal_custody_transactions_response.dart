class PersonalCustodyTransactionsResponse {
  final PersonalCustodyData data;

  const PersonalCustodyTransactionsResponse({required this.data});

  factory PersonalCustodyTransactionsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return PersonalCustodyTransactionsResponse(
      data: PersonalCustodyData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson()};
  }
}

class PersonalCustodyData {
  final String view;
  final int totalTransactions;
  final List<PersonalCustodyTransaction> transactions;

  const PersonalCustodyData({
    required this.view,
    required this.totalTransactions,
    required this.transactions,
  });

  factory PersonalCustodyData.fromJson(Map<String, dynamic> json) {
    return PersonalCustodyData(
      view: json['view'],
      totalTransactions: json['totalTransactions'],
      transactions: (json['transactions'] as List)
          .map((e) => PersonalCustodyTransaction.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'view': view,
      'totalTransactions': totalTransactions,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonalCustodyTransaction {
  final String id;
  final String transactionType;
  final String amount;
  final DateTime dateTime;
  final String? cashierName;
  final String? brandOwnerName;

  const PersonalCustodyTransaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.dateTime,
    this.cashierName,
    this.brandOwnerName,
  });

  factory PersonalCustodyTransaction.fromJson(Map<String, dynamic> json) {
    return PersonalCustodyTransaction(
      id: json['id'],
      transactionType: json['transactionType'],
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime']),
      cashierName: json['cashierName'],
      brandOwnerName: json['brandOwnerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionType': transactionType,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'cashierName': cashierName,
      'brandOwnerName': brandOwnerName,
    };
  }
}
