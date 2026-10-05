import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../domain/strategies/expense_category.dart';
import 'add_expenses_bottom_sheet_widget.dart';
import 'expenses_empty_widget.dart';

class ExpensesHistoryEmptyWidget extends StatelessWidget {
  final ExpenseCategory expenseCategory;
  final bool showAddButton;
  final bool isExpanded;

  const ExpensesHistoryEmptyWidget({
    super.key,
    required this.expenseCategory,
    this.showAddButton = true,
    this.isExpanded = true,
  });

  void _addExpensesBottomSheet(BuildContext context) {
    AppBottomSheet.pageRoute(
      context,
      (context) => const AddExpensesBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      return Expanded(child: _buildContent(context));
    } else {
      return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ExpensesEmptyWidget(
            icon: expenseCategory.icon,
            title: expenseCategory.title(context),
            desc: expenseCategory.desc(context),
          ),
          if (showAddButton)
            AppGestureDetectorButton(
              onTap: () {
                NavigationService.I.pop();
                _addExpensesBottomSheet(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: context.customColor.border),
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                padding: EdgeInsets.all(17.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: context.customColor.text1),
                    Text(
                      context.tr.addNewExpense,
                      style: AppStyles.s16W400.copyWith(
                        color: context.customColor.text1,
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
