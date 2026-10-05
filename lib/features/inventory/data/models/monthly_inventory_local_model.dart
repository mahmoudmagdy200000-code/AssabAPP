import '../../domain/strategies/inventory_user_type.dart';

class MonthlyInventoryLocalModel {
  final String sessionId;
  final InventoryUserType userType;

  MonthlyInventoryLocalModel({required this.sessionId, required this.userType});
}
