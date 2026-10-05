import 'package:assab/core/enums/order_modification_enum.dart';
import 'package:assab/core/enums/purchasing_officer_quality_enum.dart';
import 'package:assab/core/enums/requests_order_status_enum.dart';

import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../domain/strategies/branch_order_modification_strategy.dart';

abstract class BranchOrderModificationResponse {
  final BranchOrderModificationStrategy type;
  final RequestsOrderStatusStrategy status;
  final CancelReasonInOrderResponse? cancellation;
  final String modifiedAt;
  final String modificationNotes;

  final BranchOrderModificationModifiedTotal? modifiedTotal;

  const BranchOrderModificationResponse({
    required this.type,
    required this.modifiedAt,
    required this.modificationNotes,
    required this.status,
    this.cancellation,
    this.modifiedTotal,
  });

  factory BranchOrderModificationResponse.fromJson(Map<String, dynamic> json) {
    final typeEnum = OrderModificationEnum.fromValue(
      json['data']['type'] as String,
    );
    final modificationNotes =
        json['data']['modification_notes'] as String? ?? '';
    final modifiedAt = json['data']['modified_at'] as String;

    final strategy = OrderModificationEnum.getBranchStrategy(typeEnum);
    final status = RequestsOrderStatusEnum.getStatusStrategy(
      RequestsOrderStatusEnum.fromString(json['data']['status'] as String),
    );
    final cancellation = json['data']['cancellation'] != null
        ? CancelReasonInOrderResponse.fromJson(
            json['data']['cancellation'] as Map<String, dynamic>,
          )
        : null;
    final modifiedTotal = json['data']['modified_total'] != null
        ? BranchOrderModificationModifiedTotal.fromJson(
            json['data']['modified_total'] as Map<String, dynamic>,
          )
        : null;

    switch (typeEnum) {
      case OrderModificationEnum.newQuantity:
        return BranchOrderModificationNewQuantityResponse.fromJson(
          json,
          strategy,
          modifiedAt,
          modificationNotes,
          status,
          cancellation,
          modifiedTotal,
        );
      case OrderModificationEnum.newTime:
        return BranchOrderModificationNewTimeResponse.fromJson(
          json,
          strategy,
          modifiedAt,
          modificationNotes,
          status,
          cancellation,
          modifiedTotal,
        );
      case OrderModificationEnum.newItem:
        return BranchOrderModificationNewItemResponse.fromJson(
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

class BranchOrderModificationModifiedTotal {
  final double originalTotal;
  final double modifiedTotal;
  final double difference;

  BranchOrderModificationModifiedTotal({
    required this.originalTotal,
    required this.modifiedTotal,
    required this.difference,
  });

  factory BranchOrderModificationModifiedTotal.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchOrderModificationModifiedTotal(
      originalTotal: (json['original_total'] as num).toDouble(),
      modifiedTotal: (json['modified_total'] as num).toDouble(),
      difference: (json['difference'] as num).toDouble(),
    );
  }
}

class BranchOrderModificationNewQuantityResponse
    extends BranchOrderModificationResponse {
  final BranchOrderModificationNewQuantityOriginalOrder originalOrder;
  final BranchOrderModificationNewQuantitySupplierProposal supplierProposal;

  BranchOrderModificationNewQuantityResponse({
    required super.type,
    required super.modifiedAt,
    required super.modificationNotes,
    required super.status,
    required super.cancellation,
    required super.modifiedTotal,
    required this.originalOrder,
    required this.supplierProposal,
  });

  factory BranchOrderModificationNewQuantityResponse.fromJson(
    Map<String, dynamic> json,
    BranchOrderModificationStrategy type,
    String modifiedAt,
    String modificationNotes,
    RequestsOrderStatusStrategy status,
    CancelReasonInOrderResponse? cancellation,
    BranchOrderModificationModifiedTotal? modifiedTotal,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BranchOrderModificationNewQuantityResponse(
      type: type,
      modifiedAt: modifiedAt,
      modificationNotes: modificationNotes,
      originalOrder: BranchOrderModificationNewQuantityOriginalOrder.fromJson(
        data['original_order'] as Map<String, dynamic>,
      ),
      supplierProposal:
          BranchOrderModificationNewQuantitySupplierProposal.fromJson(
            data['supplier_proposal'] as Map<String, dynamic>,
          ),
      status: status,
      cancellation: cancellation,
      modifiedTotal: modifiedTotal,
    );
  }
}

class BranchOrderModificationNewQuantityOriginalOrder {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int requestedQty;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;

  BranchOrderModificationNewQuantityOriginalOrder({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.requestedQty,
    required this.unit,
    required this.quality,
    required this.price,
    required this.totalPrice,
  });

  factory BranchOrderModificationNewQuantityOriginalOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchOrderModificationNewQuantityOriginalOrder(
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

class BranchOrderModificationNewQuantitySupplierProposal {
  final int proposedQty;
  final int shortage;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;

  BranchOrderModificationNewQuantitySupplierProposal({
    required this.proposedQty,
    required this.shortage,
    required this.quality,
    required this.price,
    required this.totalPrice,
  });

  factory BranchOrderModificationNewQuantitySupplierProposal.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchOrderModificationNewQuantitySupplierProposal(
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

class BranchOrderModificationNewTimeResponse
    extends BranchOrderModificationResponse {
  final BranchOrderModificationNewTimeOriginalOrder originalOrder;
  final BranchOrderModificationNewTimeSupplierProposal supplierProposal;

  BranchOrderModificationNewTimeResponse({
    required super.type,
    required super.modifiedAt,
    required super.modificationNotes,
    required super.status,
    required super.cancellation,
    required super.modifiedTotal,
    required this.originalOrder,
    required this.supplierProposal,
  });

  factory BranchOrderModificationNewTimeResponse.fromJson(
    Map<String, dynamic> json,
    BranchOrderModificationStrategy type,
    String modifiedAt,
    String modificationNotes,
    RequestsOrderStatusStrategy status,
    CancelReasonInOrderResponse? cancellation,
    BranchOrderModificationModifiedTotal? modifiedTotal,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BranchOrderModificationNewTimeResponse(
      type: type,
      modifiedAt: modifiedAt,
      modificationNotes: modificationNotes,
      originalOrder: BranchOrderModificationNewTimeOriginalOrder.fromJson(
        data['original_order'] as Map<String, dynamic>,
      ),
      supplierProposal: BranchOrderModificationNewTimeSupplierProposal.fromJson(
        data['supplier_proposal'] as Map<String, dynamic>,
      ),
      status: status,
      cancellation: cancellation,
      modifiedTotal: modifiedTotal,
    );
  }
}

class BranchOrderModificationNewTimeOriginalOrder {
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

  BranchOrderModificationNewTimeOriginalOrder({
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

  factory BranchOrderModificationNewTimeOriginalOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchOrderModificationNewTimeOriginalOrder(
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

class BranchOrderModificationNewTimeSupplierProposal {
  final String qtyToDeliver;
  final bool isFull;
  final String newDeliveryDate;
  final int daysDifference;
  final String? daysDifferenceLabel;

  BranchOrderModificationNewTimeSupplierProposal({
    required this.qtyToDeliver,
    required this.isFull,
    required this.newDeliveryDate,
    required this.daysDifference,
    required this.daysDifferenceLabel,
  });

  factory BranchOrderModificationNewTimeSupplierProposal.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['delivery_details'] as Map<String, dynamic>;

    return BranchOrderModificationNewTimeSupplierProposal(
      qtyToDeliver: data['qty_to_deliver'] as String,
      isFull: data['is_full'] as bool,
      newDeliveryDate: data['new_delivery_date'] as String,
      daysDifference: data['days_difference'] as int,
      daysDifferenceLabel: data['days_difference_label'] as String?,
    );
  }
}

class BranchOrderModificationNewItemResponse
    extends BranchOrderModificationResponse {
  final BranchOrderModificationNewItemOriginalOrder originalOrder;
  final BranchOrderModificationNewItemSupplierProposal supplierProposal;

  BranchOrderModificationNewItemResponse({
    required super.type,
    required super.modifiedAt,
    required super.modificationNotes,
    required super.status,
    required super.cancellation,
    required super.modifiedTotal,
    required this.originalOrder,
    required this.supplierProposal,
  });

  factory BranchOrderModificationNewItemResponse.fromJson(
    Map<String, dynamic> json,
    BranchOrderModificationStrategy type,
    String modifiedAt,
    String modificationNotes,
    RequestsOrderStatusStrategy status,
    CancelReasonInOrderResponse? cancellation,
    BranchOrderModificationModifiedTotal? modifiedTotal,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BranchOrderModificationNewItemResponse(
      type: type,
      modifiedAt: modifiedAt,
      modificationNotes: modificationNotes,
      originalOrder: BranchOrderModificationNewItemOriginalOrder.fromJson(
        data['original_order'] as Map<String, dynamic>,
      ),
      supplierProposal: BranchOrderModificationNewItemSupplierProposal.fromJson(
        data['supplier_proposal'] as Map<String, dynamic>,
      ),
      status: status,
      cancellation: cancellation,
      modifiedTotal: modifiedTotal,
    );
  }
}

class BranchOrderModificationNewItemOriginalOrder {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int requestedQty;
  final String unit;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final double totalPrice;

  BranchOrderModificationNewItemOriginalOrder({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.requestedQty,
    required this.unit,
    required this.quality,
    required this.price,
    required this.totalPrice,
  });

  factory BranchOrderModificationNewItemOriginalOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchOrderModificationNewItemOriginalOrder(
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

class BranchOrderModificationNewItemSupplierProposal {
  final String itemId;
  final String itemName;
  final String? itemLogo;
  final int proposedQty;
  final PurchasingOfficerQualityEnum quality;
  final double price;
  final String pricePerUnit;
  final double totalPrice;

  BranchOrderModificationNewItemSupplierProposal({
    required this.itemId,
    required this.itemName,
    required this.itemLogo,
    required this.proposedQty,
    required this.quality,
    required this.price,
    required this.pricePerUnit,
    required this.totalPrice,
  });

  factory BranchOrderModificationNewItemSupplierProposal.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['alternative_product'] as Map<String, dynamic>;

    return BranchOrderModificationNewItemSupplierProposal(
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
