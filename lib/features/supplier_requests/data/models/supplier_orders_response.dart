import 'package:assab/core/enums/priority_type.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/enums/purchasing_officer_quality_enum.dart';
import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/strategies/priorities_strategy.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../shared/models/branch_details_response.dart';
import '../../../../shared/models/branch_manager_details_response.dart';

part 'supplier_orders_response.g.dart';

@JsonSerializable(createToJson: false)
class SupplierOrdersResponse {
  final List<SupplierOrder> data;
  final MetaModel meta;

  SupplierOrdersResponse({required this.data, required this.meta});

  factory SupplierOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$SupplierOrdersResponseFromJson(json);
}

class SupplierOrder {
  final String id;
  final String orderNumber;
  final PurchaseSourceStrategy orderType;
  final RequestsOrderStatusStrategy status;
  final BranchDetailsResponse branch;
  final BranchManagerDetailsResponse branchManager;
  final List<SupplierOrderItem> items;
  final num subtotal;
  final num taxAmount;
  final num totalAmount;
  final PrioritiesStrategy priority;
  final DateTime? preferredDeliveryDate;
  final DateTime? expectedDeliveryAt;
  final String? message;
  final String? specialInstructions;
  final String? rejectionReason;
  final String createdAt;
  final DateTime? confirmedAt;
  final DateTime? rejectedAt;
  final String requiredDelivery;

  SupplierOrder({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.status,
    required this.branch,
    required this.branchManager,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.priority,
    this.preferredDeliveryDate,
    this.expectedDeliveryAt,
    this.message,
    this.specialInstructions,
    this.rejectionReason,
    required this.createdAt,
    this.confirmedAt,
    this.rejectedAt,
    required this.requiredDelivery,
  });

  factory SupplierOrder.fromJson(Map<String, dynamic> json) {
    return SupplierOrder(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      orderType: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['order_type'] as String),
      ),
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      branch: BranchDetailsResponse.fromJson(
        json['branch'] as Map<String, dynamic>,
      ),
      branchManager: BranchManagerDetailsResponse.fromJson(
        json['branch_manager'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => SupplierOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'] as num,
      taxAmount: json['tax_amount'] as num,
      totalAmount: json['total_amount'] as num,
      priority: PriorityType.getPriorityStrategy(
        PriorityType.fromValue(json['priority'] as String),
      ),
      preferredDeliveryDate: json['preferred_delivery_date'] != null
          ? DateTime.parse(json['preferred_delivery_date'] as String)
          : null,
      expectedDeliveryAt: json['expected_delivery_at'] != null
          ? DateTime.parse(json['expected_delivery_at'] as String)
          : null,
      message: json['message'] as String?,
      specialInstructions: json['special_instructions'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: json['created_at'] as String,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.tryParse(json['confirmed_at'] as String)
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.tryParse(json['rejected_at'] as String)
          : null,
      requiredDelivery: json['expected_delivery_at'] as String? ?? '',
    );
  }
}

class SupplierOrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productUnit;
  final num orderedQuantity;
  final num quantityConfirmed;
  final num unitPrice;
  final num totalPrice;
  final PurchasingOfficerQualityEnum qualityLevel;
  final RequestsOrderStatusStrategy status;

  SupplierOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productUnit,
    required this.orderedQuantity,
    required this.quantityConfirmed,
    required this.unitPrice,
    required this.totalPrice,
    required this.qualityLevel,
    required this.status,
  });

  factory SupplierOrderItem.fromJson(Map<String, dynamic> json) {
    return SupplierOrderItem(
      id: json['id'] as String,
      productId: json['item_id'] as String,
      productName: json['item_name'] as String,
      orderedQuantity: json['quantity_ordered'] as num,
      quantityConfirmed: (json['quantity_confirmed'] as num?) ?? 0,
      productUnit: json['item_unit'] as String,
      unitPrice: json['unit_price'] as num,
      totalPrice: json['total_price'] as num,
      qualityLevel: PurchasingOfficerQualityEnum.fromString(
        json['quality_level'] as String? ?? '-',
      ),
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
    );
  }
}
