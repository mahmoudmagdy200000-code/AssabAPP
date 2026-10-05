import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import 'expense_summary_row_widget.dart';

class ExpenseSummaryPreApprovalView extends StatelessWidget {
  final String purpose;
  final String estimatedAmount;
  final String paymentMethod;
  final String priority;

  const ExpenseSummaryPreApprovalView({
    super.key,
    required this.purpose,
    required this.estimatedAmount,
    required this.paymentMethod,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseSummaryRowWidget(
          title: context.tr.purpose,
          value: purpose,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.estimatedAmount,
          value: estimatedAmount,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.paymentMethod,
          value: paymentMethod,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.priority,
          value: priority,
          showAmountIcon: false,
        ),
      ],
    );
  }
}
