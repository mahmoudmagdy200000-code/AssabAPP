import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/enums/requests_orders_types_enum.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';

part 'orders_response.g.dart';

@JsonSerializable(createToJson: false)
class OrdersResponse {
  final OrdersResponseData data;
  final MetaModel meta;

  OrdersResponse({required this.meta, required this.data});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrdersResponseData {
  final List<OrderData> orders;

  @JsonKey(name: 'requested_orders')
  final List<OrderData> requests;

  OrdersResponseData({required this.orders, required this.requests});

  factory OrdersResponseData.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseDataFromJson(json);
}

class OrderData {
  final String id;
  final RequestsOrderStatusStrategy status;

  @JsonKey(name: 'order_type')
  final PurchaseSourceStrategy orderType;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'request_type')
  final RequestsOrdersTypesEnum requestType;

  @JsonKey(name: 'source_name')
  final String? sourceName;

  final List<OrderDataItem> items;

  OrderData({
    required this.id,
    required this.status,
    required this.orderType,
    required this.createdAt,
    required this.requestType,
    this.sourceName,
    required this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] as String,
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      orderType: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['order_type'] as String),
      ),
      createdAt: json['created_at'] as String,
      requestType: RequestsOrdersTypesEnum.fromString(
        json['request_type'] as String,
      ),
      sourceName: json['source_name'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderDataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@JsonSerializable(createToJson: false)
class OrderDataItem {
  final String id;

  @JsonKey(name: 'item_id')
  final String itemId;

  @JsonKey(name: 'item_name')
  final String itemName;

  @JsonKey(name: 'item_logo')
  final String? itemLogo;

  final String? category;
  final String? subcategory;

  @JsonKey(name: 'quantity_ordered')
  final int quantityOrdered;

  @JsonKey(name: 'quantity_confirmed')
  final int? quantityConfirmed;

  @JsonKey(name: 'quantity_received')
  final int? quantityReceived;

  @JsonKey(name: 'unit_of_measurement')
  final String? unitOfMeasurement;

  @JsonKey(name: 'balance_quantity')
  final int balanceQuantity;

  @JsonKey(name: 'unit_price')
  final num unitPrice;

  @JsonKey(name: 'total_price')
  final num totalPrice;

  final num discount;

  @JsonKey(name: 'quality_ordered')
  final String? qualityOrdered;

  @JsonKey(name: 'quality_received')
  final String? qualityReceived;

  @JsonKey(name: 'available_in_source')
  final num? availableInSource;

  @JsonKey(name: 'daily_consumption_quantity')
  final num? dailyConsumptionQuantity;

  @JsonKey(name: 'weekend_forecast_quantity')
  final num? weekendForecastQuantity;

  @JsonKey(name: 'next_supply')
  final String? nextSupply;

  @JsonKey(name: 'remaining_balance')
  final num? remainingBalance;

  @JsonKey(name: 'daily_consumption')
  final num? dailyConsumption;

  @JsonKey(name: 'weekend_forecast')
  final num? weekendForecast;

  @JsonKey(name: 'next_supply_date')
  final String? nextSupplyDate;

  @JsonKey(name: 'expiry_date')
  final String? expiryDate;

  final String? temperature;

  @JsonKey(name: 'cooling_status')
  final bool? coolingStatus;

  final String? status;

  @JsonKey(name: 'quantity_variance')
  final int quantityVariance;

  @JsonKey(name: 'has_variance')
  final bool hasVariance;

  @JsonKey(name: 'original_quantity')
  final int? originalQuantity;

  @JsonKey(name: 'new_quantity')
  final int? newQuantity;

  @JsonKey(name: 'modification_note')
  final String? modificationNote;

  OrderDataItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.itemLogo,
    this.category,
    this.subcategory,
    required this.quantityOrdered,
    this.quantityConfirmed,
    this.quantityReceived,
    this.unitOfMeasurement,
    required this.balanceQuantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.discount,
    this.qualityOrdered,
    this.qualityReceived,
    this.availableInSource,
    this.dailyConsumptionQuantity,
    this.weekendForecastQuantity,
    this.nextSupply,
    this.remainingBalance,
    this.dailyConsumption,
    this.weekendForecast,
    this.nextSupplyDate,
    this.expiryDate,
    this.temperature,
    this.coolingStatus,
    this.status,
    required this.quantityVariance,
    required this.hasVariance,
    this.originalQuantity,
    this.newQuantity,
    this.modificationNote,
  });

  factory OrderDataItem.fromJson(Map<String, dynamic> json) =>
      _$OrderDataItemFromJson(json);
}
