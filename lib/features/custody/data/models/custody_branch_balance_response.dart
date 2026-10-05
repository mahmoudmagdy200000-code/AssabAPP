import 'branch_custody_transactions_response.dart';
import 'custody_requests_response.dart';

class CustodyBranchBalanceResponse {
  final double currentBalance;
  final List<CustodyRequestItem> requests;
  final List<BranchCustodyTransaction> transactions;

  CustodyBranchBalanceResponse({
    required this.currentBalance,
    required this.requests,
    required this.transactions,
  });

  factory CustodyBranchBalanceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return CustodyBranchBalanceResponse(
      currentBalance: (data['currentBalance'] as num).toDouble(),
      requests: (data['requests'] as List<dynamic>)
          .map((e) => CustodyRequestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      transactions: (data['transactions'] as List<dynamic>)
          .map(
            (e) => BranchCustodyTransaction.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
