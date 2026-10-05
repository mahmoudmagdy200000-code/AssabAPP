import 'package:assab/core/utils/date_formatter.dart';

class BranchCustodyTransactionsResponse {
  final BranchCustodyData data;

  const BranchCustodyTransactionsResponse({required this.data});

  factory BranchCustodyTransactionsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchCustodyTransactionsResponse(
      data: BranchCustodyData.fromJson(json['data']),
    );
  }
}

class BranchCustodyData {
  final List<BranchCustodyTransaction> transactions;

  const BranchCustodyData({required this.transactions});

  factory BranchCustodyData.fromJson(Map<String, dynamic> json) {
    return BranchCustodyData(
      transactions: (json['transactions'] as List)
          .map((e) => BranchCustodyTransaction.fromJson(e))
          .toList(),
    );
  }
}

class BranchCustodyTransaction {
  final String id;
  final String type;
  final String submittedBy;
  final String dateTime;
  final String amount;
  final bool isCashIn;

  const BranchCustodyTransaction({
    required this.id,
    required this.type,
    required this.submittedBy,
    required this.dateTime,
    required this.amount,
    required this.isCashIn,
  });

  factory BranchCustodyTransaction.fromJson(Map<String, dynamic> json) {
    return BranchCustodyTransaction(
      id: json['id'],
      type: json['type'],
      submittedBy: json['submittedBy'] as String? ?? '-',
      dateTime:
          '${DateFormatter.formatDateMDY(DateTime.tryParse(json['dateTime']))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(json['dateTime']))}',
      amount: json['amount'],
      isCashIn: json['isCashIn'],
    );
  }
}
