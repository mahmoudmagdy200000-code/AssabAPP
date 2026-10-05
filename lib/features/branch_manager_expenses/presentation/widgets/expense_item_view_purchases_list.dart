import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/add_item/add_item_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../domain/strategies/single_invoice_draft_strategy.dart';
import 'item_view_purchases_widget.dart';

class ExpenseItemViewPurchasesList extends StatefulWidget {
  final SingleInvoiceDraftStrategy strategy;

  const ExpenseItemViewPurchasesList({super.key, required this.strategy});

  @override
  State<ExpenseItemViewPurchasesList> createState() =>
      _ExpenseItemViewPurchasesListState();
}

class _ExpenseItemViewPurchasesListState
    extends State<ExpenseItemViewPurchasesList> {
  @override
  void initState() {
    widget.strategy.addInitPurchaseItem(context);
    super.initState();
  }

  void _syncDynamicValidationFields({
    required BuildContext context,
    required ValidationCubit validationCubit,
    required List<String> purchaseItems,
  }) {
    final dynamicFields = purchaseItems
        .expand(
          (id) => {
            'itemPurchasedId_$id',
            'itemPurchasedName_$id',
            'purchaseQty_$id',
            'purchaseUnitPrice_$id',
          },
        )
        .toSet();

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('itemPurchasedId_') ||
              key.startsWith('itemPurchasedName_') ||
              key.startsWith('purchaseQty_') ||
              key.startsWith('purchaseUnitPrice_'),
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

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddItemCubit, AddItemState, List<String>>(
      selector: (state) => state.lists['purchases'] ?? [],
      builder: (context, purchaseItems) {
        final validationCubit = context.read<ValidationCubit>();

        _syncDynamicValidationFields(
          context: context,
          validationCubit: validationCubit,
          purchaseItems: purchaseItems,
        );

        return Column(
          children: List.generate(purchaseItems.length, (index) {
            final id = purchaseItems[index];

            return KeyedSubtree(
              key: UniqueKey(),
              child: Column(
                children: [
                  ItemViewPurchasesWidget(
                    index: index,
                    id: id,
                    fieldName: 'itemPurchasedName_$id',
                    onChooseSubItem: (expensesSupCategoryEntity) {
                      validationCubit.validateFieldAndStoreValue(
                        fieldName: 'itemPurchasedName_$id',
                        value: expensesSupCategoryEntity.name,
                        isValid: true,
                      );
                      validationCubit.validateFieldAndStoreValue(
                        fieldName: 'itemPurchasedId_$id',
                        value: expensesSupCategoryEntity.id.toString(),
                        isValid: true,
                      );
                    },
                    onChangeData: (qty, unitPrice) {
                      validationCubit
                        ..validateFieldAndStoreValue(
                          fieldName: 'purchaseQty_$id',
                          value: qty,
                          isValid: qty.isNotEmpty,
                        )
                        ..validateFieldAndStoreValue(
                          fieldName: 'purchaseUnitPrice_$id',
                          value: unitPrice,
                          isValid: unitPrice.isNotEmpty,
                        );
                    },
                  ),
                  if (index != purchaseItems.length - 1) 12.verticalSpace,
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
