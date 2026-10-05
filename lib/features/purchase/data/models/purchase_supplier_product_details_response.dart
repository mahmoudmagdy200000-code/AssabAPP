import 'package:json_annotation/json_annotation.dart';

import 'purchase_suppliers_response.dart';

part 'purchase_supplier_product_details_response.g.dart';

@JsonSerializable(createToJson: false)
class PurchaseSupplierProductDetailsResponse {
  List<PurchaseSupplierProductDetailsData> data;
  PurchaseSuppliersDataSupplier supplier;

  PurchaseSupplierProductDetailsResponse({
    required this.data,
    required this.supplier,
  });

  factory PurchaseSupplierProductDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseSupplierProductDetailsResponseFromJson(json);
}

class PurchaseSupplierProductDetailsData {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final String itemCode;
  final String itemUnit;
  final num itemPrice;
  final String? category;
  final String? subcategory;
  final String supplierItemId;
  final int quantity;
  final num totalAmount;
  final num priceRate;
  final num economyPrice;
  final num standardPrice;
  final num premiumPrice;
  final bool isAvailable;
  final int minOrderQuantity;
  final int maxOrderQuantity;
  final num deliveryHours;
  final num deliveryDays;
  final num rating;

  PurchaseSupplierProductDetailsData({
    required this.itemId,
    required this.itemName,
    this.itemLogo,
    required this.itemCode,
    required this.itemUnit,
    required this.itemPrice,
    this.category,
    this.subcategory,
    required this.supplierItemId,
    required this.quantity,
    required this.totalAmount,
    required this.priceRate,
    required this.economyPrice,
    required this.standardPrice,
    required this.premiumPrice,
    required this.isAvailable,
    required this.minOrderQuantity,
    required this.maxOrderQuantity,
    required this.deliveryHours,
    required this.deliveryDays,
    required this.rating,
  });

  factory PurchaseSupplierProductDetailsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseSupplierProductDetailsData(
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      itemCode: json['item_code'] as String,
      itemUnit: json['item_unit'] as String,
      itemPrice: (json['item_price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      supplierItemId: json['supplier_item_id'] as String,
      quantity: json['quantity'] as int,
      totalAmount: json['total_amount'] as num,
      priceRate: json['price_rate'] as num,
      economyPrice: json['economy_price'] as num,
      standardPrice: json['standard_price'] as num,
      premiumPrice: json['premium_price'] as num,
      isAvailable: json['is_available'] as bool,
      minOrderQuantity: json['min_order_quantity'] as int,
      maxOrderQuantity: json['max_order_quantity'] as int,
      deliveryHours: json['delivery_hours'] as num,
      deliveryDays: json['delivery_days'] as num,
      rating: json['rating'] as num,
    );
  }
}
