import 'package:json_annotation/json_annotation.dart';

part 'purchase_branches_response.g.dart';

@JsonSerializable()
class PurchaseBranchesResponse {
  final List<PurchaseBranchData> data;

  PurchaseBranchesResponse({required this.data});

  factory PurchaseBranchesResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBranchesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseBranchesResponseToJson(this);
}

@JsonSerializable()
class PurchaseBranchData {
  @JsonKey(name: 'branch_id')
  final String branchId;

  @JsonKey(name: 'branch')
  final PurchaseBranchDataBranch branch;

  @JsonKey(name: 'branch_manager')
  final PurchaseBranchDataBranchManager branchManager;

  @JsonKey(name: 'item_id')
  final String itemId;

  @JsonKey(name: 'item_title')
  final String itemTitle;

  @JsonKey(name: 'item_logo')
  final String? itemLogo;

  final int quantity;

  @JsonKey(name: 'total_amount')
  final num totalAmount;

  @JsonKey(name: 'available_quantity')
  final num availableQuantity;

  @JsonKey(name: 'available_quantity_label')
  final String availableQuantityLabel;

  @JsonKey(name: 'availability_percentage')
  final num availabilityPercentage;

  final String? quality;

  @JsonKey(name: 'expiry_date')
  final String? expiryDate;

  @JsonKey(name: 'cooling_status', defaultValue: false)
  final bool coolingStatus;

  @JsonKey(name: 'last_update')
  final String lastUpdate;

  final PurchaseBranchDataDistance distance;

  @JsonKey(name: 'response_rate')
  final num? responseRate;

  final num? rating;

  PurchaseBranchData({
    required this.branchId,
    required this.branch,
    required this.branchManager,
    required this.itemId,
    required this.itemTitle,
    this.itemLogo,
    required this.quantity,
    required this.totalAmount,
    required this.availableQuantity,
    required this.availableQuantityLabel,
    required this.availabilityPercentage,
    this.quality,
    this.expiryDate,
    required this.coolingStatus,
    required this.lastUpdate,
    required this.distance,
    this.responseRate,
    this.rating,
  });

  factory PurchaseBranchData.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBranchDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseBranchDataToJson(this);
}

@JsonSerializable()
class PurchaseBranchDataBranch {
  final String id;
  final String name;
  final String? location;
  final String? image;

  PurchaseBranchDataBranch({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
  });

  factory PurchaseBranchDataBranch.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBranchDataBranchFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseBranchDataBranchToJson(this);
}

@JsonSerializable()
class PurchaseBranchDataBranchManager {
  final String id;
  final String name;
  final String? image;

  PurchaseBranchDataBranchManager({
    required this.id,
    required this.name,
    this.image,
  });

  factory PurchaseBranchDataBranchManager.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBranchDataBranchManagerFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PurchaseBranchDataBranchManagerToJson(this);
}

@JsonSerializable()
class PurchaseBranchDataDistance {
  @JsonKey(name: 'distance_km')
  final num distanceKm;

  @JsonKey(name: 'estimated_hours')
  final num estimatedHours;

  PurchaseBranchDataDistance({
    required this.distanceKm,
    required this.estimatedHours,
  });

  factory PurchaseBranchDataDistance.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBranchDataDistanceFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseBranchDataDistanceToJson(this);
}
