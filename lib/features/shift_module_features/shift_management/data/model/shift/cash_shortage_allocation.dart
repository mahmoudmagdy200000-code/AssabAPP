import 'package:equatable/equatable.dart';

class CashShortageAllocation extends Equatable {
  final String responsibleType; // 'cashier', 'branch_manager', 'employee'
  final String responsibleId;
  final double amount;
  final String? name;

  const CashShortageAllocation({
    required this.responsibleType,
    required this.responsibleId,
    required this.amount,
    this.name,
  });

  Map<String, dynamic> toJson() => {
    'responsible_type': responsibleType,
    'responsible_id': responsibleId,
    'amount': amount.toStringAsFixed(2),
    if (name != null) 'name': name,
  };

  factory CashShortageAllocation.fromJson(Map<String, dynamic> json) {
    return CashShortageAllocation(
      responsibleType: json['responsible_type'] as String,
      responsibleId: json['responsible_id']?.toString() ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      name: json['name'] as String?,
    );
  }

  CashShortageAllocation copyWith({
    String? responsibleType,
    String? responsibleId,
    double? amount,
    String? name,
  }) {
    return CashShortageAllocation(
      responsibleType: responsibleType ?? this.responsibleType,
      responsibleId: responsibleId ?? this.responsibleId,
      amount: amount ?? this.amount,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [responsibleType, responsibleId, amount, name];
}
