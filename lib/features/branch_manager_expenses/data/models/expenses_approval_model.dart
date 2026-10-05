import '../../../../core/enums/expenses_status.dart';

class ExpensesApprovalModel {
  final String id;
  final String name;
  final String role;
  final String? imageUrl;
  final ExpensesStatus status;

  ExpensesApprovalModel({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.status,
  });

  factory ExpensesApprovalModel.fromJson(Map<String, dynamic> json) {
    return ExpensesApprovalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      imageUrl: json['imageUrl'] as String?,
      status: ExpensesStatus.fromString(json['status'] as String),
    );
  }
}
