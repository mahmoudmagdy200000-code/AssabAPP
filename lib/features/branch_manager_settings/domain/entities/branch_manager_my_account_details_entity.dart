import 'package:equatable/equatable.dart';

class BranchManagerMyAccountDetailsEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String role;
  final String assignedTo;
  final String weekdays;
  final String workShift;

  const BranchManagerMyAccountDetailsEntity({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.role,
    required this.assignedTo,
    required this.weekdays,
    required this.workShift,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object> get props => [
    firstName,
    lastName,
    emailAddress,
    role,
    assignedTo,
    weekdays,
    workShift,
  ];
}