// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_supplier_product_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseSupplierProductDetailsResponse
_$PurchaseSupplierProductDetailsResponseFromJson(Map<String, dynamic> json) =>
    PurchaseSupplierProductDetailsResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => PurchaseSupplierProductDetailsData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      supplier: PurchaseSuppliersDataSupplier.fromJson(
        json['supplier'] as Map<String, dynamic>,
      ),
    );
