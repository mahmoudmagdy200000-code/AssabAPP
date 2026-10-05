import 'package:assab/core/enums/priority_type.dart';
import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/strategies/priorities_strategy.dart';
import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';

class OrderDetailsResponse {
  final OrderDetailsData data;

  OrderDetailsResponse({required this.data});

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      data: OrderDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class OrderDetailsData {
  final OrderDetailsResponseRequestSummary requestSummary;
  final List<OrderDetailsResponseProductDetails> productDetails;
  final TimeLineResponse timelines;

  OrderDetailsData({
    required this.requestSummary,
    required this.productDetails,
    required this.timelines,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    return OrderDetailsData(
      requestSummary: OrderDetailsResponseRequestSummary.fromJson(
        json['request_summary'] as Map<String, dynamic>,
      ),
      productDetails: (json['product_details'] as List<dynamic>)
          .map(
            (e) => OrderDetailsResponseProductDetails.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      timelines: TimeLineResponse.fromJson(json),
    );
  }
}

class OrderDetailsResponseRequestSummary {
  final String id;
  final String requestNo;
  final PurchaseSourceStrategy type;
  final OrderDetailsResponseRequestSummaryFrom from;
  final OrderDetailsResponseRequestSummaryRequestedBy requestedBy;
  final PrioritiesStrategy priority;
  final String requestDate;
  final String? justification;
  final RequestsOrderStatusStrategy status;
  final CancelReasonInOrderResponse? reasonForRejected;

  OrderDetailsResponseRequestSummary({
    required this.id,
    required this.requestNo,
    required this.type,
    required this.from,
    required this.requestedBy,
    required this.priority,
    required this.requestDate,
    this.justification,
    required this.status,
    this.reasonForRejected,
  });

  factory OrderDetailsResponseRequestSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderDetailsResponseRequestSummary(
      id: json['id'] as String,
      requestNo: json['request_no'] as String,
      type: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['type'] as String),
      ),
      from: OrderDetailsResponseRequestSummaryFrom.fromJson(
        json['from'] as Map<String, dynamic>,
      ),
      requestedBy: OrderDetailsResponseRequestSummaryRequestedBy.fromJson(
        json['requested_by'] as Map<String, dynamic>,
      ),
      priority: PriorityType.getPriorityStrategy(
        PriorityType.fromValue(json['priority'] as String),
      ),
      requestDate: json['request_date'] as String,
      justification: json['justification'] as String?,
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      reasonForRejected: json['reason_for_rejected'] != null
          ? CancelReasonInOrderResponse.fromJson(
              json['reason_for_rejected'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class OrderDetailsResponseRequestSummaryFrom {
  final String id;
  final String name;

  OrderDetailsResponseRequestSummaryFrom({
    required this.id,
    required this.name,
  });

  factory OrderDetailsResponseRequestSummaryFrom.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderDetailsResponseRequestSummaryFrom(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class OrderDetailsResponseRequestSummaryRequestedBy {
  final String id;
  final String name;

  OrderDetailsResponseRequestSummaryRequestedBy({
    required this.id,
    required this.name,
  });

  factory OrderDetailsResponseRequestSummaryRequestedBy.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderDetailsResponseRequestSummaryRequestedBy(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class OrderDetailsResponseProductDetails {
  final String itemName;
  final int requestedQty;
  final String availableInBranchName;
  final int availableInQuantity;
  final num balanceAfter;
  final String qualityGrade;
  final String expiryDate;
  final bool coolingStatus;
  final String itemUnit;

  OrderDetailsResponseProductDetails({
    required this.itemName,
    required this.requestedQty,
    required this.availableInBranchName,
    required this.availableInQuantity,
    required this.balanceAfter,
    required this.qualityGrade,
    required this.expiryDate,
    required this.coolingStatus,
    required this.itemUnit,
  });

  factory OrderDetailsResponseProductDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderDetailsResponseProductDetails(
      itemName: json['item_name'] as String,
      requestedQty: (json['requested_qty'] as num).toInt(),
      availableInBranchName: json['available_in_branch_name'] as String,
      availableInQuantity: (json['available_in_quantity'] as num).toInt(),
      balanceAfter: json['balance_after'] as num,
      qualityGrade: json['quality_grade'] as String,
      expiryDate: json['expiry_date'] as String,
      coolingStatus: json['cooling_status'] as bool,
      itemUnit: json['item_unit'] as String,
    );
  }
}
