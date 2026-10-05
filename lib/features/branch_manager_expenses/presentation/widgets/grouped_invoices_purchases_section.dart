import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/add_item/add_item_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import 'grouped_item_view_purchases_widget.dart';

class GroupedInvoicesPurchasesSection extends StatelessWidget {
  final String id;

  const GroupedInvoicesPurchasesSection({super.key, required this.id});

  void _onAddNewPurchaseItem(BuildContext context) {
    context.read<AddItemCubit>().addItem('purchases_$id');
  }

  void _syncDynamicPurchaseValidationFields({
    required BuildContext context,
    required ValidationCubit validationCubit,
    required List<String> purchaseItems,
  }) {
    final dynamicFields = purchaseItems
        .expand(
          (purchaseId) => {
            'itemPurchasedId_${id}_$purchaseId',
            'itemPurchasedName_${id}_$purchaseId',
            'purchaseQty_${id}_$purchaseId',
            'purchaseUnitPrice_${id}_$purchaseId',
          },
        )
        .toSet();

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('itemPurchasedId_${id}_') ||
              key.startsWith('itemPurchasedName_${id}_') ||
              key.startsWith('purchaseQty_${id}_') ||
              key.startsWith('purchaseUnitPrice_${id}_'),
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
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(10.r),
      child: Column(
        children: [
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr.purchases,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              AppGestureDetectorButton(
                onTap: () => _onAddNewPurchaseItem(context),
                child: Text(
                  context.tr.addItem,
                  style: AppStyles.s14W400.copyWith(
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          5.verticalSpace,
          BlocSelector<AddItemCubit, AddItemState, List<String>>(
            selector: (state) => state.lists['purchases_$id'] ?? [],
            builder: (context, purchaseItems) {
              final validationCubit = context.read<ValidationCubit>();

              _syncDynamicPurchaseValidationFields(
                context: context,
                validationCubit: validationCubit,
                purchaseItems: purchaseItems,
              );

              return Column(
                children: List.generate(purchaseItems.length, (index) {
                  final purchaseId = purchaseItems[index];

                  return KeyedSubtree(
                    key: ValueKey(purchaseId),
                    child: Column(
                      children: [
                        GroupedItemViewPurchasesWidget(
                          index: index,
                          purchaseId: purchaseId,
                          invoiceId: id,
                          alwaysShowDelete: true,
                          listName: 'purchases_$id',
                          fieldName: 'itemPurchasedName_${id}_$purchaseId',
                          onChooseSubItem: (expensesSupCategoryEntity) {
                            validationCubit.validateFieldAndStoreValue(
                              fieldName: 'itemPurchasedName_${id}_$purchaseId',
                              value: expensesSupCategoryEntity.name,
                              isValid: true,
                            );
                            validationCubit.validateFieldAndStoreValue(
                              fieldName: 'itemPurchasedId_${id}_$purchaseId',
                              value: expensesSupCategoryEntity.id.toString(),
                              isValid: true,
                            );
                          },
                          onChangeData: (qty, unitPrice) {
                            validationCubit
                              ..validateFieldAndStoreValue(
                                fieldName: 'purchaseQty_${id}_$purchaseId',
                                value: qty,
                                isValid: qty.isNotEmpty,
                              )
                              ..validateFieldAndStoreValue(
                                fieldName:
                                    'purchaseUnitPrice_${id}_$purchaseId',
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
          ),
        ],
      ),
    );
  }
}
