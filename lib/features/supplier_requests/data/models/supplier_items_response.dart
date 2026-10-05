import 'package:assab/shared/models/meta_model/meta_model.dart';

class SupplierItemsResponse {
  final List<SupplierItem> data;
  final MetaModel meta;

  SupplierItemsResponse({required this.data, required this.meta});

  factory SupplierItemsResponse.fromJson(Map<String, dynamic> json) {
    return SupplierItemsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => SupplierItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class SupplierItem {
  final String id;
  final String supplierId;
  final String itemId;
  final String unitPrice;
  final String economyPrice;
  final String standardPrice;
  final String premiumPrice;
  final bool isAvailable;
  final String minOrderQuantity;
  final String maxOrderQuantity;
  final int deliveryHours;
  final String rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Item item;

  SupplierItem({
    required this.id,
    required this.supplierId,
    required this.itemId,
    required this.unitPrice,
    required this.economyPrice,
    required this.standardPrice,
    required this.premiumPrice,
    required this.isAvailable,
    required this.minOrderQuantity,
    required this.maxOrderQuantity,
    required this.deliveryHours,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.item,
  });

  factory SupplierItem.fromJson(Map<String, dynamic> json) {
    return SupplierItem(
      id: json['id'],
      supplierId: json['supplier_id'],
      itemId: json['item_id'],
      unitPrice: json['unit_price'],
      economyPrice: json['economy_price'],
      standardPrice: json['standard_price'],
      premiumPrice: json['premium_price'],
      isAvailable: json['is_available'],
      minOrderQuantity: json['min_order_quantity'],
      maxOrderQuantity: json['max_order_quantity'],
      deliveryHours: json['delivery_hours'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      item: Item.fromJson(json['item']),
    );
  }
}

class Item {
  final String id;
  final String name;
  final String code;
  final String unit;
  final String? logo;
  final String category;
  final String subcategory;
  final String? logoUrl;

  Item({
    required this.id,
    required this.name,
    required this.code,
    required this.unit,
    this.logo,
    required this.category,
    required this.subcategory,
    this.logoUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      unit: json['unit'],
      logo: json['logo'],
      category: json['category'],
      subcategory: json['subcategory'],
      logoUrl: json['logo_url'],
    );
  }
}
