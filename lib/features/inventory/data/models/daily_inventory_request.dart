import '../../../../core/enums/daily_inventory_type_enum.dart';

class DailyInventoryRequest {
  final DailyInventoryTypeEnum assignedToType;
  final String? assignedToId;
  final String? inventoryDate;
  final String? startTime;
  final List<DailyInventoryItemRequest> items;

  const DailyInventoryRequest({
    required this.assignedToType,
    this.assignedToId,
    this.inventoryDate,
    this.startTime,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'assigned_to_type': assignedToType.value,
      if (assignedToId != null) 'assigned_to_id': assignedToId,
      if (inventoryDate != null) 'inventory_date': inventoryDate,
      if (startTime != null) 'start_time': startTime,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class DailyInventoryItemRequest {
  final String itemId;
  final double quantity;
  final String? note;

  const DailyInventoryItemRequest({
    required this.itemId,
    required this.quantity,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
      if (note != null) 'note': note,
    };
  }
}
