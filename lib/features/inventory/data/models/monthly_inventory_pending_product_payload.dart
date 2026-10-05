import 'monthly_inventory_pending_products_response.dart';

class MonthlyInventoryPendingProductPayload {
  final String id;
  final String itemId;
  final String? purchaseOrderItemId;
  final String itemName;
  final String unit;
  final double quantityInventory;
  final String unitPrice;
  final String category;
  final String subcategory;
  final String? countMethod;
  final String preferredCountMethod;
  final dynamic countMetadata;
  final MonthlyInventoryPendingProductHandler? handledBy;
  final String? lockedAt;
  final String? notes;
  final DateTime occurredAt;

  MonthlyInventoryPendingProductPayload({
    required this.id,
    required this.itemId,
    this.purchaseOrderItemId,
    required this.itemName,
    required this.unit,
    required this.quantityInventory,
    required this.unitPrice,
    required this.category,
    required this.subcategory,
    this.countMethod,
    required this.preferredCountMethod,
    this.countMetadata,
    this.handledBy,
    this.lockedAt,
    this.notes,
    required this.occurredAt,
  });

  factory MonthlyInventoryPendingProductPayload.fromJson(
    Map<String, dynamic> json,
  ) {
    final product = json['payload']['product'] as Map<String, dynamic>;

    return MonthlyInventoryPendingProductPayload(
      id: product['id'],
      itemId: product['item_id'],
      purchaseOrderItemId: product['purchase_order_item_id'],
      itemName: product['item_name'],
      unit: product['unit'] as String,
      quantityInventory: double.parse(product['quantity_inventory']),
      unitPrice: (product['unit_price'] as String),
      category: product['category'],
      subcategory: product['subcategory'],
      countMethod: product['count_method'],
      preferredCountMethod: product['count_method'] ?? '',
      countMetadata: product['count_metadata'],
      handledBy: product['counted_by'] != null
          ? MonthlyInventoryPendingProductHandler.fromJson(
              product['counted_by'],
            )
          : null,
      lockedAt: product['locked_at'],
      notes: product['notes'],
      occurredAt: DateTime.parse(json['occurred_at']),
    );
  }

  MonthlyInventoryPendingProduct toMonthlyInventoryPendingProduct() {
    return MonthlyInventoryPendingProduct(
      id: id,
      itemId: itemId,
      purchaseOrderItemId: purchaseOrderItemId,
      itemName: itemName,
      unit: unit,
      quantityInventory: quantityInventory.toInt(),
      unitPrice: double.tryParse(unitPrice) ?? 0,
      category: category,
      subcategory: subcategory,
      countMethod: countMethod,
      preferredCountMethod: preferredCountMethod,
      countMetadata: countMetadata,
      handledBy: handledBy,
      lockedAt: lockedAt,
      notes: notes,
    );
  }
}
