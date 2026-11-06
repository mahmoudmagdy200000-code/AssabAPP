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
    final reassignment = json['reassignment'] as Map<String, dynamic>? ?? {};
    final shift = json['shift'] as Map<String, dynamic>? ?? {};

    return ReassignedShiftItemModel(
      id: (json['id'] ?? '').toString(),
      shiftDate: (json['shift_date'] as String?) ?? '',
      reassignedFrom: reassignment['reassigned_from'] is Map<String, dynamic>
          ? reassignment['reassigned_from']['name'] as String?
          : null,

      reassignedBy: reassignment['reassigned_by'] is Map<String, dynamic>
          ? reassignment['reassigned_by']['name'] as String?
          : null,

      cashGiven: (reassignment['cash_given'] as num?)?.toInt() ?? 0,

      variance: (json['variance'] as num?)?.toInt() ?? 0,

      startTime: (shift['start_time'] as String?) ?? '00:00',

      endTime: (shift['end_time'] as String?) ?? '00:00',

      nextCashier: reassignment['next_cashier'] is Map<String, dynamic>
          ? reassignment['next_cashier']['name'] as String?
          : (reassignment['next_cashier'] as String?),
    );
  }
}
