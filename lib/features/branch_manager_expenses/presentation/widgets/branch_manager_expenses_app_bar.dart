import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/branch_manager_expenses/branch_manager_expenses_cubit.dart';
import 'add_expenses_bottom_sheet_widget.dart';

class BranchManagerExpensesAppBar extends StatelessWidget {
  const BranchManagerExpensesAppBar({super.key});

  void _addExpensesBottomSheet(BuildContext context) {
    AppBottomSheet.pageRoute(
      context,
      (context) => const AddExpensesBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 35.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.expenses,
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              6.verticalSpace,
              BlocSelector<
                BranchManagerExpensesCubit,
                BranchManagerExpensesState,
                int
              >(
                selector: (state) =>
                    (state is BranchManagerGetExpensesSummarySuccess)
                    ? state.expensesSummary.totalExpenses
                    : 0,
                builder: (context, state) {
                  return Text(
                    '$state ${context.tr.totalExpensesAdded}',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  );
                },
              ),
            ],
          ),
          AppGestureDetectorButton(
            onTap: () => _addExpensesBottomSheet(context),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(1000.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 12.f),
              child: Row(
                children: [
                  Icon(Icons.add, color: context.customColor.reversedTextColor),
                  6.horizontalSpace,
                  Text(
                    context.tr.addExpense,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.reversedTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
