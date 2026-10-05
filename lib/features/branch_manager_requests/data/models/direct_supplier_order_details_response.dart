import 'package:assab/core/enums/purchasing_officer_quality_enum.dart';
import 'package:assab/shared/models/supplier_details_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/delay_details_response.dart';

class DirectSupplierOrderDetailsResponse {
  final DirectSupplierOrderDetailsRequestSummary requestSummary;
  final List<DirectSupplierOrderDetailsProductDetail> productDetails;
  final SupplierDetailsResponse supplier;
  final TimeLineResponse timelines;

  DirectSupplierOrderDetailsResponse({
    required this.requestSummary,
    required this.productDetails,
    required this.supplier,
    required this.timelines,
  });

  factory DirectSupplierOrderDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return DirectSupplierOrderDetailsResponse(
      requestSummary: DirectSupplierOrderDetailsRequestSummary.fromJson(
        data['request_summary'] as Map<String, dynamic>,
      ),
      productDetails: (data['product_details'] as List)
          .map(
            (e) => DirectSupplierOrderDetailsProductDetail.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      supplier: SupplierDetailsResponse.fromJson(
        data['supplier'] as Map<String, dynamic>,
      ),
      timelines: TimeLineResponse.fromJson(data),
    );
  }
}

class DirectSupplierOrderDetailsRequestSummary {
  final String id;
  final String orderNumber;
  final DirectSupplierOrderDetailsBranch from;
  final PurchaseSourceStrategy type;
  final String supplierName;
  final double totalAmount;
  final String message;
  final RequestsOrderStatusStrategy status;
  final CancelReasonInOrderResponse? reasonForRejected;
  final DelayDetails? delayDetails;

  DirectSupplierOrderDetailsRequestSummary({
    required this.id,
    required this.orderNumber,
    required this.from,
    required this.type,
    required this.supplierName,
    required this.totalAmount,
    required this.message,
    required this.status,
    this.reasonForRejected,
    this.delayDetails,
  });

  factory DirectSupplierOrderDetailsRequestSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectSupplierOrderDetailsRequestSummary(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      from: DirectSupplierOrderDetailsBranch.fromJson(
        json['from'] as Map<String, dynamic>,
      ),
      type: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['type'] as String),
      ),
      supplierName: json['supplier_name'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      message: json['message'] as String,
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      reasonForRejected: json['reason_for_rejected'] != null
          ? CancelReasonInOrderResponse.fromJson(
              json['reason_for_rejected'] as Map<String, dynamic>,
            )
          : null,
      delayDetails: json['delay_details'] != null
          ? DelayDetails.fromJson(json['delay_details'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DirectSupplierOrderDetailsBranch {
  final String branchName;
  final String branchLocation;

  DirectSupplierOrderDetailsBranch({
    required this.branchName,
    required this.branchLocation,
  });

  factory DirectSupplierOrderDetailsBranch.fromJson(Map<String, dynamic> json) {
    return DirectSupplierOrderDetailsBranch(
      branchName: json['branch_name'] as String,
      branchLocation: json['location'] as String,
    );
  }
}

class DirectSupplierOrderDetailsProductDetail {
  final String id;
  final String itemId;
  final String itemName;
  final RequestsOrderStatusStrategy status;
  final int requestedQty;
  final int quantityConfirmed;
  final PurchasingOfficerQualityEnum quality;
  final double itemPrice;
  final String itemUnit;
  final double totalPrice;

  DirectSupplierOrderDetailsProductDetail({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.status,
    required this.requestedQty,
    required this.quantityConfirmed,
    required this.quality,
    required this.itemPrice,
    required this.itemUnit,
    required this.totalPrice,
  });

  factory DirectSupplierOrderDetailsProductDetail.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectSupplierOrderDetailsProductDetail(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      requestedQty: (json['requested_qty'] as num).toInt(),
      quantityConfirmed: (json['quantity_confirmed'] as num?)?.toInt() ?? 0,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      itemPrice: (json['item_price'] as num).toDouble(),
      itemUnit: json['item_unit'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}
