import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';

class MonthlyInventoryPendingProductsResponse {
  final Map<String, MonthlyInventoryPendingProduct> productsMap;

  const MonthlyInventoryPendingProductsResponse({required this.productsMap});

  factory MonthlyInventoryPendingProductsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return MonthlyInventoryPendingProductsResponse(
      productsMap: {
        for (var item in dataList)
          item['id']: MonthlyInventoryPendingProduct.fromJson(item),
      },
    );
  }

  MonthlyInventoryPendingProductsResponse copyWith({
    Map<String, MonthlyInventoryPendingProduct>? productsMap,
  }) {
    return MonthlyInventoryPendingProductsResponse(
      productsMap: productsMap ?? this.productsMap,
    );
  }

  List<MonthlyInventoryPendingProduct> get data => productsMap.values.toList();
}

class MonthlyInventoryPendingProduct {
  final String id;
  final String itemId;
  final String? purchaseOrderItemId;
  final String itemName;
  final String unit;
  final int quantityInventory;
  final double unitPrice;
  final String category;
  final String subcategory;
  final String? countMethod;
  final String preferredCountMethod;
  final dynamic countMetadata;
  final MonthlyInventoryPendingProductHandler? handledBy;
  final String? lockedAt;
  final String? notes;

  MonthlyInventoryPendingProduct({
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
  });

  factory MonthlyInventoryPendingProduct.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryPendingProduct(
      id: json['id'],
      itemId: json['item_id'],
      purchaseOrderItemId: json['purchase_order_item_id'],
      itemName: json['item_name'],
      unit: json['unit'],
      quantityInventory: json['quantity_inventory'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      category: json['category'],
      subcategory: json['subcategory'],
      countMethod: json['count_method'],
      preferredCountMethod: json['preferred_count_method'],
      countMetadata: json['count_metadata'],
      handledBy: json['counted_by'] != null
          ? MonthlyInventoryPendingProductHandler.fromJson(json['counted_by'])
          : null,
      lockedAt: json['locked_at'],
      notes: json['notes'],
    );
  }

  bool get isHandledByAnotherEmployee =>
      handledBy != null &&
      handledBy!.id != getIt<SharedPreferencesHelper>().getString('u_id');
}

class MonthlyInventoryPendingProductHandler {
  final String id;
  final String name;
  final String? image;

  MonthlyInventoryPendingProductHandler({
    required this.id,
    required this.name,
    this.image,
  });

  factory MonthlyInventoryPendingProductHandler.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlyInventoryPendingProductHandler(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
