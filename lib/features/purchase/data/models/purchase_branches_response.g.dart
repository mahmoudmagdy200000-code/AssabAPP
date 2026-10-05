// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_branches_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseBranchesResponse _$PurchaseBranchesResponseFromJson(
  Map<String, dynamic> json,
) => PurchaseBranchesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => PurchaseBranchData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PurchaseBranchesResponseToJson(
  PurchaseBranchesResponse instance,
) => <String, dynamic>{'data': instance.data};

PurchaseBranchData _$PurchaseBranchDataFromJson(Map<String, dynamic> json) =>
    PurchaseBranchData(
      branchId: json['branch_id'] as String,
      branch: PurchaseBranchDataBranch.fromJson(
        json['branch'] as Map<String, dynamic>,
      ),
      branchManager: PurchaseBranchDataBranchManager.fromJson(
        json['branch_manager'] as Map<String, dynamic>,
      ),
      itemId: json['item_id'] as String,
      itemTitle: json['item_title'] as String,
      itemLogo: json['item_logo'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      totalAmount: json['total_amount'] as num,
      availableQuantity: json['available_quantity'] as num,
      availableQuantityLabel: json['available_quantity_label'] as String,
      availabilityPercentage: json['availability_percentage'] as num,
      quality: json['quality'] as String?,
      expiryDate: json['expiry_date'] as String?,
      coolingStatus: json['cooling_status'] as bool? ?? false,
      lastUpdate: json['last_update'] as String,
      distance: PurchaseBranchDataDistance.fromJson(
        json['distance'] as Map<String, dynamic>,
      ),
      responseRate: json['response_rate'] as num?,
      rating: json['rating'] as num?,
    );

Map<String, dynamic> _$PurchaseBranchDataToJson(PurchaseBranchData instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'branch': instance.branch,
      'branch_manager': instance.branchManager,
      'item_id': instance.itemId,
      'item_title': instance.itemTitle,
      'item_logo': instance.itemLogo,
      'quantity': instance.quantity,
      'total_amount': instance.totalAmount,
      'available_quantity': instance.availableQuantity,
      'available_quantity_label': instance.availableQuantityLabel,
      'availability_percentage': instance.availabilityPercentage,
      'quality': instance.quality,
      'expiry_date': instance.expiryDate,
      'cooling_status': instance.coolingStatus,
      'last_update': instance.lastUpdate,
      'distance': instance.distance,
      'response_rate': instance.responseRate,
      'rating': instance.rating,
    };

PurchaseBranchDataBranch _$PurchaseBranchDataBranchFromJson(
  Map<String, dynamic> json,
) => PurchaseBranchDataBranch(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$PurchaseBranchDataBranchToJson(
  PurchaseBranchDataBranch instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'image': instance.image,
};

PurchaseBranchDataBranchManager _$PurchaseBranchDataBranchManagerFromJson(
  Map<String, dynamic> json,
) => PurchaseBranchDataBranchManager(
  id: json['id'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$PurchaseBranchDataBranchManagerToJson(
  PurchaseBranchDataBranchManager instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
};

PurchaseBranchDataDistance _$PurchaseBranchDataDistanceFromJson(
  Map<String, dynamic> json,
) => PurchaseBranchDataDistance(
  distanceKm: json['distance_km'] as num,
  estimatedHours: json['estimated_hours'] as num,
);

Map<String, dynamic> _$PurchaseBranchDataDistanceToJson(
  PurchaseBranchDataDistance instance,
) => <String, dynamic>{
  'distance_km': instance.distanceKm,
  'estimated_hours': instance.estimatedHours,
};
