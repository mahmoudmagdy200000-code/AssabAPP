import 'package:json_annotation/json_annotation.dart';

part 'purchase_product_officer_details_response.g.dart';

@JsonSerializable(createToJson: false)
class PurchaseProductOfficerDetailsResponse {
  final List<PurchaseProductOfficerDetailsData> data;

  PurchaseProductOfficerDetailsResponse({required this.data});

  factory PurchaseProductOfficerDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductOfficerDetailsResponseFromJson(json);
}

class PurchaseProductOfficerDetailsData {
  final String itemId;
  final String itemName;
  final String itemUnit;
  final double itemPrice;
  final String? itemLogo;
  final PurchaseProductOfficerDetailsPriceComparison priceComparison;

  PurchaseProductOfficerDetailsData({
    required this.itemId,
    required this.itemName,
    required this.itemUnit,
    required this.itemPrice,
    this.itemLogo,
    required this.priceComparison,
  });

  factory PurchaseProductOfficerDetailsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseProductOfficerDetailsData(
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemUnit: json['item_unit'] as String,
      itemPrice: (json['item_price'] as num).toDouble(),
      itemLogo: json['item_logo'] as String?,
      priceComparison: PurchaseProductOfficerDetailsPriceComparison.fromJson(
        json['price_comparison'] as Map<String, dynamic>,
      ),
    );
  }
}

@JsonSerializable(createToJson: false)
class PurchaseProductOfficerDetailsPriceComparison {
  @JsonKey(name: 'direct_supplier')
  final PurchaseProductOfficerDetailsPriceSource directSupplier;

  @JsonKey(name: 'purchasing_officer')
  final PurchaseProductOfficerDetailsPriceSource purchasingOfficer;

  final num savings;

  PurchaseProductOfficerDetailsPriceComparison({
    required this.directSupplier,
    required this.purchasingOfficer,
    required this.savings,
  });

  factory PurchaseProductOfficerDetailsPriceComparison.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductOfficerDetailsPriceComparisonFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseProductOfficerDetailsPriceSource {
  @JsonKey(name: 'unit_price')
  final num unitPrice;

  @JsonKey(name: 'total_amount')
  final num totalAmount;

  PurchaseProductOfficerDetailsPriceSource({
    required this.unitPrice,
    required this.totalAmount,
  });

  factory PurchaseProductOfficerDetailsPriceSource.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductOfficerDetailsPriceSourceFromJson(json);
}
