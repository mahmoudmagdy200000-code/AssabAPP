import '../../domain/entities/branch_manager_my_account_details_entity.dart';

class BranchManagerMyAccountDetailsModel
    extends BranchManagerMyAccountDetailsEntity {
  const BranchManagerMyAccountDetailsModel({
    required super.firstName,
    required super.lastName,
    required super.emailAddress,
    required super.role,
    required super.assignedTo,
    required super.weekdays,
    required super.workShift,
  });

  factory BranchManagerMyAccountDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return BranchManagerMyAccountDetailsModel(
      firstName: data['first_name'] as String? ?? '',
      lastName: data['last_name'] as String? ?? '',
      emailAddress: data['email_address'] as String? ?? '',
      role: data['role'] as String? ?? '',
      assignedTo: data['assigned_to'] as String? ?? '',
      weekdays: data['weekdays'] as String? ?? '',
      workShift: data['work_shift'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'role': role,
      'assignedTo': assignedTo,
      'weekdays': weekdays,
      'workShift': workShift,
    };
  }
}
