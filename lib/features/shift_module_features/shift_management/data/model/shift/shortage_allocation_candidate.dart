import 'package:equatable/equatable.dart';

class ShortageAllocationCandidate extends Equatable {
  final String id;
  final String name;
  final String type; // 'cashier', 'branch_manager', 'employee'
  final String role;
  final String? employeeNumber;

  const ShortageAllocationCandidate({
    required this.id,
    required this.name,
    required this.type,
    required this.role,
    this.employeeNumber,
  });

  factory ShortageAllocationCandidate.fromJson(Map<String, dynamic> json) {
    return ShortageAllocationCandidate(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'cashier',
      role: json['role']?.toString() ?? '',
      employeeNumber: json['employee_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'role': role,
        if (employeeNumber != null) 'employee_number': employeeNumber,
      };

  @override
  List<Object?> get props => [id, name, type, role, employeeNumber];
}
