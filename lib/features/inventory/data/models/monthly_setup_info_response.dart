import 'package:assab/core/utils/date_formatter.dart';

class MonthlySetupInfoResponse {
  final MonthlySetupInfoData data;

  MonthlySetupInfoResponse({required this.data});

  factory MonthlySetupInfoResponse.fromJson(Map<String, dynamic> json) {
    return MonthlySetupInfoResponse(
      data: MonthlySetupInfoData.fromJson(json['data']),
    );
  }
}

class MonthlySetupInfoData {
  final String date;
  final int numberOfProducts;
  final int expectedTimeMinutes;
  final String expectedTimeLabel;

  MonthlySetupInfoData({
    required this.date,
    required this.numberOfProducts,
    required this.expectedTimeMinutes,
    required this.expectedTimeLabel,
  });

  factory MonthlySetupInfoData.fromJson(Map<String, dynamic> json) {
    return MonthlySetupInfoData(
      date: DateFormatter.formatDateMDY(
        DateTime.tryParse(json['date'] as String),
      ).toString(),
      numberOfProducts: json['number_of_products'],
      expectedTimeMinutes: json['expected_time_minutes'],
      expectedTimeLabel: json['expected_time_label'],
    );
  }
}
