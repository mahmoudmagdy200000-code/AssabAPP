// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_product_officer_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseProductOfficerDetailsResponse
_$PurchaseProductOfficerDetailsResponseFromJson(Map<String, dynamic> json) =>
    PurchaseProductOfficerDetailsResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => PurchaseProductOfficerDetailsData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

PurchaseProductOfficerDetailsPriceComparison
_$PurchaseProductOfficerDetailsPriceComparisonFromJson(
  Map<String, dynamic> json,
) => PurchaseProductOfficerDetailsPriceComparison(
  directSupplier: PurchaseProductOfficerDetailsPriceSource.fromJson(
    json['direct_supplier'] as Map<String, dynamic>,
  ),
  purchasingOfficer: PurchaseProductOfficerDetailsPriceSource.fromJson(
    json['purchasing_officer'] as Map<String, dynamic>,
  ),
  savings: json['savings'] as num,
);

PurchaseProductOfficerDetailsPriceSource
_$PurchaseProductOfficerDetailsPriceSourceFromJson(Map<String, dynamic> json) =>
    PurchaseProductOfficerDetailsPriceSource(
      unitPrice: json['unit_price'] as num,
      totalAmount: json['total_amount'] as num,
    );
