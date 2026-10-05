import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/draft_order_data.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../presentation/cubit/add_item_purchase/add_item_purchase_cubit.dart';
import '../../presentation/cubit/create_purchase_order/create_purchase_order_cubit.dart';

abstract class CreateOrderStrategy {
  /// The step index to start from when the screen opens.
  int get initialStepIndex => 0;

  void getDetails(BuildContext context) {}

  /// Called when API items are loaded in step 0 (Choose Items).
  /// Override to reconcile draft items with API items.
  void onItemsLoaded(
    BuildContext context,
    List<PurchaseBranchItemData> items,
  ) {}

  Widget buildButtons(
    BuildContext context,
    PurchaseCreateOrderRequest request,
  ) {
    return const SizedBox.shrink();
  }
}

class CreateNewOrderCreateOrderStrategy extends CreateOrderStrategy {
  @override
  Widget buildButtons(
    BuildContext context,
    PurchaseCreateOrderRequest request,
  ) {
    final validationState = context.watch<ValidationCubit>().state;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            onClick: () {
              request.updateIsDraft(true);

              context.read<CreatePurchaseOrderCubit>().createPurchaseOrder(
                request: request,
              );
            },
            text: context.tr.saveToDraft,
            isTransparent: validationState.enableButton,
            textColor: context.customColor.text3,
            enabled: validationState.enableButton,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: AppButton(
            onClick: () {
              request.updateIsDraft(false);

              context.read<CreatePurchaseOrderCubit>().createPurchaseOrder(
                request: request,
              );
            },
            text: context.tr.submitOrder,
            enabled: validationState.enableButton,
          ),
        ),
      ],
    );
  }
}

class UpdateDraftOrderCreateOrderStrategy extends CreateOrderStrategy {
  final DraftOrderData draftData;

  UpdateDraftOrderCreateOrderStrategy({required this.draftData});

  @override
  int get initialStepIndex => 1;

  @override
  void getDetails(BuildContext context) {
    super.getDetails(context);

    // Jump to the "Choose Source" step (step 1).
    // Data population happens in populateDraftItems() called from
    // NewPurchaseOrderScreen when the step 1 cubits are available.
    context.read<PagingCubit>().goToStep(initialStepIndex);
  }

  /// Populates [AddItemPurchaseCubit], [AddItemCubit], and [ValidationCubit]
  /// with the draft order data. Must be called from a context where all
  /// three cubits are available (i.e., within step 1's widget tree).
  void populateDraftItems(BuildContext context) {
    final addItemPurchaseCubit = context.read<AddItemPurchaseCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final validationCubit = context.read<ValidationCubit>();

    // 1. Populate AddItemPurchaseCubit with draft items and their quantities.
    for (final draftItem in draftData.items) {
      final purchaseItem = draftItem.toPurchaseBranchItemData();

      // Set the item with its requested quantity.
      addItemPurchaseCubit.addItem(purchaseItem);
      for (int i = 1; i < draftItem.requestedQty; i++) {
        addItemPurchaseCubit.addItem(purchaseItem);
      }

      // 2. Add a corresponding row ID in AddItemCubit.
      addItemCubit.addItem('purchaseItems');
    }

    // 3. Populate ValidationCubit with source data for each item row.
    final purchaseItemIds = addItemCubit.state.lists['purchaseItems'] ?? [];

    for (
      int i = 0;
      i < purchaseItemIds.length && i < draftData.items.length;
      i++
    ) {
      final rowId = purchaseItemIds[i];
      final draftItem = draftData.items[i];

      // Store the requested quantity.
      validationCubit.validateFieldAndStoreValue(
        fieldName: 'requested_qty_$rowId',
        value: draftItem.requestedQty.toString(),
        isValid: true,
      );

      // Store the source type.
      validationCubit.validateFieldAndStoreValue(
        fieldName: 'sourceType_$rowId',
        value: draftData.sourceType.toString(),
        isValid: true,
      );

      // Store the source ID.
      validationCubit.validateFieldAndStoreValue(
        fieldName: 'source_id_$rowId',
        value: draftData.sourceId,
        isValid: true,
      );

      // Store the source name.
      validationCubit.validateFieldAndStoreValue(
        fieldName: 'source_name_$rowId',
        value: draftData.sourceName,
        isValid: true,
      );

      // Store the chosen item source ID.
      // Must use itemId (the actual item_id), matching what the normal flow
      // stores — the summary screen filters by this value against API itemId.
      validationCubit.validateFieldAndStoreValue(
        fieldName: 'choosed_item_source_id_$rowId',
        value: draftItem.itemId ?? '',
        isValid: true,
      );
    }

    // Mark the items validation as valid since items are pre-populated.
    validationCubit.validateField('items', true);
  }

  bool _hasReconciledItems = false;

  /// Swaps draft-created item keys with API-fetched items in a single emit.
  /// This preserves step 1's row IDs and validation data because the item
  /// count stays the same — [_handleListener] sees no length change and
  /// does not add/remove rows.
  @override
  void onItemsLoaded(
    BuildContext context,
    List<PurchaseBranchItemData> apiItems,
  ) {
    if (_hasReconciledItems) return;
    _hasReconciledItems = true;

    final addItemPurchaseCubit = context.read<AddItemPurchaseCubit>();
    final newItems = <PurchaseBranchItemData, int>{};

    for (final entry in addItemPurchaseCubit.state.items.entries) {
      final draftItem = draftData.items.cast<DraftOrderItem?>().firstWhere(
        (d) => d!.toPurchaseBranchItemData() == entry.key,
        orElse: () => null,
      );

      if (draftItem == null) {
        // Keep items that weren't from the draft.
        newItems[entry.key] = entry.value;
        continue;
      }

      final apiItem = apiItems.cast<PurchaseBranchItemData?>().firstWhere(
        (item) => _matchesDraftItem(draftItem, item!),
        orElse: () => null,
      );

      // Replace draft key with API key, preserving quantity.
      newItems[apiItem ?? entry.key] = entry.value;
    }

    addItemPurchaseCubit.replaceItems(newItems);

    // Validate the 'items' field on step 0's ValidationCubit so the
    // "Choose Sources" button is enabled for pre-filled draft items.
    context.read<ValidationCubit>().validateField(
      'items',
      addItemPurchaseCubit.anyItemsSelected(),
    );
  }

  /// Matches a [DraftOrderItem] to an API-fetched [PurchaseBranchItemData]
  /// by item ID (if available) or by item name as fallback.
  bool _matchesDraftItem(
    DraftOrderItem draftItem,
    PurchaseBranchItemData apiItem,
  ) {
    if (draftItem.itemId != null && draftItem.itemId!.isNotEmpty) {
      return apiItem.itemId == draftItem.itemId;
    }
    return apiItem.itemName == draftItem.itemName;
  }

  @override
  Widget buildButtons(
    BuildContext context,
    PurchaseCreateOrderRequest request,
  ) {
    final validationState = context.watch<ValidationCubit>().state;

    return AppButton(
      onClick: () {
        request.updateIsDraft(false);

        context.read<CreatePurchaseOrderCubit>().submitDraft(
          id: draftData.orderId,
          request: request,
        );
      },
      text: context.tr.submitOrder,
      enabled: validationState.enableButton,
    );
  }
}
