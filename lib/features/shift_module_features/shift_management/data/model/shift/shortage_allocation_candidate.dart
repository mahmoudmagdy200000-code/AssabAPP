class ShortageAllocationCandidate {
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

  bool get isValid =>
      id.trim().isNotEmpty &&
      name.trim().isNotEmpty &&
      (type == 'cashier' || type == 'branch_manager' || type == 'employee');

  factory ShortageAllocationCandidate.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString().trim();
    return ShortageAllocationCandidate(
      id: json['id']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
      type: (rawType != null && rawType.isNotEmpty) ? rawType : '',
      role: json['role']?.toString().trim() ?? '',
      employeeNumber: json['employee_number']?.toString().trim(),
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortageAllocationCandidate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
