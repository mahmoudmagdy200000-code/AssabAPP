import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:equatable/equatable.dart';

import '../../../branch_manager_requests/data/models/direct_supplier_order_details_response.dart';
import '../../../branch_manager_requests/data/models/officer_order_details_response.dart';
import '../../../branch_manager_requests/data/models/order_details_response.dart';
import 'purchase_branch_items_response.dart';

/// Unified model that holds the draft order data needed to pre-populate
/// the purchase flow when continuing to edit a draft.
class DraftOrderData extends Equatable {
  final String orderId;
  final PurchaseSourcesTypes sourceType;
  final String sourceId;
  final String sourceName;
  final List<DraftOrderItem> items;

  const DraftOrderData({
    required this.orderId,
    required this.sourceType,
    required this.sourceId,
    required this.sourceName,
    required this.items,
  });

  /// Creates [DraftOrderData] from a branch order details response.
  factory DraftOrderData.fromBranchDetails({
    required String orderId,
    required OrderDetailsResponse response,
  }) {
    final summary = response.data.requestSummary;

    return DraftOrderData(
      orderId: orderId,
      sourceType: PurchaseSourcesTypes.branch,
      sourceId: summary.from.id,
      sourceName: summary.from.name,
      items: response.data.productDetails
          .map(
            (p) => DraftOrderItem(
              itemName: p.itemName,
              requestedQty: p.requestedQty,
              itemUnit: p.itemUnit,
            ),
          )
          .toList(),
    );
  }

  /// Creates [DraftOrderData] from a direct supplier order details response.
  factory DraftOrderData.fromDirectSupplierDetails({
    required String orderId,
    required DirectSupplierOrderDetailsResponse response,
  }) {
    final summary = response.requestSummary;

    return DraftOrderData(
      orderId: orderId,
      sourceType: PurchaseSourcesTypes.supplier,
      sourceId: response.supplier.id,
      sourceName: summary.supplierName,
      items: response.productDetails
          .map(
            (p) => DraftOrderItem(
              itemId: p.itemId,
              choosedItemSourceId: p.id,
              itemName: p.itemName,
              requestedQty: p.requestedQty,
              itemPrice: p.itemPrice,
              itemUnit: p.itemUnit,
            ),
          )
          .toList(),
    );
  }

  /// Creates [DraftOrderData] from an officer order details response.
  factory DraftOrderData.fromOfficerDetails({
    required String orderId,
    required OfficerOrderDetailsResponse response,
  }) {
    final summary = response.requestSummary;

    return DraftOrderData(
      orderId: orderId,
      sourceType: PurchaseSourcesTypes.officer,
      sourceId: summary.id,
      sourceName: summary.from.branchName,
      items: response.productDetails
          .map(
            (p) => DraftOrderItem(
              itemId: p.itemId,
              itemName: p.itemName,
              itemLogo: p.itemLogo,
              requestedQty: p.requestedQty,
              itemPrice: p.itemPrice,
              itemUnit: p.itemUnit,
            ),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [orderId, sourceType, sourceId, sourceName, items];
}

/// Represents a single item from the draft order.
class DraftOrderItem extends Equatable {
  final String? itemId;
  final String? choosedItemSourceId;
  final String itemName;
  final int requestedQty;
  final double? itemPrice;
  final String? itemLogo;
  final String itemUnit;

  const DraftOrderItem({
    this.itemId,
    this.choosedItemSourceId,
    required this.itemName,
    required this.requestedQty,
    this.itemPrice,
    this.itemLogo,
    required this.itemUnit,
  });

  /// Converts draft item to [PurchaseBranchItemData] for [AddItemPurchaseCubit].
  PurchaseBranchItemData toPurchaseBranchItemData() {
    return PurchaseBranchItemData(
      id: choosedItemSourceId ?? itemId ?? '',
      itemId: itemId ?? '',
      itemName: itemName,
      itemTitle: itemName,
      itemCode: '',
      itemUnit: itemUnit,
      rate: 0,
      itemPrice: itemPrice ?? 0,
      itemQuantity: requestedQty,
      suppliersCount: null,
      unit: itemUnit,
      itemLogo: itemLogo,
    );
  }

  @override
  List<Object?> get props => [
    itemId,
    choosedItemSourceId,
    itemName,
    requestedQty,
    itemPrice,
    itemLogo,
    itemUnit,
  ];
}
