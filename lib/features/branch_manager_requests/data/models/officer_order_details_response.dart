import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';

class OfficerOrderDetailsResponse {
  final OfficerOrderDetailsRequestSummary requestSummary;
  final List<OfficerOrderDetailsProductDetail> productDetails;
  final TimeLineResponse timelines;

  OfficerOrderDetailsResponse({
    required this.requestSummary,
    required this.productDetails,
    required this.timelines,
  });

  factory OfficerOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return OfficerOrderDetailsResponse(
      requestSummary: OfficerOrderDetailsRequestSummary.fromJson(
        data['request_summary'] as Map<String, dynamic>,
      ),
      productDetails: (data['product_details'] as List)
          .map(
            (e) => OfficerOrderDetailsProductDetail.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      timelines: TimeLineResponse.fromJson(data),
    );
  }
}

class OfficerOrderDetailsRequestSummary {
  final String id;
  final RequestsOrderStatusStrategy status;
  final String orderNumber;
  final OfficerOrderDetailsBranch from;
  final String type;
  final String requestedBy;
  final String requestedDate;
  final double totalPrice;

  OfficerOrderDetailsRequestSummary({
    required this.id,
    required this.status,
    required this.orderNumber,
    required this.from,
    required this.type,
    required this.requestedBy,
    required this.requestedDate,
    required this.totalPrice,
  });

  factory OfficerOrderDetailsRequestSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return OfficerOrderDetailsRequestSummary(
      id: json['id'] as String,
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      orderNumber: json['order_number'] as String,
      from: OfficerOrderDetailsBranch.fromJson(
        json['from'] as Map<String, dynamic>,
      ),
      type: json['type'] as String,
      requestedBy: json['requested_by'] as String,
      requestedDate: json['requested_date'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'order_number': orderNumber,
      'from': from.toJson(),
      'type': type,
      'requested_by': requestedBy,
      'requested_date': requestedDate,
      'total_price': totalPrice,
    };
  }
}

class OfficerOrderDetailsBranch {
  final String branchName;
  final String branchLocation;

  OfficerOrderDetailsBranch({
    required this.branchName,
    required this.branchLocation,
  });

  factory OfficerOrderDetailsBranch.fromJson(Map<String, dynamic> json) {
    return OfficerOrderDetailsBranch(
      branchName: json['branch_name'] as String,
      branchLocation: json['branch_location'] as String? ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {'branch_name': branchName, 'branch_location': branchLocation};
  }
}

class OfficerOrderDetailsProductDetail {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final double itemPrice;
  final String itemUnit;
  final int requestedQty;
  final String quality;
  final String preferredDeliveryDate;
  final String latestDeliveryDate;
  final String? specialInstructions;
  final OfficerOrderDetailsPriceComparison priceComparison;

  OfficerOrderDetailsProductDetail({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.itemPrice,
    required this.itemUnit,
    required this.requestedQty,
    required this.quality,
    required this.preferredDeliveryDate,
    required this.latestDeliveryDate,
    required this.specialInstructions,
    required this.priceComparison,
  });

  factory OfficerOrderDetailsProductDetail.fromJson(Map<String, dynamic> json) {
    return OfficerOrderDetailsProductDetail(
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      itemPrice: (json['item_price'] as num).toDouble(),
      itemUnit: json['item_unit'] as String,
      requestedQty: json['requested_qty'] as int,
      quality: json['quality'] as String,
      preferredDeliveryDate: json['preferred_delivery_date'] as String,
      latestDeliveryDate: json['latest_delivery_date'] as String,
      specialInstructions: json['special_instructions'] as String?,
      priceComparison: OfficerOrderDetailsPriceComparison.fromJson(
        json['price_comparison'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_name': itemName,
      'item_logo': itemLogo,
      'item_price': itemPrice,
      'requested_qty': requestedQty,
      'quality': quality,
      'preferred_delivery_date': preferredDeliveryDate,
      'latest_delivery_date': latestDeliveryDate,
      'special_instructions': specialInstructions,
      'price_comparison': priceComparison.toJson(),
    };
  }
}

class OfficerOrderDetailsPriceComparison {
  final double directSupplierPriceSameItem;
  final double viaPurchasingOfficerSameItem;
  final String savingAmount;

  OfficerOrderDetailsPriceComparison({
    required this.directSupplierPriceSameItem,
    required this.viaPurchasingOfficerSameItem,
    required this.savingAmount,
  });

  factory OfficerOrderDetailsPriceComparison.fromJson(
    Map<String, dynamic> json,
  ) {
    return OfficerOrderDetailsPriceComparison(
      directSupplierPriceSameItem:
          (json['direct_supplier_price_same_item'] as num).toDouble(),
      viaPurchasingOfficerSameItem:
          (json['VIA_PURCHASING_OFFICER_same_item'] as num).toDouble(),
      savingAmount: json['saving_amount'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direct_supplier_price_same_item': directSupplierPriceSameItem,
      'VIA_PURCHASING_OFFICER_same_item': viaPurchasingOfficerSameItem,
      'saving_amount': savingAmount,
    };
  }
}
