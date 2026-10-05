import 'package:json_annotation/json_annotation.dart';

part 'receive_order_inspection_response.g.dart';

@JsonSerializable(createToJson: false)
class ReceiveOrderInspectionResponse {
  final ReceiveOrderInspectionData data;

  ReceiveOrderInspectionResponse({required this.data});

  factory ReceiveOrderInspectionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceiveOrderInspectionResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ReceiveOrderInspectionData {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'order_number')
  final String orderNumber;

  @JsonKey(name: 'supplier_name')
  final String supplierName;

  @JsonKey(name: 'delivery_details')
  final DeliveryDetails deliveryDetails;

  @JsonKey(name: 'goods_inspection')
  final List<GoodsInspectionItem> goodsInspection;

  ReceiveOrderInspectionData({
    required this.orderId,
    required this.orderNumber,
    required this.supplierName,
    required this.deliveryDetails,
    required this.goodsInspection,
  });

  factory ReceiveOrderInspectionData.fromJson(Map<String, dynamic> json) =>
      _$ReceiveOrderInspectionDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class DeliveryDetails {
  @JsonKey(name: 'driver_name')
  final String driverName;

  @JsonKey(name: 'contact_number')
  final String? contactNumber;

  @JsonKey(name: 'vehicle_number')
  final String vehicleNumber;

  @JsonKey(name: 'arrival_time')
  final String arrivalTime;

  @JsonKey(name: 'delivery_address', defaultValue: '')
  final String deliveryAddress;

  DeliveryDetails({
    required this.driverName,
    required this.contactNumber,
    required this.vehicleNumber,
    required this.arrivalTime,
    required this.deliveryAddress,
  });

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) =>
      _$DeliveryDetailsFromJson(json);
}

class GoodsInspectionItem {
  final String itemId;
  final String productName;
  final String? itemLogo;
  final int qtyOrdered;
  final double unitPrice;
  final String unit;

  GoodsInspectionItem({
    required this.itemId,
    required this.productName,
    required this.itemLogo,
    required this.qtyOrdered,
    required this.unitPrice,
    required this.unit,
  });

  factory GoodsInspectionItem.fromJson(Map<String, dynamic> json) {
    return GoodsInspectionItem(
      itemId: json['item_id'] as String,
      productName: json['product_name'] as String,
      itemLogo: json['item_logo'] as String?,
      qtyOrdered: json['qty_ordered'] as int,
      unitPrice: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }
}
