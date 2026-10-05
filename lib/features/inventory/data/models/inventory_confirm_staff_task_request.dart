class InventoryConfirmStaffTaskRequest {
  final List<InventoryConfirmStaffTaskItem> items;

  InventoryConfirmStaffTaskRequest({required this.items});

  Map<String, dynamic> toJson() => {
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class InventoryConfirmStaffTaskItem {
  final String itemId;
  final int quantity;

  InventoryConfirmStaffTaskItem({required this.itemId, required this.quantity});

  Map<String, dynamic> toJson() => {'itemId': itemId, 'quantity': quantity};
}
