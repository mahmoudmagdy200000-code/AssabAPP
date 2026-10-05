// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseHistoryResponse _$PurchaseHistoryResponseFromJson(
  Map<String, dynamic> json,
) => PurchaseHistoryResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => PurchaseHistoryData.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

PurchaseHistoryDataItem _$PurchaseHistoryDataItemFromJson(
  Map<String, dynamic> json,
) => PurchaseHistoryDataItem(
  id: json['id'] as String,
  itemId: json['item_id'] as String,
  itemName: json['item_name'] as String,
  itemLogo: json['item_logo'] as String?,
  category: json['category'] as String?,
  subcategory: json['subcategory'] as String?,
  quantityOrdered: (json['quantity_ordered'] as num).toInt(),
  quantityConfirmed: (json['quantity_confirmed'] as num?)?.toInt(),
  quantityReceived: (json['quantity_received'] as num?)?.toInt(),
  unitOfMeasurement: json['unit_of_measurement'] as String? ?? 'kg',
  balanceQuantity: (json['balance_quantity'] as num).toInt(),
  unitPrice: json['unit_price'] as num,
  totalPrice: json['total_price'] as num,
  discount: json['discount'] as num,
  qualityOrdered: json['quality_ordered'] as String?,
  qualityReceived: json['quality_received'] as String?,
  availableInSource: json['available_in_source'] as num?,
  remainingBalance: json['remaining_balance'] as num?,
  dailyConsumption: json['daily_consumption'] as num?,
  weekendForecast: json['weekend_forecast'] as num?,
  nextSupplyDate: json['next_supply_date'] as String?,
  expiryDate: json['expiry_date'] as String?,
  temperature: json['temperature'] as String?,
  coolingStatus: json['cooling_status'] as String?,
  status: json['status'] as String? ?? 'pending',
  quantityVariance: (json['quantity_variance'] as num).toInt(),
  hasVariance: json['has_variance'] as bool,
  originalQuantity: (json['original_quantity'] as num?)?.toInt(),
  newQuantity: (json['new_quantity'] as num?)?.toInt(),
  modificationNote: json['modification_note'] as String?,
);
