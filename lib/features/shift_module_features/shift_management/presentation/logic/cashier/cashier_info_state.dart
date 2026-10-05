import '../../../domain/entity/cashier_entity.dart';

class CashierInfoState {
  final CashierEntity? originalCashier;
  final CashierEntity? cashier;
  final bool isEditing;

  const CashierInfoState({
    required this.originalCashier,
    required this.cashier,
    required this.isEditing,
  });

  CashierInfoState copyWith({
    CashierEntity? originalCashier,
    CashierEntity? cashier,
    bool? isEditing,
  }) {
    return CashierInfoState(
      originalCashier: originalCashier ?? this.originalCashier,
      cashier: cashier ?? this.cashier,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
