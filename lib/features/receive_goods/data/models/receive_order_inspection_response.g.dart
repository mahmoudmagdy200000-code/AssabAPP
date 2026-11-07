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
  financialSummary: json['financial_summary'] is Map<String, dynamic>
      ? InspectionFinancialSummary.fromJson(
          json['financial_summary'] as Map<String, dynamic>,
        )
      : null,
  invoice: json['invoice'] is Map<String, dynamic>
      ? InspectionInvoiceData.fromJson(
          json['invoice'] as Map<String, dynamic>,
        )
      : null,
);

InspectionFinancialSummary _$InspectionFinancialSummaryFromJson(
  Map<String, dynamic> json,
) => InspectionFinancialSummary(
  expectedAmount: (json['expected_amount'] as num?)?.toDouble(),
  receivedAmount: (json['received_amount'] as num?)?.toDouble(),
  varianceAmount: (json['variance_amount'] as num?)?.toDouble(),
  amountBeforeTax: (json['amount_before_tax'] as num?)?.toDouble(),
  vatRate: (json['vat_rate'] as num?)?.toDouble(),
  vatAmount: (json['vat_amount'] as num?)?.toDouble(),
  totalAmount: (json['total_amount'] as num?)?.toDouble(),
);

InspectionInvoiceData _$InspectionInvoiceDataFromJson(
  Map<String, dynamic> json,
) => InspectionInvoiceData(
  amountBeforeTax: (json['amount_before_tax'] as num?)?.toDouble(),
  taxRate: (json['tax_rate'] as num?)?.toDouble(),
  taxAmount: (json['tax_amount'] as num?)?.toDouble(),
  totalAmount: (json['total_amount'] as num?)?.toDouble(),
);

DeliveryDetails _$DeliveryDetailsFromJson(Map<String, dynamic> json) =>
    DeliveryDetails(
      driverName: json['driver_name'] as String,
      contactNumber: json['contact_number'] as String?,
      vehicleNumber: json['vehicle_number'] as String,
      arrivalTime: json['arrival_time'] as String,
      deliveryAddress: json['delivery_address'] as String? ?? '',
    );
