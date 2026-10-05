import '../../domain/strategies/inventory_user_type.dart';
import 'daily_inventory_items_response.dart';

class DailyInventoryLocalModel {
  final List<DailyInventoryItem> items;
  final InventoryUserType userType;

  DailyInventoryLocalModel({required this.items, required this.userType});
}
