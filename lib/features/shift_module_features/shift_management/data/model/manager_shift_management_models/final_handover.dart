import '../../../domain/enums/manager_shift/end_shift_handover_timing.dart';

class FinalHandover {
  final int? handoverAmount;

  final FinalHandOverStatus status;

  final String handoverFrom;

  final String handoverTo;

  final String handoverDate;

  final String handoverTime;

  final String currentTime;

  final HandoverTiming currentTimeSetting;

  final String? handoverNotes;

  final int? openingBalance;

  final int? closingBalance;

  final int? expectedBalance;

  final int? variance;

  final String varianceType;

  final int? lastDeposit;
  final int? pettyCash;

  FinalHandover({
    required this.handoverAmount,
    required this.status,
    required this.handoverFrom,
    required this.handoverTo,
    required this.handoverDate,
    required this.handoverTime,
    required this.currentTime,
    required this.currentTimeSetting,
    this.handoverNotes,
    required this.openingBalance,
    required this.closingBalance,
    required this.expectedBalance,
    required this.variance,
    required this.varianceType,
    this.lastDeposit,
    this.pettyCash,
  });

  factory FinalHandover.fromJson(Map<String, dynamic> json) {
    return FinalHandover(
      handoverAmount: (json['handover_amount'] as num?)?.toInt(),
      status: FinalHandOverStatus.fromString(json['status'] as String),
      handoverFrom: json['handover_from'] as String,
      handoverTo: json['handover_to'] as String,
      handoverDate: json['handover_date'] as String,
      handoverTime: json['handover_time'] as String,
      currentTime: json['current_time'] as String,
      currentTimeSetting: HandoverTiming.fromString(
        json['current_time_setting'] as String,
      ),
      handoverNotes: json['handover_notes'] as String?,
      openingBalance: (json['opening_balance'] as num?)?.toInt(),
      closingBalance: (json['closing_balance'] as num?)?.toInt(),
      expectedBalance: (json['expected_balance'] as num?)?.toInt(),
      variance: (json['variance'] as num?)?.toInt(),
      varianceType: json['variance_type'] as String,
      lastDeposit: (json['last_deposit'] as num?)?.toInt(),
      pettyCash: (json['petty_cash'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handover_amount': handoverAmount,
      'status': status.value,
      'handover_from': handoverFrom,
      'handover_to': handoverTo,
      'handover_date': handoverDate,
      'handover_time': handoverTime,
      'current_time': currentTime,
      'current_time_setting': currentTimeSetting.value,
      'handover_notes': handoverNotes,
      'opening_balance': openingBalance,
      'closing_balance': closingBalance,
      'expected_balance': expectedBalance,
      'variance': variance,
      'variance_type': varianceType,
    };
  }
}

enum FinalHandOverStatus {
  notSubmitted('not_submitted'),
  pending('pending'),
  completed('completed'),
  rejected('rejected');

  final String _value;

  const FinalHandOverStatus(this._value);

  String get value => _value;

  static FinalHandOverStatus fromString(String value) {
    return FinalHandOverStatus.values.firstWhere(
      (e) => e._value.toLowerCase() == value.toLowerCase(),
      orElse: () => pending,
    );
  }
}
