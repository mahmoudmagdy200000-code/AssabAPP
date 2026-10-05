class DailyInventoryItemsResponse {
  final List<DailyInventoryItem> data;

  const DailyInventoryItemsResponse({required this.data});

  factory DailyInventoryItemsResponse.fromJson(Map<String, dynamic> json) {
    return DailyInventoryItemsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => DailyInventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DailyInventoryItem {
  final String id;
  final String branchItemId;
  final String itemId;
  final String itemName;
  final String itemCode;
  final String? itemLogo;
  final String itemUnit;
  final String category;
  final String subcategory;
  final double price;

  const DailyInventoryItem({
    required this.id,
    required this.branchItemId,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.itemLogo,
    required this.itemUnit,
    required this.category,
    required this.subcategory,
    required this.price,
  });

  factory DailyInventoryItem.fromJson(Map<String, dynamic> json) {
    return DailyInventoryItem(
      id: json['id'] as String,
      branchItemId: json['branch_item_id'] as String,
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemCode: json['item_code'] as String,
      itemLogo: json['item_logo'] as String?,
      itemUnit: json['item_unit'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      price: double.tryParse(json['price'].toString()) ?? 0,
    );
  }
}
