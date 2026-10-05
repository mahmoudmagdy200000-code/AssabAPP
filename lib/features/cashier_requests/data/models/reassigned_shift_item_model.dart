class ReassignedShiftItemModel {
  final String id;
  final String? reassignedFrom;
  final String? reassignedBy;
  final int? cashGiven;
  final String? nextCashier;
  final String startTime;
  final String endTime;
  final int? variance;
  final String shiftDate;

  const ReassignedShiftItemModel({
    required this.id,
    required this.reassignedFrom,
    required this.reassignedBy,
    required this.cashGiven,
    required this.variance,
    required this.startTime,
    required this.endTime,
    required this.nextCashier,
    required this.shiftDate,
  });

  factory ReassignedShiftItemModel.fromJson(Map<String, dynamic> json) {
    final reassignment = json['reassignment'] ?? {};
    final shift = json['shift'] ?? {};

    return ReassignedShiftItemModel(
      id: json['id'],
      shiftDate: json['shift_date'],
      reassignedFrom: reassignment['reassigned_from']?['name'],

      reassignedBy: reassignment['reassigned_by']?['name'],

      cashGiven: reassignment['cash_given'] ?? 0,

      variance: json['variance'] ?? 0,

      startTime: shift['start_time'] ?? '00:00',

      endTime: shift['end_time'] ?? '00:00',

      nextCashier: reassignment['next_cashier']?['name'],
    );
  }
}
