import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/top_section_of_single_expense_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/strategies/pre_approval_draft_strategy.dart';
import '../widgets/pre_approval_expense_item_view_expenses_list.dart';
import '../widgets/pre_approval_expense_item_view_purchases_list.dart';

class PreApprovalRequestItemsView extends StatelessWidget {
  final PreApprovalDraftStrategy strategy;

  const PreApprovalRequestItemsView({super.key, required this.strategy});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopSectionOfSingleExpenseViews(
            title: context.tr.invoiceItems,
            desc: context.tr.invoiceItemsDesc,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: LabelTextField(text: context.tr.purchases)),
                    _addItemButton(
                      context: context,
                      onTap: () {
                        context.read<AddItemCubit>().addItem('purchases');
                      },
                    ),
                  ],
                ),
                10.verticalSpace,
                const CustomDivider(),
                10.verticalSpace,
                PreApprovalExpenseItemViewPurchasesList(strategy: strategy),
              ],
            ),
          ),
          14.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: LabelTextField(text: context.tr.expenses)),
                    _addItemButton(
                      context: context,
                      onTap: () {
                        context.read<AddItemCubit>().addItem('expenses');
                      },
                    ),
                  ],
                ),
                10.verticalSpace,
                const CustomDivider(),
                10.verticalSpace,
                PreApprovalExpenseItemViewExpensesList(strategy: strategy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addItemButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 20.r, color: context.theme.primaryColor),
          5.horizontalSpace,
          Text(
            context.tr.addItem,
            style: AppStyles.s12W400.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
