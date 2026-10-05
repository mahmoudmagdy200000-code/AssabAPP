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
    final data = json['data'];
    return CashierInfoResponse(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      image: data['image'],
      role: data['role'],
      status: data['status'],
      statusLabel: data['status_label'],
      activity: data['activity'],
      shiftDetails: data['shift_details'] == null
          ? null
          : CashierInfoShiftDetails.fromJson(data['shift_details']),
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
        id: json['id'],
        storeBranch: json['store_branch'],
        shiftName: json['shift_name'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        shiftDate: json['shift_date'],
        status: json['status'],
        statusLabel: json['status_label'],
        workdays: json['workdays'],
        handsOverTo: CashierInfoHandsOverTo.fromJson(json['hands_over_to']),
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
        id: json['id'],
        name: json['name'],
        role: json['role'],
      );
}
