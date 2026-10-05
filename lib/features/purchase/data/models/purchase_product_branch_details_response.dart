import 'package:json_annotation/json_annotation.dart';

part 'purchase_product_branch_details_response.g.dart';

@JsonSerializable(createToJson: false)
class PurchaseProductBranchDetailsResponse {
  List<PurchaseProductBranchDetailsData> data;
  @JsonKey(name: 'transport_summary')
  final PurchaseProductBranchDetailsTransportSummary transportSummary;

  PurchaseProductBranchDetailsResponse({
    required this.data,
    required this.transportSummary,
  });

  factory PurchaseProductBranchDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductBranchDetailsResponseFromJson(json);
}

class PurchaseProductBranchDetailsData {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final String itemCode;
  final String itemUnit;
  final int quantity;
  final String quality;
  final String qualityLabel;
  final PurchaseProductBranchDetailsAvailable availableInTransferringBranch;
  final PurchaseProductBranchDetailsRemaining
  remainingBalanceInTransferringBranch;
  final String expiryDate;
  final bool coolingStatus;
  final bool transferReady;

  final PurchaseProductBranchDetailsTransport transport;

  PurchaseProductBranchDetailsData({
    required this.itemId,
    required this.itemName,
    this.itemLogo,
    required this.itemCode,
    required this.itemUnit,
    required this.quantity,
    required this.quality,
    required this.qualityLabel,
    required this.availableInTransferringBranch,
    required this.remainingBalanceInTransferringBranch,
    required this.expiryDate,
    required this.coolingStatus,
    required this.transferReady,
    required this.transport,
  });

  factory PurchaseProductBranchDetailsData.fromJson(Map<String, dynamic> json) {
    return PurchaseProductBranchDetailsData(
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      itemCode: json['item_code'] as String,
      itemUnit: json['item_unit'] as String,
      quantity: (json['quantity'] as num).toInt(),
      quality: json['quality'] as String,
      qualityLabel: json['quality_label'] as String,
      availableInTransferringBranch:
          PurchaseProductBranchDetailsAvailable.fromJson(
            json['available_in_transferring_branch'] as Map<String, dynamic>,
          ),
      remainingBalanceInTransferringBranch:
          PurchaseProductBranchDetailsRemaining.fromJson(
            json['remaining_balance_in_transferring_branch']
                as Map<String, dynamic>,
          ),
      expiryDate: json['expiry_date'] as String,
      coolingStatus: json['cooling_status'] as bool,
      transferReady: json['transfer_ready'] as bool,
      transport: PurchaseProductBranchDetailsTransport.fromJson(
        json['transport'] as Map<String, dynamic>,
      ),
    );
  }
}

@JsonSerializable(createToJson: false)
class PurchaseProductBranchDetailsAvailable {
  final int quantity;

  @JsonKey(name: 'reserved_quantity')
  final int reservedQuantity;

  @JsonKey(name: 'actual_available')
  final int actualAvailable;

  final String quality;

  @JsonKey(name: 'quality_label')
  final String qualityLabel;

  PurchaseProductBranchDetailsAvailable({
    required this.quantity,
    required this.reservedQuantity,
    required this.actualAvailable,
    required this.quality,
    required this.qualityLabel,
  });

  factory PurchaseProductBranchDetailsAvailable.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductBranchDetailsAvailableFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseProductBranchDetailsRemaining {
  final int quantity;
  final String quality;

  @JsonKey(name: 'quality_label')
  final String qualityLabel;

  PurchaseProductBranchDetailsRemaining({
    required this.quantity,
    required this.quality,
    required this.qualityLabel,
  });

  factory PurchaseProductBranchDetailsRemaining.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductBranchDetailsRemainingFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseProductBranchDetailsTransport {
  final String method;

  @JsonKey(name: 'estimated_time_hours')
  final num estimatedTimeHours;

  final String? driver;
  final String temperature;

  @JsonKey(name: 'distance_km')
  final num distanceKm;

  final String cost;

  @JsonKey(name: 'from_branch')
  final PurchaseProductBranchDetailsBranch fromBranch;

  @JsonKey(name: 'to_branch')
  final PurchaseProductBranchDetailsBranch toBranch;

  PurchaseProductBranchDetailsTransport({
    required this.method,
    required this.estimatedTimeHours,
    this.driver,
    required this.temperature,
    required this.distanceKm,
    required this.cost,
    required this.fromBranch,
    required this.toBranch,
  });

  factory PurchaseProductBranchDetailsTransport.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductBranchDetailsTransportFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseProductBranchDetailsBranch {
  final String id;
  final String name;
  final String? address;

  PurchaseProductBranchDetailsBranch({
    required this.id,
    required this.name,
    required this.address,
  });

  factory PurchaseProductBranchDetailsBranch.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductBranchDetailsBranchFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseProductBranchDetailsTransportSummary {
  final String method;
  final String cost;

  @JsonKey(name: 'estimated_time_hours')
  final num estimatedTimeHours;

  final String? driver;

  @JsonKey(name: 'recommended_temperature')
  final String? recommendedTemperature;

  @JsonKey(name: 'distance_km')
  final num distanceKm;

  @JsonKey(name: 'from_branch')
  final PurchaseProductBranchDetailsBranch fromBranch;

  @JsonKey(name: 'to_branch')
  final PurchaseProductBranchDetailsBranch toBranch;

  final String notes;

  PurchaseProductBranchDetailsTransportSummary({
    required this.method,
    required this.cost,
    required this.estimatedTimeHours,
    this.driver,
    this.recommendedTemperature,
    required this.distanceKm,
    required this.fromBranch,
    required this.toBranch,
    required this.notes,
  });

  factory PurchaseProductBranchDetailsTransportSummary.fromJson(
    Map<String, dynamic> json,
  ) => _$PurchaseProductBranchDetailsTransportSummaryFromJson(json);
}
