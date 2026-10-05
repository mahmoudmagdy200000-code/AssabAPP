import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/quick_cash_expense_data_model.dart';
import 'expense_summary_row_widget.dart';

class QuickCashExpenseDetailsMiddleSection extends StatelessWidget {
  final QuickCashExpenseData quickCashExpenseData;

  const QuickCashExpenseDetailsMiddleSection({
    super.key,
    required this.quickCashExpenseData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Text(
            context.tr.expenseSummary,
            style: AppStyles.s18W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          ExpenseSummaryRowWidget(
            title: context.tr.expenseDate,
            value:
                DateFormatter.formatDateMDY(
                  DateTime.tryParse(quickCashExpenseData.expenseDate),
                ) ??
                'No Date',
            showAmountIcon: false,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          ExpenseSummaryRowWidget(
            title: context.tr.title,
            value: quickCashExpenseData.expenseTitle,
            showAmountIcon: false,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          ExpenseSummaryRowWidget(
            title: context.tr.totalAmount,
            value: quickCashExpenseData.totalAmount,
          ),
          14.verticalSpace,
          if (quickCashExpenseData.listItems.isNotEmpty) ...[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: context.customColor.border),
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: List.generate(quickCashExpenseData.listItems.length, (
                  index,
                ) {
                  return Column(
                    children: [
                      ExpenseSummaryRowWidget(
                        title: quickCashExpenseData.listItems[index].itemTitle,
                        value: quickCashExpenseData.listItems[index].itemAmount,
                      ),
                      if (index !=
                          quickCashExpenseData.listItems.length - 1) ...[
                        10.verticalSpace,
                        const CustomDivider(),
                        10.verticalSpace,
                      ],
                    ],
                  );
                }),
              ),
            ),
            14.verticalSpace,
          ],
        ],
      ),
    );
  }
}
