import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/add_item/add_item_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import 'expense_item_widget.dart';

class QuickCashListItemExpense extends StatelessWidget {
  final void Function()? validateItemsAmount;
  final List<String> expenseTitles;
  final List<String> expenseAmounts;

  const QuickCashListItemExpense({
    super.key,
    this.validateItemsAmount,
    this.expenseTitles = const [],
    this.expenseAmounts = const [],
  });

  void _syncDynamicValidationFields({
    required BuildContext context,
    required ValidationCubit validationCubit,
    required List<String> expenseItems,
  }) {
    final dynamicFields = expenseItems
        .expand((id) => {'item_title_$id', 'item_amount_$id'})
        .toSet();

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (k) => k.startsWith('item_title_') || k.startsWith('item_amount_'),
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
      selector: (state) => state.lists['quick_cash_expense_items'] ?? [],
      builder: (context, expenseItems) {
        final validationCubit = context.read<ValidationCubit>();

        _syncDynamicValidationFields(
          context: context,
          expenseItems: expenseItems,
          validationCubit: validationCubit,
        );

        return Column(
          children: List.generate(expenseItems.length, (index) {
            final id = expenseItems[index];

            return KeyedSubtree(
              key: ValueKey(id),
              child: ExpensesItem(
                index: index,
                labelTitle: context.tr.itemTitle,
                labelAmount: context.tr.thisItemAmount,
                totalAmountFieldValidationKey: 'item_amount_$id',
                title: expenseTitles.length > index
                    ? expenseTitles[index]
                    : null,
                amount: expenseAmounts.length > index
                    ? expenseAmounts[index]
                    : null,
                validateItemsAmount: validateItemsAmount,
                onDataChanged: (title, amount) {
                  validationCubit
                    ..validateFieldAndStoreValue(
                      fieldName: 'item_title_$id',
                      value: title,
                      isValid: title.isNotEmpty,
                    )
                    ..validateFieldAndStoreValue(
                      fieldName: 'item_amount_$id',
                      value: amount,
                      isValid: amount.isNotEmpty,
                    );
                },
              ),
            );
          }),
        );
      },
    );
  }
}
