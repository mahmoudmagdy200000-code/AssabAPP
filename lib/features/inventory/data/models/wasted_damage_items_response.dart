class WastedDamageItemsResponse {
  final List<WastedDamageItemData> data;

  WastedDamageItemsResponse({required this.data});

  factory WastedDamageItemsResponse.fromJson(Map<String, dynamic> json) {
    return WastedDamageItemsResponse(
      data: (json['data'] as List)
          .map((e) => WastedDamageItemData.fromJson(e))
          .toList(),
    );
  }
}

class WastedDamageItemData {
  final String id;
  final String purchaseOrderItemId;
  final String purchaseOrderId;
  final String orderNumber;
  final String itemId;
  final String itemName;
  final String itemCode;
  final String? itemLogo;
  final String itemUnit;
  final String category;
  final String subcategory;
  final double quantityOrdered;
  final double? quantityReceived;
  final double unitPrice;
  final DateTime closedAt;
  final double availableInStock;
  final double pricePerUnit;
  final DateTime? expirationDate;
  final String storageLocation;

  WastedDamageItemData({
    required this.id,
    required this.purchaseOrderItemId,
    required this.purchaseOrderId,
    required this.orderNumber,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.itemLogo,
    required this.itemUnit,
    required this.category,
    required this.subcategory,
    required this.quantityOrdered,
    required this.quantityReceived,
    required this.unitPrice,
    required this.closedAt,
    required this.availableInStock,
    required this.pricePerUnit,
    required this.expirationDate,
    required this.storageLocation,
  });

  factory WastedDamageItemData.fromJson(Map<String, dynamic> json) {
    return WastedDamageItemData(
      id: json['id'] as String,
      purchaseOrderItemId: json['purchase_order_item_id'] as String,
      purchaseOrderId: json['purchase_order_id'] as String,
      orderNumber: json['order_number'] as String,
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemCode: json['item_code'] as String,
      itemLogo: json['item_logo'] as String?,
      itemUnit: json['item_unit'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      quantityOrdered: double.parse(json['quantity_ordered'] as String),
      quantityReceived: json['quantity_received'] == null
          ? null
          : double.parse(json['quantity_received'] as String),
      unitPrice: double.parse(json['unit_price'] as String),
      closedAt: DateTime.parse(json['closed_at'] as String),
      availableInStock: (json['available_in_stock'] as num).toDouble(),
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      expirationDate: json['expiration_date'] == null
          ? null
          : DateTime.parse(json['expiration_date'] as String),
      storageLocation: json['storage_location'] as String,
    );
  }
}
