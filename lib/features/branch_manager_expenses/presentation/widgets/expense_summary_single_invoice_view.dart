import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import 'expense_summary_row_widget.dart';

class ExpenseSummarySingleInvoiceView extends StatelessWidget {
  final String issueDate;
  final String taxId;
  final String supplierName;
  final String totalInvoiceItems;
  final String totalAmountPaid;

  const ExpenseSummarySingleInvoiceView({
    super.key,
    required this.issueDate,
    required this.taxId,
    required this.supplierName,
    required this.totalInvoiceItems,
    required this.totalAmountPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseSummaryRowWidget(
          title: context.tr.issueDate,
          value: issueDate,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.taxId,
          value: taxId,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.supplierName,
          value: supplierName,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.totalInvoiceItems,
          value: totalInvoiceItems,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.totalAmountPaid,
          value: totalAmountPaid,
        ),
      ],
    );
  }
}
