import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/single_invoice_draft_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/add_item/add_item_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import 'item_view_expenses_widget.dart';

class ExpenseItemViewExpensesList extends StatefulWidget {
  final SingleInvoiceDraftStrategy strategy;

  const ExpenseItemViewExpensesList({super.key, required this.strategy});

  @override
  State<ExpenseItemViewExpensesList> createState() =>
      _ExpenseItemViewExpensesListState();
}

class _ExpenseItemViewExpensesListState
    extends State<ExpenseItemViewExpensesList> {
  @override
  void initState() {
    widget.strategy.addInitExpenseItem(context);
    super.initState();
  }

  void _syncDynamicValidationFields({
    required BuildContext context,
    required ValidationCubit validationCubit,
    required List<String> expenseItems,
  }) {
    final dynamicFields = expenseItems
        .expand(
          (id) => {
            'expenseItemId_$id',
            'expenseItemName_$id',
            'expenseUnitPrice_$id',
          },
        )
        .toSet();

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('expenseItemId_') ||
              key.startsWith('expenseItemName_') ||
              key.startsWith('expenseUnitPrice_'),
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
      selector: (state) => state.lists['expenses'] ?? [],
      builder: (context, expenseItems) {
        final validationCubit = context.read<ValidationCubit>();

        _syncDynamicValidationFields(
          context: context,
          validationCubit: validationCubit,
          expenseItems: expenseItems,
        );

        return Column(
          children: List.generate(expenseItems.length, (index) {
            final id = expenseItems[index];

            return KeyedSubtree(
              key: UniqueKey(),
              child: Column(
                children: [
                  ItemViewExpensesWidget(
                    index: index,
                    id: id,
                    fieldName: 'expenseItemName_$id',
                    onChooseSubExpense: (expensesSupCategoryEntity) {
                      validationCubit.validateFieldAndStoreValue(
                        fieldName: 'expenseItemName_$id',
                        value: expensesSupCategoryEntity.name,
                        isValid: true,
                      );
                      validationCubit.validateFieldAndStoreValue(
                        fieldName: 'expenseItemId_$id',
                        value: expensesSupCategoryEntity.id.toString(),
                        isValid: true,
                      );
                    },
                    onChangeData: (unitPrice) {
                      validationCubit.validateFieldAndStoreValue(
                        fieldName: 'expenseUnitPrice_$id',
                        value: unitPrice,
                        isValid: unitPrice.isNotEmpty,
                      );
                    },
                  ),
                  if (index != expenseItems.length - 1) 12.verticalSpace,
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
