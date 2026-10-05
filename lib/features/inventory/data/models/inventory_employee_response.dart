class InventoryEmployeeResponse {
  final List<InventoryEmployee> data;

  const InventoryEmployeeResponse({required this.data});

  factory InventoryEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return InventoryEmployeeResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => InventoryEmployee.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class InventoryEmployee {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? image;
  final String? statusLabel;
  final String? statusColor;

  const InventoryEmployee({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.image,
    this.statusLabel,
    this.statusColor,
  });

  factory InventoryEmployee.fromJson(Map<String, dynamic> json) {
    return InventoryEmployee(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      statusLabel: json['status_label'] as String,
      statusColor: json['status_color'] as String,
    );
  }
}
