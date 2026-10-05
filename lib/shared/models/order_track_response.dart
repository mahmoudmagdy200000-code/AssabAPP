import 'package:assab/core/enums/document_type_enum.dart';
import 'package:assab/core/enums/purchasing_officer_quality_enum.dart';
import 'package:assab/core/enums/requests_order_status_enum.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';

import '../../core/strategies/requests_order_status_strategy.dart';
import '../../features/receive_goods/domain/strategies/document_type_strategy.dart';

class OrderTrackResponse {
  final OrderTrackResponseData data;

  OrderTrackResponse({required this.data});

  factory OrderTrackResponse.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponse(
      data: OrderTrackResponseData.fromJson(json['data']),
    );
  }
}

class OrderTrackResponseData {
  final String orderId;
  final OrderTrackResponseStages stages;

  OrderTrackResponseData({required this.orderId, required this.stages});

  factory OrderTrackResponseData.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponseData(
      orderId: json['order_id'],
      stages: OrderTrackResponseStages.fromJson(json['stages']),
    );
  }
}

class OrderTrackResponseStages {
  final OrderTrackResponsePreparingStage? preparing;
  final OrderTrackResponseOutForDeliveryStage? outForDelivery;
  final OrderTrackResponseDeliveredStage? delivered;
  final OrderTrackResponseOrderConfirmationStage? orderConfirmation;
  final OrderTrackResponseVarianceLoggedStage? varianceLogged;

  OrderTrackResponseStages({
    this.preparing,
    this.outForDelivery,
    this.delivered,
    this.orderConfirmation,
    this.varianceLogged,
  });

  factory OrderTrackResponseStages.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponseStages(
      preparing: json['preparing'] != null
          ? OrderTrackResponsePreparingStage.fromJson(json['preparing'])
          : null,
      outForDelivery: json['out_for_delivery'] != null
          ? OrderTrackResponseOutForDeliveryStage.fromJson(
              json['out_for_delivery'],
            )
          : null,
      delivered: json['delivered'] != null
          ? OrderTrackResponseDeliveredStage.fromJson(json['delivered'])
          : null,
      orderConfirmation: json['order_confirmation'] != null
          ? OrderTrackResponseOrderConfirmationStage.fromJson(
              json['order_confirmation'],
            )
          : null,
      varianceLogged: json['variance_logged'] != null
          ? OrderTrackResponseVarianceLoggedStage.fromJson(
              json['variance_logged'],
            )
          : null,
    );
  }
}

class OrderTrackResponsePreparingStage {
  final String status;
  final List<OrderTrackResponsePreparingItem> items;
  final String startedAt;

  OrderTrackResponsePreparingStage({
    required this.status,
    required this.items,
    required this.startedAt,
  });

  factory OrderTrackResponsePreparingStage.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponsePreparingStage(
      status: json['status'],
      items: (json['items'] as List)
          .map((e) => OrderTrackResponsePreparingItem.fromJson(e))
          .toList(),
      startedAt: json['started_at'],
    );
  }
}

class OrderTrackResponsePreparingItem {
  final String itemName;
  final String? itemLogo;
  final int requestedQuantity;
  final String unit;
  final RequestsOrderStatusStrategy status;
  final AttachmentModel? qualityCertificate;

  OrderTrackResponsePreparingItem({
    required this.itemName,
    this.itemLogo,
    required this.requestedQuantity,
    required this.unit,
    required this.status,
    required this.qualityCertificate,
  });

  factory OrderTrackResponsePreparingItem.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponsePreparingItem(
      itemName: json['item_name'],
      itemLogo: json['item_logo'],
      requestedQuantity: json['requested_quantity'],
      unit: json['item_unit'] as String,
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      qualityCertificate: json['quality_certificate'] != null
          ? AttachmentModel.fromJson(json['quality_certificate'])
          : null,
    );
  }
}

class OrderTrackResponseOutForDeliveryStage {
  final RequestsOrderStatusStrategy status;
  final String arrivalTime;
  final OrderTrackResponseDriverDetails driverDetails;
  final String deliveryAddress;
  final String? deliveryNotes;
  final String startedAt;

  OrderTrackResponseOutForDeliveryStage({
    required this.status,
    required this.arrivalTime,
    required this.driverDetails,
    required this.deliveryAddress,
    required this.deliveryNotes,
    required this.startedAt,
  });

  factory OrderTrackResponseOutForDeliveryStage.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderTrackResponseOutForDeliveryStage(
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      arrivalTime: json['arrival_time'],
      driverDetails: OrderTrackResponseDriverDetails.fromJson(
        json['driver_details'],
      ),
      deliveryAddress: json['delivery_address'],
      deliveryNotes: json['delivery_notes'],
      startedAt: json['started_at'],
    );
  }
}

class OrderTrackResponseDriverDetails {
  final String name;
  final AttachmentModel? photo;
  final String vehicleNumber;

  OrderTrackResponseDriverDetails({
    required this.name,
    this.photo,
    required this.vehicleNumber,
  });

  factory OrderTrackResponseDriverDetails.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponseDriverDetails(
      name: json['name'],
      photo: json['photo'] != null
          ? AttachmentModel.fromJson(json['photo'])
          : null,
      vehicleNumber: json['vehicle_number'],
    );
  }
}

class OrderTrackResponseDeliveredStage {
  final RequestsOrderStatusStrategy status;
  final String startedAt;
  final List<AttachmentModel> deliveryPhotos;

  OrderTrackResponseDeliveredStage({
    required this.status,
    required this.startedAt,
    required this.deliveryPhotos,
  });

  factory OrderTrackResponseDeliveredStage.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponseDeliveredStage(
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      startedAt: json['started_at'],
      deliveryPhotos: (json['delivery_photos'] as List? ?? [])
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderTrackResponseOrderConfirmationStage {
  final RequestsOrderStatusStrategy status;
  final OrderTrackResponseReceiptDetails receiptDetails;

  OrderTrackResponseOrderConfirmationStage({
    required this.status,
    required this.receiptDetails,
  });

  factory OrderTrackResponseOrderConfirmationStage.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderTrackResponseOrderConfirmationStage(
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      receiptDetails: OrderTrackResponseReceiptDetails.fromJson(
        json['receipt_details'],
      ),
    );
  }
}

class OrderTrackResponseReceiptDetails {
  final String? dateTime;
  final OrderTrackResponseInspectionSummary inspectionSummary;
  final List<OrderTrackResponseGoodsInspection> goodsInspections;
  final DocumentTypeStrategy? documentType;
  final OrderTrackResponseFinancialSummary financialSummary;

  OrderTrackResponseReceiptDetails({
    this.dateTime,
    required this.inspectionSummary,
    required this.goodsInspections,
    this.documentType,
    required this.financialSummary,
  });

  factory OrderTrackResponseReceiptDetails.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponseReceiptDetails(
      dateTime: json['date_time'],
      inspectionSummary: OrderTrackResponseInspectionSummary.fromJson(
        json['inspection_summary'],
      ),
      goodsInspections: (json['goods_inspections'] as List)
          .map((e) => OrderTrackResponseGoodsInspection.fromJson(e))
          .toList(),
      documentType: json['document_type'] != null
          ? DocumentTypeEnum.getStrategy(
              DocumentTypeEnum.fromValue(json['document_type'] as String),
            )
          : null,
      financialSummary: OrderTrackResponseFinancialSummary.fromJson(
        json['financial_summary'],
      ),
    );
  }
}

class OrderTrackResponseInspectionSummary {
  final int numberOfItems;
  final int quantityVariance;
  final num totalAmount;
  final String driverName;
  final String? contactNumber;
  final String vehicleNumber;
  final String arrivalTime;

  OrderTrackResponseInspectionSummary({
    required this.numberOfItems,
    required this.quantityVariance,
    required this.totalAmount,
    required this.driverName,
    this.contactNumber,
    required this.vehicleNumber,
    required this.arrivalTime,
  });

  factory OrderTrackResponseInspectionSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderTrackResponseInspectionSummary(
      numberOfItems: json['number_of_items'],
      quantityVariance: json['quantity_variance'],
      totalAmount: json['total_amount'],
      driverName: json['driver_name'],
      contactNumber: json['contact_number'],
      vehicleNumber: json['vehicle_number'],
      arrivalTime: json['arrival_time'],
    );
  }
}

class OrderTrackResponseGoodsInspection {
  final String itemName;
  final String? itemLogo;
  final int quantityOrdered;
  final int quantityReceived;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final String varianceType;
  final num amountVariance;
  final String temperature;
  final String expirationDate;
  final AttachmentModel? itemImage;
  final String? additionalNote;

  OrderTrackResponseGoodsInspection({
    required this.itemName,
    this.itemLogo,
    required this.quantityOrdered,
    required this.quantityReceived,
    required this.unit,
    required this.quality,
    required this.varianceType,
    required this.amountVariance,
    required this.temperature,
    required this.expirationDate,
    this.itemImage,
    this.additionalNote,
  });

  factory OrderTrackResponseGoodsInspection.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderTrackResponseGoodsInspection(
      itemName: json['item_name'],
      itemLogo: json['item_logo'],
      quantityOrdered: json['quantity_ordered'],
      quantityReceived: json['quantity_received'],
      unit: json['item_unit'] as String,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      varianceType: json['variance_type'],
      amountVariance: json['amount_variance'],
      temperature: json['temperature'],
      expirationDate: json['expiration_date'],
      itemImage: json['item_image'] != null
          ? AttachmentModel.fromJson(json['item_image'])
          : null,
      additionalNote: json['additional_note'],
    );
  }
}

class OrderTrackResponseFinancialSummary {
  final String invoiceNumber;
  final String invoiceDate;
  final String supplierName;
  final num amountBeforeTax;
  final num vat;
  final num totalAmount;

  OrderTrackResponseFinancialSummary({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.supplierName,
    required this.amountBeforeTax,
    required this.vat,
    required this.totalAmount,
  });

  factory OrderTrackResponseFinancialSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderTrackResponseFinancialSummary(
      invoiceNumber: json['invoice_number'],
      invoiceDate: json['invoice_date'],
      supplierName: json['supplier_name'],
      amountBeforeTax: json['amount_before_tax'],
      vat: json['vat'],
      totalAmount: json['total_amount'],
    );
  }
}

class OrderTrackResponseVarianceLoggedStage {
  final RequestsOrderStatusStrategy status;
  final List<OrderTrackResponseVarianceItem> variances;

  OrderTrackResponseVarianceLoggedStage({
    required this.status,
    required this.variances,
  });

  factory OrderTrackResponseVarianceLoggedStage.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderTrackResponseVarianceLoggedStage(
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      variances: (json['variances'] as List)
          .map((e) => OrderTrackResponseVarianceItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderTrackResponseVarianceItem {
  final String itemName;
  final String? itemLogo;
  final String temperature;
final int quantityOrdered;
  final int quantityReceived;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final String varianceType;
  final num amountVariance;
  final String? supplierResponse;
  final String supplierDecisionStatus;
  final String reportedOn;
  final String? respondedOn;
  final String supplierName;
  final AttachmentModel? supplierImage;
  final String? rejectionReason;
  final String? rejectionDateTime;

  OrderTrackResponseVarianceItem({
    required this.itemName,
    this.itemLogo,
    required this.temperature,
    required this.quantityOrdered,
    required this.quantityReceived,
    required this.unit,
    required this.quality,
    required this.varianceType,
    required this.amountVariance,
    this.supplierResponse,
    required this.supplierDecisionStatus,
    required this.reportedOn,
    this.respondedOn,
    required this.supplierName,
    this.supplierImage,
    this.rejectionReason,
    this.rejectionDateTime,
  });

  factory OrderTrackResponseVarianceItem.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponseVarianceItem(
      itemName: json['item_name'],
      itemLogo: json['item_logo'],
      temperature: json['temperature'],
      quantityOrdered: json['quantity_ordered'],
      quantityReceived: json['quantity_received'],
      unit: json['item_unit'] as String,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      varianceType: json['variance_type'],
      amountVariance: json['amount_variance'],
      supplierResponse: json['supplier_response'],
      supplierDecisionStatus: json['supplier_decision_status'],
      reportedOn: json['reported_on'],
      respondedOn: json['responded_on'],
      supplierName: json['supplier_name'],
      supplierImage: json['supplier_image'] != null
          ? AttachmentModel.fromJson(json['supplier_image'])
          : null,
      rejectionReason: json['rejection_reason'],
      rejectionDateTime: json['rejection_date_time'],
    );
  }
}
