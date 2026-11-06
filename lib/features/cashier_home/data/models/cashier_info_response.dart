class CashierInfoResponse {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String role;
  final String status;
  final String statusLabel;
  final String activity;
  final CashierInfoShiftDetails? shiftDetails;

  CashierInfoResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.role,
    required this.status,
    required this.statusLabel,
    required this.activity,
    required this.shiftDetails,
  });

  factory CashierInfoResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return CashierInfoResponse(
      id: (data['id'] ?? '').toString(),
      name: (data['name'] as String?) ?? 'N/A',
      email: (data['email'] as String?) ?? '',
      phone: data['phone'] as String?,
      image: data['image'] as String?,
      role: (data['role'] as String?) ?? 'Cashier',
      status: (data['status'] as String?) ?? '',
      statusLabel: (data['status_label'] as String?) ?? '',
      activity: (data['activity'] as String?) ?? '',
      shiftDetails: data['shift_details'] is Map<String, dynamic>
          ? CashierInfoShiftDetails.fromJson(
              data['shift_details'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CashierInfoShiftDetails {
  final String? id;
  final String storeBranch;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String? shiftDate;
  final String? status;
  final String? statusLabel;
  final String workdays;
  final CashierInfoHandsOverTo handsOverTo;

  CashierInfoShiftDetails({
    required this.id,
    required this.storeBranch,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.shiftDate,
    required this.status,
    required this.statusLabel,
    required this.workdays,
    required this.handsOverTo,
  });

  factory CashierInfoShiftDetails.fromJson(Map<String, dynamic> json) =>
      CashierInfoShiftDetails(
        id: json['id']?.toString(),
        storeBranch: (json['store_branch'] as String?) ?? '-',
        shiftName: (json['shift_name'] as String?) ?? '-',
        startTime: (json['start_time'] as String?) ?? '',
        endTime: (json['end_time'] as String?) ?? '',
        shiftDate: json['shift_date'] as String?,
        status: json['status'] as String?,
        statusLabel: json['status_label'] as String?,
        workdays: (json['workdays'] as String?) ?? '-',
        handsOverTo: json['hands_over_to'] is Map<String, dynamic>
            ? CashierInfoHandsOverTo.fromJson(
                json['hands_over_to'] as Map<String, dynamic>,
              )
            : CashierInfoHandsOverTo(id: '', name: '-', role: '-'),
      );
}

class CashierInfoHandsOverTo {
  final String id;
  final String name;
  final String role;

  CashierInfoHandsOverTo({
    required this.id,
    required this.name,
    required this.role,
  });

  factory CashierInfoHandsOverTo.fromJson(Map<String, dynamic> json) =>
      CashierInfoHandsOverTo(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] as String?) ?? '-',
        role: (json['role'] as String?) ?? 'Cashier',
      );
}
