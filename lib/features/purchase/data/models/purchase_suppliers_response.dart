import 'package:assab/core/enums/supplier_status_enum.dart';
import 'package:assab/core/strategies/supplier_status_strategy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'purchase_suppliers_response.g.dart';

@JsonSerializable(createToJson: false)
class PurchaseSuppliersResponse {
  final List<PurchaseSuppliersData> data;

  PurchaseSuppliersResponse({required this.data});

  factory PurchaseSuppliersResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSuppliersResponseFromJson(json);
}

class PurchaseSuppliersData {
  final String supplierId;
  final PurchaseSuppliersDataSupplier supplier;
  final String itemId;
  final String itemTitle;
  final String itemCode;
  final num itemPrice;
  final String itemUnit;
  final String? itemLogo;
  final int quantity;
  final num totalAmount;
  final num priceRate;
  final num economyPrice;
  final num standardPrice;
  final num premiumPrice;
  final num deliveryHours;
  final num deliveryDays;
  final num availabilityPercentage;
  final int minOrderQuantity;
  final int maxOrderQuantity;
  final num? distanceKm;
  final num? estimatedHours;
  final num rating;

  PurchaseSuppliersData({
    required this.supplierId,
    required this.supplier,
    required this.itemId,
    required this.itemTitle,
    required this.itemCode,
    required this.itemPrice,
    required this.itemUnit,
    this.itemLogo,
    required this.quantity,
    required this.totalAmount,
    required this.priceRate,
    required this.economyPrice,
    required this.standardPrice,
    required this.premiumPrice,
    required this.deliveryHours,
    required this.deliveryDays,
    required this.availabilityPercentage,
    required this.minOrderQuantity,
    required this.maxOrderQuantity,
    this.distanceKm,
    this.estimatedHours,
    required this.rating,
  });

  factory PurchaseSuppliersData.fromJson(Map<String, dynamic> json) {
    return PurchaseSuppliersData(
      supplierId: json['supplier_id'] as String,
      supplier: PurchaseSuppliersDataSupplier.fromJson(
        json['supplier'] as Map<String, dynamic>,
      ),
      itemId: json['item_id'] as String,
      itemTitle: json['item_title'] as String,
      itemCode: json['item_code'] as String,
      itemPrice: json['item_price'] as num,
      itemUnit: json['item_unit'] as String,
      itemLogo: json['item_logo'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      totalAmount: json['total_amount'] as num,
      priceRate: json['price_rate'] as num,
      economyPrice: json['economy_price'] as num,
      standardPrice: json['standard_price'] as num,
      premiumPrice: json['premium_price'] as num,
      deliveryHours: json['delivery_hours'] as num,
      deliveryDays: json['delivery_days'] as num,
      availabilityPercentage: json['availability_percentage'] as num,
      minOrderQuantity: (json['min_order_quantity'] as num).toInt(),
      maxOrderQuantity: (json['max_order_quantity'] as num).toInt(),
      distanceKm: json['distance_km'] as num?,
      estimatedHours: json['estimated_hours'] as num?,
      rating: json['rating'] as num,
    );
  }
}

class PurchaseSuppliersDataSupplier {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String address;
  final SupplierStatusStrategy status;
  final String statusLabel;
  final String statusColor;
  final bool isAvailable;
  final bool isActive;
  final List<String> contactMethods;
  final num totalOrders;
  final num completedOrders;

  PurchaseSuppliersDataSupplier({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.address,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.isAvailable,
    required this.isActive,
    required this.contactMethods,
    required this.totalOrders,
    required this.completedOrders,
  });

  factory PurchaseSuppliersDataSupplier.fromJson(Map<String, dynamic> json) {
    return PurchaseSuppliersDataSupplier(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String?,
      address: json['address'] as String,
      status: SupplierStatusEnum.getStrategy(
        SupplierStatusEnum.fromValue(json['status'] as String),
      ),
      statusLabel: json['status_label'] as String,
      statusColor: json['status_color'] as String,
      isAvailable: json['is_available'] as bool,
      isActive: json['is_active'] as bool,
      contactMethods: (json['contact_methods'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalOrders: json['total_orders'] as num,
      completedOrders: json['completed_orders'] as num,
    );
  }
}
