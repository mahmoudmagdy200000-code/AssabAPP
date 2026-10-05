import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/add_item/add_item_state.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/presentation/cubit/add_item_purchase/add_item_purchase_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/add_item_purchase/add_item_purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/purchasing_officer_quality_enum.dart';
import '../../../../core/enums/select_filter_item_type.dart';
import '../../data/models/source_local_model.dart';
import '../../domain/strategies/create_order_strategy.dart';
import '../cubit/create_purchase_order/create_purchase_order_cubit.dart';
import '../cubit/select_filter_item/select_filter_item_cubit.dart';
import '../cubit/select_filter_item/select_filter_item_state.dart';
import '../widgets/item_new_order_widget.dart';
import 'new_purchase_order_summary_screen.dart';

class NewPurchaseOrderScreen extends StatefulWidget {
  final CreateOrderStrategy strategy;

  const NewPurchaseOrderScreen({super.key, required this.strategy});

  @override
  State<NewPurchaseOrderScreen> createState() => _NewPurchaseOrderScreenState();
}

class _NewPurchaseOrderScreenState extends State<NewPurchaseOrderScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.strategy is UpdateDraftOrderCreateOrderStrategy) {
      (widget.strategy as UpdateDraftOrderCreateOrderStrategy)
          .populateDraftItems(context);
    }
  }

  CreateOrderStrategy get strategy => widget.strategy;

  /// Maps each row ID (from AddItemCubit) to the corresponding
  /// PurchaseBranchItemData.itemId so we can identify which row to
  /// remove when an item is deleted from any position in the map.
  final Map<String, String> _rowIdToItemId = {};

  void _syncDynamicValidationFields({
    required BuildContext context,
    required ValidationCubit validationCubit,
    required List<String> purchaseItems,
  }) {
    final dynamicFields = purchaseItems
        .expand(
          (id) => {
            'sourceType_$id',
            'source_id_$id',
            'choosed_item_source_id_$id',
            'source_name_$id',
          },
        )
        .toSet();

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('sourceType_') ||
              key.startsWith('source_id_') ||
              key.startsWith('choosed_item_source_id_') ||
              key.startsWith('source_name_'),
        )
        .toSet();

    final toRemove = existingDynamic.difference(dynamicFields);
    final toAdd = dynamicFields.difference(existingDynamic);

    if (toRemove.isNotEmpty) {
      validationCubit.removeDynamicFields(toRemove);
    }

    if (toAdd.isNotEmpty) {
      validationCubit.addDynamicFields(toAdd);
    }
  }

  void _handleListener(BuildContext context, AddItemPurchaseState state) {
    final addItemCubit = context.read<AddItemCubit>();
    final validationCubit = context.read<ValidationCubit>();

    final purchaseItems = addItemCubit.state.lists['purchaseItems'] ?? [];

    final itemsEntries = state.items.entries.toList();

    final currentLength = itemsEntries.length;
    final previousLength = purchaseItems.length;

    if (currentLength > previousLength) {
      addItemCubit.addItem('purchaseItems');

      final newRowId = addItemCubit.state.lists['purchaseItems']!.last;

      validationCubit.addDynamicFields({'requested_qty_$newRowId'});

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'requested_qty_$newRowId',
        value: '1',
        isValid: true,
      );

      _rowIdToItemId[newRowId] = itemsEntries.last.key.itemId;

      // Auto-populate source and quality when a supplier filter is active.
      final filterState = context.read<SelectFilterItemCubit>().state;
      if (filterState.selectedFilterType == SelectFilterItemType.supplier &&
          filterState.selectedId != null &&
          filterState.selectedName != null) {
        final newItem = itemsEntries.last.key;

        validationCubit.validateFieldAndStoreValue(
          fieldName: 'sourceType_$newRowId',
          value: PurchaseSourcesTypes.supplier.toString(),
          isValid: true,
        );

        validationCubit.validateFieldAndStoreValue(
          fieldName: 'source_id_$newRowId',
          value: filterState.selectedId!,
          isValid: true,
        );

        validationCubit.validateFieldAndStoreValue(
          fieldName: 'source_name_$newRowId',
          value: filterState.selectedName!,
          isValid: true,
        );

        validationCubit.validateFieldAndStoreValue(
          fieldName: 'choosed_item_source_id_$newRowId',
          value: newItem.itemId,
          isValid: true,
        );

        validationCubit.addDynamicFields({'quality_$newRowId'});
        validationCubit.validateFieldAndStoreValue(
          fieldName: 'quality_$newRowId',
          value: PurchasingOfficerQualityEnum.economy.toString(),
          isValid: true,
        );
      }
    }

    if (currentLength < previousLength && purchaseItems.isNotEmpty) {
      // Build the set of itemIds that are still present after removal.
      final currentItemIds = state.items.keys.map((k) => k.itemId).toSet();

      // Find the rowId whose mapped itemId is no longer present.
      bool removed = false;
      for (int i = purchaseItems.length - 1; i >= 0; i--) {
        final rowId = purchaseItems[i];
        final mappedItemId = _rowIdToItemId[rowId];
        if (mappedItemId != null && !currentItemIds.contains(mappedItemId)) {
          validationCubit.removeDynamicFields({
            'requested_qty_$rowId',
            'quality_$rowId',
          });
          addItemCubit.removeItem('purchaseItems', i);
          _rowIdToItemId.remove(rowId);
          removed = true;
          break;
        }
      }

      // Fallback for unmapped rows (e.g. first load before mapping is built).
      if (!removed) {
        final removedIndex = currentLength;
        if (removedIndex >= 0 && removedIndex < purchaseItems.length) {
          final removedRowId = purchaseItems[removedIndex];
          validationCubit.removeDynamicFields({
            'requested_qty_$removedRowId',
            'quality_$removedRowId',
          });
          addItemCubit.removeItem('purchaseItems', removedIndex);
          _rowIdToItemId.remove(removedRowId);
        }
      }
    }

    // Re-read after modifications to avoid using the stale snapshot.
    final updatedPurchaseItems =
        addItemCubit.state.lists['purchaseItems'] ?? [];

    final minLength = currentLength < updatedPurchaseItems.length
        ? currentLength
        : updatedPurchaseItems.length;

    for (int i = 0; i < minLength; i++) {
      final rowId = updatedPurchaseItems[i];
      final qty = itemsEntries[i].value.toString();

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'requested_qty_$rowId',
        value: qty,
        isValid: true,
      );

      // Keep the rowId-to-itemId mapping in sync.
      _rowIdToItemId[rowId] = itemsEntries[i].key.itemId;
    }

    // For draft orders: after key reconciliation, the API items now have
    // valid itemId values. Patch any empty choosed_item_source_id fields
    // so the summary screen can filter items correctly.
    if (strategy is UpdateDraftOrderCreateOrderStrategy) {
      for (int i = 0; i < minLength; i++) {
        final rowId = updatedPurchaseItems[i];
        final apiItem = itemsEntries[i].key;
        final currentValue = validationCubit.getFieldValue(
          'choosed_item_source_id_$rowId',
        );
        if (currentValue.isEmpty && apiItem.itemId.isNotEmpty) {
          validationCubit.validateFieldAndStoreValue(
            fieldName: 'choosed_item_source_id_$rowId',
            value: apiItem.itemId,
            isValid: true,
          );
        }
      }
    }
  }

  void _applySupplierFilterToExistingItems(
    BuildContext context,
    SelectFilterItemState filterState,
  ) {
    final addItemCubit = context.read<AddItemCubit>();
    final validationCubit = context.read<ValidationCubit>();
    final purchaseItems = addItemCubit.state.lists['purchaseItems'] ?? [];

    if (purchaseItems.isEmpty) return;

    final itemsEntries = context
        .read<AddItemPurchaseCubit>()
        .state
        .items
        .entries
        .toList();

    for (int i = 0; i < purchaseItems.length; i++) {
      final rowId = purchaseItems[i];

      final existingSource = validationCubit.getFieldValue('sourceType_$rowId');
      if (existingSource.isNotEmpty) continue;

      final item = i < itemsEntries.length ? itemsEntries[i].key : null;
      if (item == null) continue;

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'sourceType_$rowId',
        value: PurchaseSourcesTypes.supplier.toString(),
        isValid: true,
      );

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'source_id_$rowId',
        value: filterState.selectedId!,
        isValid: true,
      );

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'source_name_$rowId',
        value: filterState.selectedName!,
        isValid: true,
      );

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'choosed_item_source_id_$rowId',
        value: item.itemId,
        isValid: true,
      );

      validationCubit.addDynamicFields({'quality_$rowId'});
      validationCubit.validateFieldAndStoreValue(
        fieldName: 'quality_$rowId',
        value: PurchasingOfficerQualityEnum.economy.toString(),
        isValid: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectFilterItemCubit, SelectFilterItemState>(
      listenWhen: (previous, current) =>
          current.selectedFilterType == SelectFilterItemType.supplier &&
          current.selectedId != null &&
          current.selectedName != null &&
          current.selectedId != previous.selectedId,
      listener: _applySupplierFilterToExistingItems,
      child: BlocListener<AddItemPurchaseCubit, AddItemPurchaseState>(
        listenWhen: (previous, current) => previous.items != current.items,
        listener: _handleListener,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 20.r),
          child: Column(
            children: [
              Text(
                context.tr.chooseTheOptimalSourceForEachOfYourOrder,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              17.verticalSpace,
              Expanded(
                child: BlocBuilder<AddItemCubit, AddItemState>(
                  builder: (context, addItemStatestate) {
                    return BlocBuilder<
                      AddItemPurchaseCubit,
                      AddItemPurchaseState
                    >(
                      builder: (context, state) {
                        final purchaseItems =
                            addItemStatestate.lists['purchaseItems'] ?? [];

                        _syncDynamicValidationFields(
                          context: context,
                          validationCubit: context.read<ValidationCubit>(),
                          purchaseItems: purchaseItems,
                        );

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.r),
                              child: BlocSelector<ValidationCubit, ValidationState, String>(
                                selector: (state) =>
                                    state
                                        .fieldsValue['sourceType_${purchaseItems[index]}'] ??
                                    '',
                                builder: (context, validationState) {
                                  return ItemNewOrderWidget(
                                    strategy: PurchaseSourcesTypes.getStrategy(
                                      PurchaseSourcesTypes.fromValue(
                                        validationState,
                                      ),
                                    ),
                                    item: state.items.keys.toList()[index],
                                    quantity:
                                        int.tryParse(
                                          context
                                              .read<ValidationCubit>()
                                              .getFieldValue(
                                                'requested_qty_${purchaseItems[index]}',
                                              ),
                                        ) ??
                                        0,
                                    sourceTypeFieldName:
                                        'sourceType_${purchaseItems[index]}',
                                    sourceIdFieldName:
                                        'source_id_${purchaseItems[index]}',
                                    sourceNameFieldName:
                                        'source_name_${purchaseItems[index]}',
                                    choosedSourceItemIdFieldName:
                                        'choosed_item_source_id_${purchaseItems[index]}',
                                    addedItemMainId: purchaseItems[index],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.edit,
                      textColor: context.customColor.text6,
                      onTap: () {
                        context.read<PagingCubit>().goToStep(0);
                      },
                      borderRadius: 1000.r,
                      padding: EdgeInsets.symmetric(
                        vertical: 18.r,
                        horizontal: 30.r,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: BlocSelector<ValidationCubit, ValidationState, bool>(
                      selector: (state) => state.enableButton,
                      builder: (context, state) {
                        return AppButton(
                          text: context.tr.viewSummary,
                          enabled: state,
                          onClick: () {
                            final addItemCubit = context.read<AddItemCubit>();
                            final validationCubit = context
                                .read<ValidationCubit>();

                            final sources = <SourceLocalModel>[];

                            for (final itemId
                                in addItemCubit.state.lists['purchaseItems'] ??
                                    []) {
                              final sourceId = validationCubit.getFieldValue(
                                'source_id_$itemId',
                              );

                              final sourceName = validationCubit.getFieldValue(
                                'source_name_$itemId',
                              );

                              final sourceTypeStr = validationCubit
                                  .getFieldValue('sourceType_$itemId');

                              final choosedItemSourceId = validationCubit
                                  .getFieldValue(
                                    'choosed_item_source_id_$itemId',
                                  );

                              final requestedQtyStr = validationCubit
                                  .getFieldValue('requested_qty_$itemId');

                              if (sourceId.isEmpty ||
                                  sourceName.isEmpty ||
                                  sourceTypeStr.isEmpty ||
                                  choosedItemSourceId.isEmpty ||
                                  requestedQtyStr.isEmpty) {
                                continue;
                              }

                              final type = PurchaseSourcesTypes.fromValue(
                                sourceTypeStr,
                              );

                              final index = sources.indexWhere(
                                (e) => e.sourceId == sourceId && e.type == type,
                              );

                              if (index != -1) {
                                sources[index].choosedItemSourceIds.add(
                                  choosedItemSourceId,
                                );

                                sources[index].mainIds.add(itemId);
                                sources[index].requestedQty.add(
                                  requestedQtyStr,
                                );
                              } else {
                                sources.add(
                                  SourceLocalModel(
                                    mainIds: {itemId},
                                    sourceId: sourceId,
                                    sourceName: sourceName,
                                    choosedItemSourceIds: [choosedItemSourceId],
                                    type: type,
                                    requestedQty: [requestedQtyStr],
                                  ),
                                );
                              }
                            }

                            NavigationService.I.push(
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: addItemCubit),
                                    BlocProvider.value(value: validationCubit),
                                    BlocProvider(
                                      create: (context) => PagingCubit(
                                        totalSteps: sources.length,
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          getIt<CreatePurchaseOrderCubit>(),
                                    ),
                                  ],
                                  child: NewPurchaseOrderSummaryScreen(
                                    sources: sources,
                                    strategy: strategy,
                                  ),
                                ),
                              ),
                            );
                          },
                          padding: EdgeInsets.symmetric(
                            vertical: 18.r,
                            horizontal: 30.r,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
