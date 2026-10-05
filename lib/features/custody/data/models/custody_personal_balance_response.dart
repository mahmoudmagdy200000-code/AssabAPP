import 'package:assab/core/utils/date_formatter.dart';

class CustodyPersonalBalanceResponse {
  final double totalCashIn;
  final double totalCashOut;
  final double currentBalance;
  final List<CustodyPersonalBalanceResponseRecentActivity> recentActivity;

  CustodyPersonalBalanceResponse({
    required this.totalCashIn,
    required this.totalCashOut,
    required this.currentBalance,
    required this.recentActivity,
  });

  factory CustodyPersonalBalanceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return CustodyPersonalBalanceResponse(
      totalCashIn: (data['totalCashIn'] as num).toDouble(),
      totalCashOut: (data['totalCashOut'] as num).toDouble(),
      currentBalance: (data['currentBalance'] as num).toDouble(),
      recentActivity: (data['recentActivity'] as List)
          .map(
            (e) => CustodyPersonalBalanceResponseRecentActivity.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class CustodyPersonalBalanceResponseRecentActivity {
  final String transactionType;
  final String amount;
  final String dateTime;
  final bool isCashIn;

  CustodyPersonalBalanceResponseRecentActivity({
    required this.transactionType,
    required this.amount,
    required this.dateTime,
    required this.isCashIn,
  });

  factory CustodyPersonalBalanceResponseRecentActivity.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustodyPersonalBalanceResponseRecentActivity(
      transactionType: json['transactionType'] as String,
      amount: json['amount'] as String,
      dateTime:
          '${DateFormatter.formatDateMDY(DateTime.tryParse(json['dateTime'] as String))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(json['dateTime'] as String))}',
      isCashIn: json['isCashIn'] as bool,
    );
  }
}
