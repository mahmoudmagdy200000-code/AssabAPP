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
      status: (json['status'] ?? '').toString(),
      items: (json['items'] as List? ?? const [])
          .map((e) => OrderTrackResponsePreparingItem.fromJson(e))
          .toList(),
      startedAt: (json['started_at'] ?? '').toString(),
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
      itemName: (json['item_name'] ?? '').toString(),
      itemLogo: json['item_logo']?.toString(),
      requestedQuantity: (json['requested_quantity'] as num?)?.toInt() ?? 0,
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
      arrivalTime: json['arrival_time'] as String? ?? '',
      driverDetails: OrderTrackResponseDriverDetails.fromJson(
        json['driver_details'],
      ),
      deliveryAddress: json['delivery_address'] as String? ?? '',
      deliveryNotes: json['delivery_notes'] as String?,
      startedAt: json['started_at'] as String? ?? '',
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
      name: json['name'] as String? ?? '',
      photo: json['photo'] != null
          ? AttachmentModel.fromJson(json['photo'])
          : null,
      vehicleNumber: json['vehicle_number'] as String? ?? '',
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
      startedAt: (json['started_at'] ?? '').toString(),
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
      numberOfItems: (json['number_of_items'] as num?)?.toInt() ?? 0,
      quantityVariance: (json['quantity_variance'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?) ?? 0,
      driverName: json['driver_name'] as String? ?? '',
      contactNumber: json['contact_number'] as String?,
      vehicleNumber: json['vehicle_number'] as String? ?? '',
      arrivalTime: json['arrival_time'] as String? ?? '',
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
      itemName: (json['item_name'] ?? '').toString(),
      itemLogo: json['item_logo']?.toString(),
      quantityOrdered: (json['quantity_ordered'] as num?)?.toInt() ?? 0,
      quantityReceived: (json['quantity_received'] as num?)?.toInt() ?? 0,
      unit: (json['item_unit'] ?? '').toString(),
      quality: PurchasingOfficerQualityEnum.fromString(
        (json['quality'] as String?) ?? '-',
      ),
      varianceType: (json['variance_type'] ?? '').toString(),
      amountVariance: (json['amount_variance'] as num?) ?? 0,
      temperature: (json['temperature'] ?? '').toString(),
      expirationDate: (json['expiration_date'] ?? '').toString(),
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
      invoiceNumber: (json['invoice_number'] ?? '').toString(),
      invoiceDate: (json['invoice_date'] ?? '').toString(),
      supplierName: (json['supplier_name'] ?? '').toString(),
      amountBeforeTax: (json['amount_before_tax'] as num?) ?? 0,
      vat: (json['vat'] as num?) ?? 0,
      totalAmount: (json['total_amount'] as num?) ?? 0,
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
        RequestsOrderStatusEnum.fromString(
          (json['status'] as String?) ?? 'variance',
        ),
      ),
      variances: (json['variances'] as List? ?? const [])
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
      itemName: (json['item_name'] ?? '').toString(),
      itemLogo: json['item_logo']?.toString(),
      temperature: (json['temperature'] ?? '').toString(),
      quantityOrdered: (json['quantity_ordered'] as num?)?.toInt() ?? 0,
      quantityReceived: (json['quantity_received'] as num?)?.toInt() ?? 0,
      unit: (json['item_unit'] ?? '').toString(),
      quality: PurchasingOfficerQualityEnum.fromString(
        (json['quality'] as String?) ?? '-',
      ),
      varianceType: (json['variance_type'] ?? '').toString(),
      amountVariance: (json['amount_variance'] as num?) ?? 0,
      supplierResponse: json['supplier_response']?.toString(),
      supplierDecisionStatus:
          (json['supplier_decision_status'] ?? '').toString(),
      reportedOn: (json['reported_on'] ?? '').toString(),
      respondedOn: json['responded_on']?.toString(),
      supplierName: (json['supplier_name'] ?? '').toString(),
      supplierImage: json['supplier_image'] != null
          ? AttachmentModel.fromJson(json['supplier_image'])
          : null,
      rejectionReason: json['rejection_reason']?.toString(),
      rejectionDateTime: json['rejection_date_time']?.toString(),
    );
  }
}
