class CustodyTrendBalanceStateResponse {
  final CustodyTrendBalanceStateData data;

  CustodyTrendBalanceStateResponse({required this.data});

  factory CustodyTrendBalanceStateResponse.fromJson(Map<String, dynamic> json) {
    return CustodyTrendBalanceStateResponse(
      data: CustodyTrendBalanceStateData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}

class CustodyTrendBalanceStateData {
  final double currentBalance;
  final String custodyType;
  final int month;
  final int year;
  final String granularity;
  final DateTime showingDataFrom;
  final String timelineLabel;
  final CustodyTrendBalanceStateMetric totalCustodyRequests;
  final CustodyTrendBalanceStateMetric totalExpense;
  final List<double> expenseChart;
  final List<double> custodyRequestChart;

  CustodyTrendBalanceStateData({
    required this.currentBalance,
    required this.custodyType,
    required this.month,
    required this.year,
    required this.granularity,
    required this.showingDataFrom,
    required this.timelineLabel,
    required this.totalCustodyRequests,
    required this.totalExpense,
    required this.expenseChart,
    required this.custodyRequestChart,
  });

  factory CustodyTrendBalanceStateData.fromJson(Map<String, dynamic> json) {
    return CustodyTrendBalanceStateData(
      currentBalance: (json['currentBalance'] as num).toDouble(),
      custodyType: json['custodyType'] as String,
      month: json['month'] as int,
      year: json['year'] as int,
      granularity: json['granularity'] as String,
      showingDataFrom: DateTime.parse(json['showingDataFrom'] as String),
      timelineLabel: json['timelineLabel'] as String,
      totalCustodyRequests: CustodyTrendBalanceStateMetric.fromJson(
        json['totalCustodyRequests'] as Map<String, dynamic>,
      ),
      totalExpense: CustodyTrendBalanceStateMetric.fromJson(
        json['totalExpense'] as Map<String, dynamic>,
      ),
      expenseChart: List<double>.from(
        (json['expenseChart'] as List<dynamic>).map(
          (e) => (e as num).toDouble(),
        ),
      ),
      custodyRequestChart: List<double>.from(
        (json['custodyRequestChart'] as List<dynamic>).map(
          (e) => (e as num).toDouble(),
        ),
      ),
    );
  }
}

class CustodyTrendBalanceStateMetric {
  final double value;
  final double changeAmount;
  final String changePercentage;
  final String description;

  CustodyTrendBalanceStateMetric({
    required this.value,
    required this.changeAmount,
    required this.changePercentage,
    required this.description,
  });

  factory CustodyTrendBalanceStateMetric.fromJson(Map<String, dynamic> json) {
    return CustodyTrendBalanceStateMetric(
      value: (json['value'] as num).toDouble(),
      changeAmount: (json['changeAmount'] as num).toDouble(),
      changePercentage: json['changePercentage'] as String,
      description: json['description'] as String,
    );
  }
}
