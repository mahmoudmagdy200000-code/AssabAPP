import 'package:assab/core/enums/order_modification_enum.dart';
import 'package:assab/core/enums/purchasing_officer_quality_enum.dart';
import 'package:assab/core/enums/requests_order_status_enum.dart';

import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../domain/strategies/supplier_order_modification_strategy.dart';

abstract class SupplierOrderModificationResponse {
  final SupplierOrderModificationStrategy type;
  final RequestsOrderStatusStrategy status;
  final CancelReasonInOrderResponse? cancellation;
  final SupplierOrderModificationModifiedTotal? modifiedTotal;
  final String modifiedAt;
  final String modificationNotes;

  const SupplierOrderModificationResponse({
    required this.type,
    required this.modifiedAt,
    required this.modificationNotes,
    required this.status,
    this.cancellation,
    this.modifiedTotal,
  });

  factory SupplierOrderModificationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final typeEnum = OrderModificationEnum.fromValue(
      json['data']['type'] as String,
    );

    final strategy = OrderModificationEnum.getSupplierStrategy(typeEnum);
    final modificationNotes =
        json['data']['modification_notes'] as String? ?? '';
    final modifiedAt = json['data']['modified_at'] as String;
    final status = RequestsOrderStatusEnum.getStatusStrategy(
      RequestsOrderStatusEnum.fromString(json['data']['status'] as String),
    );
    final cancellation = json['data']['cancellation'] != null
        ? CancelReasonInOrderResponse.fromJson(
            json['data']['cancellation'] as Map<String, dynamic>,
          )
        : null;
    final modifiedTotal = json['data']['modified_total'] != null
        ? SupplierOrderModificationModifiedTotal.fromJson(
            json['data']['modified_total'] as Map<String, dynamic>,
          )
        : null;

    switch (typeEnum) {
      case OrderModificationEnum.newQuantity:
        return SupplierOrderModificationNewQuantityResponse.fromJson(
          json,
          strategy,
          modifiedAt,
          modificationNotes,
          status,
          cancellation,
          modifiedTotal,
        );
      case OrderModificationEnum.newTime:
        return SupplierOrderModificationNewTimeResponse.fromJson(
          json,
          strategy,
          modifiedAt,
          modificationNotes,
          status,
          cancellation,
          modifiedTotal,
        );
      case OrderModificationEnum.newItem:
        return SupplierOrderModificationNewItemResponse.fromJson(
          json,
          strategy,
          modifiedAt,
          modificationNotes,
          status,
          cancellation,
          modifiedTotal,
        );
    }
  }
}

class SupplierOrderModificationModifiedTotal {
  final double originalTotal;
  final double modifiedTotal;
  final double difference;

  SupplierOrderModificationModifiedTotal({
    required this.originalTotal,
    required this.modifiedTotal,
    required this.difference,
  });

  factory SupplierOrderModificationModifiedTotal.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierOrderModificationModifiedTotal(
      originalTotal: (json['original_total'] as num).toDouble(),
      modifiedTotal: (json['modified_total'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble(),
    );
  }
}

class SupplierOrderModificationNewQuantityResponse
    extends SupplierOrderModificationResponse {
  final SupplierOrderModificationNewQuantityOriginalOrder originalOrder;
  final SupplierOrderModificationNewQuantitySupplierProposal supplierProposal;

  SupplierOrderModificationNewQuantityResponse({
    required super.type,
    required super.modifiedAt,
    required super.modificationNotes,
    required super.status,
    required super.cancellation,
    required super.modifiedTotal,
    required this.originalOrder,
    required this.supplierProposal,
  });

  factory SupplierOrderModificationNewQuantityResponse.fromJson(
    Map<String, dynamic> json,
    SupplierOrderModificationStrategy type,
    String modifiedAt,
    String modificationNotes,
    RequestsOrderStatusStrategy status,
    CancelReasonInOrderResponse? cancellation,
    SupplierOrderModificationModifiedTotal? modifiedTotal,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return SupplierOrderModificationNewQuantityResponse(
      type: type,
      modifiedAt: modifiedAt,
      modificationNotes: modificationNotes,
      originalOrder: SupplierOrderModificationNewQuantityOriginalOrder.fromJson(
        data['original_order'] as Map<String, dynamic>,
      ),
      supplierProposal:
          SupplierOrderModificationNewQuantitySupplierProposal.fromJson(
            data['supplier_proposal'] as Map<String, dynamic>,
          ),
      status: status,
      cancellation: cancellation,
      modifiedTotal: modifiedTotal,
    );
  }
}

class SupplierOrderModificationNewQuantityOriginalOrder {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int requestedQty;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;

  SupplierOrderModificationNewQuantityOriginalOrder({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.requestedQty,
    required this.unit,
    required this.quality,
    required this.price,
    required this.totalPrice,
  });

  factory SupplierOrderModificationNewQuantityOriginalOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierOrderModificationNewQuantityOriginalOrder(
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      requestedQty: json['requested_qty'] as int,
      unit: json['unit'] as String,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}

class SupplierOrderModificationNewQuantitySupplierProposal {
  final int proposedQty;
  final int shortage;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;

  SupplierOrderModificationNewQuantitySupplierProposal({
    required this.proposedQty,
    required this.shortage,
    required this.quality,
    required this.price,
    required this.totalPrice,
  });

  factory SupplierOrderModificationNewQuantitySupplierProposal.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierOrderModificationNewQuantitySupplierProposal(
      proposedQty: json['proposed_qty'] as int,
      shortage: json['shortage'] as int,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}

class SupplierOrderModificationNewTimeResponse
    extends SupplierOrderModificationResponse {
  final SupplierOrderModificationNewTimeOriginalOrder originalOrder;
  final SupplierOrderModificationNewTimeSupplierProposal supplierProposal;

  SupplierOrderModificationNewTimeResponse({
    required super.type,
    required super.modifiedAt,
    required super.modificationNotes,
    required super.status,
    required super.cancellation,
    required super.modifiedTotal,
    required this.originalOrder,
    required this.supplierProposal,
  });

  factory SupplierOrderModificationNewTimeResponse.fromJson(
    Map<String, dynamic> json,
    SupplierOrderModificationStrategy type,
    String modifiedAt,
    String modificationNotes,
    RequestsOrderStatusStrategy status,
    CancelReasonInOrderResponse? cancellation,
    SupplierOrderModificationModifiedTotal? modifiedTotal,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return SupplierOrderModificationNewTimeResponse(
      type: type,
      modifiedAt: modifiedAt,
      modificationNotes: modificationNotes,
      originalOrder: SupplierOrderModificationNewTimeOriginalOrder.fromJson(
        data['original_order'] as Map<String, dynamic>,
      ),
      supplierProposal:
          SupplierOrderModificationNewTimeSupplierProposal.fromJson(
            data['supplier_proposal'] as Map<String, dynamic>,
          ),
      status: status,
      cancellation: cancellation,
      modifiedTotal: modifiedTotal,
    );
  }
}

class SupplierOrderModificationNewTimeOriginalOrder {
  final String id;
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int requestedQty;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;
  final String? deliveryDate;

  SupplierOrderModificationNewTimeOriginalOrder({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.requestedQty,
    required this.unit,
    required this.quality,
    required this.price,
    required this.totalPrice,
    required this.deliveryDate,
  });

  factory SupplierOrderModificationNewTimeOriginalOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierOrderModificationNewTimeOriginalOrder(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      requestedQty: json['requested_qty'] as int,
      unit: json['unit'] as String,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      deliveryDate: json['delivery_date'] as String?,
    );
  }
}

class SupplierOrderModificationNewTimeSupplierProposal {
  final String qtyToDeliver;
  final bool isFull;
  final String newDeliveryDate;
  final int daysDifference;
  final String? daysDifferenceLabel;

  SupplierOrderModificationNewTimeSupplierProposal({
    required this.qtyToDeliver,
    required this.isFull,
    required this.newDeliveryDate,
    required this.daysDifference,
    required this.daysDifferenceLabel,
  });

  factory SupplierOrderModificationNewTimeSupplierProposal.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['delivery_details'] as Map<String, dynamic>;

    return SupplierOrderModificationNewTimeSupplierProposal(
      qtyToDeliver: data['qty_to_deliver'] as String,
      isFull: data['is_full'] as bool,
      newDeliveryDate: data['new_delivery_date'] as String,
      daysDifference: data['days_difference'] as int,
      daysDifferenceLabel: data['days_difference_label'] as String?,
    );
  }
}

class SupplierOrderModificationNewItemResponse
    extends SupplierOrderModificationResponse {
  final SupplierOrderModificationNewItemOriginalOrder originalOrder;
  final SupplierOrderModificationNewItemSupplierProposal supplierProposal;

  SupplierOrderModificationNewItemResponse({
    required super.type,
    required super.modifiedAt,
    required super.modificationNotes,
    required super.status,
    required super.cancellation,
    required super.modifiedTotal,
    required this.originalOrder,
    required this.supplierProposal,
  });

  factory SupplierOrderModificationNewItemResponse.fromJson(
    Map<String, dynamic> json,
    final SupplierOrderModificationStrategy type,
    String modifiedAt,
    String modificationNotes,
    RequestsOrderStatusStrategy status,
    CancelReasonInOrderResponse? cancellation,
    SupplierOrderModificationModifiedTotal? modifiedTotal,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return SupplierOrderModificationNewItemResponse(
      type: type,
      modifiedAt: modifiedAt,
      modificationNotes: modificationNotes,
      originalOrder: SupplierOrderModificationNewItemOriginalOrder.fromJson(
        data['original_order'] as Map<String, dynamic>,
      ),
      supplierProposal:
          SupplierOrderModificationNewItemSupplierProposal.fromJson(
            data['supplier_proposal'] as Map<String, dynamic>,
          ),
      status: status,
      cancellation: cancellation,
      modifiedTotal: modifiedTotal,
    );
  }
}

class SupplierOrderModificationNewItemOriginalOrder {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int requestedQty;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;

  SupplierOrderModificationNewItemOriginalOrder({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.requestedQty,
    required this.unit,
    required this.quality,
    required this.price,
    required this.totalPrice,
  });

  factory SupplierOrderModificationNewItemOriginalOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierOrderModificationNewItemOriginalOrder(
      itemId: json['item_id'] as String,
      itemName: json['item_name'] as String,
      itemLogo: json['item_logo'] as String?,
      requestedQty: json['requested_qty'] as int,
      unit: json['unit'] as String,
      quality: PurchasingOfficerQualityEnum.fromString(
        json['quality'] as String,
      ),
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}

class SupplierOrderModificationNewItemSupplierProposal {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int proposedQty;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final String pricePerUnit;
  final double totalPrice;

  SupplierOrderModificationNewItemSupplierProposal({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.proposedQty,
    required this.quality,
    required this.price,
    required this.pricePerUnit,
    required this.totalPrice,
  });

  factory SupplierOrderModificationNewItemSupplierProposal.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['alternative_product'] as Map<String, dynamic>;

    return SupplierOrderModificationNewItemSupplierProposal(
      itemId: data['item_id'] as String,
      itemName: data['item_name'] as String,
      itemLogo: data['item_logo'] as String?,
      proposedQty: data['proposed_qty'] as int,
      quality: PurchasingOfficerQualityEnum.fromString(
        data['quality'] as String,
      ),
      price: (data['price'] as num).toDouble(),
      pricePerUnit: data['price_per_unit'] as String,
      totalPrice: (data['total_price'] as num).toDouble(),
    );
  }
}
