import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:equatable/equatable.dart';

class PurchaseBranchItemsResponse extends Equatable {
  final List<PurchaseBranchItemData> data;
  final MetaModel meta;

  const PurchaseBranchItemsResponse({required this.data, required this.meta});

  factory PurchaseBranchItemsResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseBranchItemsResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => PurchaseBranchItemData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object> get props => [data, meta];
}

class PurchaseBranchItemData extends Equatable {
  final String id;
  final String itemId;
  final String itemName;
  final String itemTitle;
  final String? itemLogo;
  final String itemCode;
  final String itemUnit;
  final double rate;
  final double itemPrice;
  final int itemQuantity;
  final String? category;
  final String? subcategory;
  final int? suppliersCount;
  final String unit;

  const PurchaseBranchItemData({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemTitle,
    this.itemLogo,
    required this.itemCode,
    required this.itemUnit,
    required this.rate,
    required this.itemPrice,
    required this.itemQuantity,
    this.category,
    this.subcategory,
    required this.suppliersCount,
    required this.unit,
  });

  factory PurchaseBranchItemData.fromJson(Map<String, dynamic> json) {
    return PurchaseBranchItemData(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemTitle: json['item_title'] as String,
      itemLogo: json['item_logo'] as String?,
      itemCode: json['item_code'] as String,
      itemUnit: (json['item_unit'] as String).toLowerCase(),
      rate: (json['rate'] as num).toDouble(),
      itemPrice: (json['item_price'] as num).toDouble(),
      itemQuantity: (json['item_quantity'] as num).toInt(),
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      suppliersCount: (json['suppliers_count'] as num?)?.toInt(),
      unit: (json['unit'] as String).toLowerCase(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    itemId,
    itemName,
    itemTitle,
    itemLogo,
    itemCode,
    itemUnit,
    rate,
    itemPrice,
    itemQuantity,
    category,
    subcategory,
    suppliersCount,
    unit,
  ];
}
