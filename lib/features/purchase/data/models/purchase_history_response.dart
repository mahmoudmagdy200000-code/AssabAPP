import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';

part 'purchase_history_response.g.dart';

@JsonSerializable(createToJson: false)
class PurchaseHistoryResponse {
  final List<PurchaseHistoryData> data;
  final MetaModel meta;

  PurchaseHistoryResponse({required this.data, required this.meta});

  factory PurchaseHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryResponseFromJson(json);
}

class PurchaseHistoryData {
  final String id;
  final PurchaseSourceStrategy orderType;
  final RequestsOrderStatusStrategy status;
  final String createdAt;
  final List<PurchaseHistoryDataItem> items;

  PurchaseHistoryData({
    required this.id,
    required this.orderType,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory PurchaseHistoryData.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryData(
      id: json['id'] as String,
      orderType: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['order_type'] as String),
      ),
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      createdAt: json['created_at'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => PurchaseHistoryDataItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

@JsonSerializable(createToJson: false)
class PurchaseHistoryDataItem {
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

  @JsonKey(name: 'unit_of_measurement', defaultValue: 'kg')
  final String unitOfMeasurement;

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
  final String? coolingStatus;

  @JsonKey(defaultValue: 'pending')
  final String status;

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

  PurchaseHistoryDataItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.itemLogo,
    this.category,
    this.subcategory,
    required this.quantityOrdered,
    this.quantityConfirmed,
    this.quantityReceived,
    required this.unitOfMeasurement,
    required this.balanceQuantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.discount,
    this.qualityOrdered,
    this.qualityReceived,
    this.availableInSource,
    this.remainingBalance,
    this.dailyConsumption,
    this.weekendForecast,
    this.nextSupplyDate,
    this.expiryDate,
    this.temperature,
    this.coolingStatus,
    required this.status,
    required this.quantityVariance,
    required this.hasVariance,
    this.originalQuantity,
    this.newQuantity,
    this.modificationNote,
  });

  factory PurchaseHistoryDataItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryDataItemFromJson(json);
}
