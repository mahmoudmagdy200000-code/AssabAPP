import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';

class AddItemExpenseButton extends StatelessWidget {
  const AddItemExpenseButton({super.key});

  void _onAddItemExpensePressed(BuildContext context) {
    context.read<AddItemCubit>().addItem('quick_cash_expense_items');

    context.read<ValidationCubit>().toggleFieldRequirement(
      'itemsAmount',
      isRequired: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () => _onAddItemExpensePressed(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.theme.primaryColor),
        ),
        padding: EdgeInsets.all(9.r),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 14.r, color: context.theme.primaryColor),
            3.horizontalSpace,
            Text(
              context.tr.addItemExpense,
              style: AppStyles.s12W400.copyWith(
                color: context.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
