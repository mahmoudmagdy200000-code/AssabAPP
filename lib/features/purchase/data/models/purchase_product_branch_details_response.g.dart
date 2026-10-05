// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_product_branch_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseProductBranchDetailsResponse
_$PurchaseProductBranchDetailsResponseFromJson(Map<String, dynamic> json) =>
    PurchaseProductBranchDetailsResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => PurchaseProductBranchDetailsData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      transportSummary: PurchaseProductBranchDetailsTransportSummary.fromJson(
        json['transport_summary'] as Map<String, dynamic>,
      ),
    );

PurchaseProductBranchDetailsAvailable
_$PurchaseProductBranchDetailsAvailableFromJson(Map<String, dynamic> json) =>
    PurchaseProductBranchDetailsAvailable(
      quantity: (json['quantity'] as num).toInt(),
      reservedQuantity: (json['reserved_quantity'] as num).toInt(),
      actualAvailable: (json['actual_available'] as num).toInt(),
      quality: json['quality'] as String,
      qualityLabel: json['quality_label'] as String,
    );

PurchaseProductBranchDetailsRemaining
_$PurchaseProductBranchDetailsRemainingFromJson(Map<String, dynamic> json) =>
    PurchaseProductBranchDetailsRemaining(
      quantity: (json['quantity'] as num).toInt(),
      quality: json['quality'] as String,
      qualityLabel: json['quality_label'] as String,
    );

PurchaseProductBranchDetailsTransport
_$PurchaseProductBranchDetailsTransportFromJson(Map<String, dynamic> json) =>
    PurchaseProductBranchDetailsTransport(
      method: json['method'] as String,
      estimatedTimeHours: json['estimated_time_hours'] as num,
      driver: json['driver'] as String?,
      temperature: json['temperature'] as String,
      distanceKm: json['distance_km'] as num,
      cost: json['cost'] as String,
      fromBranch: PurchaseProductBranchDetailsBranch.fromJson(
        json['from_branch'] as Map<String, dynamic>,
      ),
      toBranch: PurchaseProductBranchDetailsBranch.fromJson(
        json['to_branch'] as Map<String, dynamic>,
      ),
    );

PurchaseProductBranchDetailsBranch _$PurchaseProductBranchDetailsBranchFromJson(
  Map<String, dynamic> json,
) => PurchaseProductBranchDetailsBranch(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
);

PurchaseProductBranchDetailsTransportSummary
_$PurchaseProductBranchDetailsTransportSummaryFromJson(
  Map<String, dynamic> json,
) => PurchaseProductBranchDetailsTransportSummary(
  method: json['method'] as String,
  cost: json['cost'] as String,
  estimatedTimeHours: json['estimated_time_hours'] as num,
  driver: json['driver'] as String?,
  recommendedTemperature: json['recommended_temperature'] as String?,
  distanceKm: json['distance_km'] as num,
  fromBranch: PurchaseProductBranchDetailsBranch.fromJson(
    json['from_branch'] as Map<String, dynamic>,
  ),
  toBranch: PurchaseProductBranchDetailsBranch.fromJson(
    json['to_branch'] as Map<String, dynamic>,
  ),
  notes: json['notes'] as String,
);
