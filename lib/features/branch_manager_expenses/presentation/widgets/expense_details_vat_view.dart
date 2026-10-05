import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import 'expense_summary_row_widget.dart';

class ExpenseDetailsVatView extends StatelessWidget {
  final String invoiceNumber;
  final String netAmount;
  final String vatAmount;
  final String totalInclVat;

  const ExpenseDetailsVatView({
    super.key,
    required this.invoiceNumber,
    required this.netAmount,
    required this.vatAmount,
    required this.totalInclVat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseSummaryRowWidget(
          title: context.tr.invoiceNumber,
          value: invoiceNumber,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(title: context.tr.netAmount, value: netAmount),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(title: context.tr.vatAmount, value: vatAmount),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.totalInclVat,
          value: totalInclVat,
        ),
      ],
    );
  }
}
