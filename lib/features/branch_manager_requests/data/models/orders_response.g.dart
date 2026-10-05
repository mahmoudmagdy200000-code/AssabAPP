// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersResponse _$OrdersResponseFromJson(Map<String, dynamic> json) =>
    OrdersResponse(
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      data: OrdersResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

OrdersResponseData _$OrdersResponseDataFromJson(Map<String, dynamic> json) =>
    OrdersResponseData(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderData.fromJson(e as Map<String, dynamic>))
          .toList(),
      requests: (json['requested_orders'] as List<dynamic>)
          .map((e) => OrderData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

OrderDataItem _$OrderDataItemFromJson(Map<String, dynamic> json) =>
    OrderDataItem(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      quantityOrdered: (json['quantity_ordered'] as num).toInt(),
      quantityConfirmed: (json['quantity_confirmed'] as num?)?.toInt(),
      quantityReceived: (json['quantity_received'] as num?)?.toInt(),
      unitOfMeasurement: json['unit_of_measurement'] as String?,
      balanceQuantity: (json['balance_quantity'] as num).toInt(),
      unitPrice: json['unit_price'] as num,
      totalPrice: json['total_price'] as num,
      discount: json['discount'] as num,
      qualityOrdered: json['quality_ordered'] as String?,
      qualityReceived: json['quality_received'] as String?,
      availableInSource: json['available_in_source'] as num?,
      dailyConsumptionQuantity: json['daily_consumption_quantity'] as num?,
      weekendForecastQuantity: json['weekend_forecast_quantity'] as num?,
      nextSupply: json['next_supply'] as String?,
      remainingBalance: json['remaining_balance'] as num?,
      dailyConsumption: json['daily_consumption'] as num?,
      weekendForecast: json['weekend_forecast'] as num?,
      nextSupplyDate: json['next_supply_date'] as String?,
      expiryDate: json['expiry_date'] as String?,
      temperature: json['temperature'] as String?,
      coolingStatus: json['cooling_status'] as bool?,
      status: json['status'] as String?,
      quantityVariance: (json['quantity_variance'] as num).toInt(),
      hasVariance: json['has_variance'] as bool,
      originalQuantity: (json['original_quantity'] as num?)?.toInt(),
      newQuantity: (json['new_quantity'] as num?)?.toInt(),
      modificationNote: json['modification_note'] as String?,
    );
