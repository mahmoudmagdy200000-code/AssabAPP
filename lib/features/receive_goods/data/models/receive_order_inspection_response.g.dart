// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_order_inspection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiveOrderInspectionResponse _$ReceiveOrderInspectionResponseFromJson(
  Map<String, dynamic> json,
) => ReceiveOrderInspectionResponse(
  data: ReceiveOrderInspectionData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

ReceiveOrderInspectionData _$ReceiveOrderInspectionDataFromJson(
  Map<String, dynamic> json,
) => ReceiveOrderInspectionData(
  orderId: json['order_id'] as String,
  orderNumber: json['order_number'] as String,
  supplierName: json['supplier_name'] as String,
  deliveryDetails: DeliveryDetails.fromJson(
    json['delivery_details'] as Map<String, dynamic>,
  ),
  goodsInspection: (json['goods_inspection'] as List<dynamic>)
      .map((e) => GoodsInspectionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

DeliveryDetails _$DeliveryDetailsFromJson(Map<String, dynamic> json) =>
    DeliveryDetails(
      driverName: json['driver_name'] as String,
      contactNumber: json['contact_number'] as String?,
      vehicleNumber: json['vehicle_number'] as String,
      arrivalTime: json['arrival_time'] as String,
      deliveryAddress: json['delivery_address'] as String? ?? '',
    );
