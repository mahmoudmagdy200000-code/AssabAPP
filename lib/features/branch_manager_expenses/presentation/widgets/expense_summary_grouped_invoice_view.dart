import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import 'expense_summary_row_widget.dart';

class ExpenseSummaryGroupedInvoiceView extends StatelessWidget {
  final String supplierName;
  final String totalGroupedInvoice;

  const ExpenseSummaryGroupedInvoiceView({
    super.key,
    required this.supplierName,
    required this.totalGroupedInvoice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseSummaryRowWidget(
          title: context.tr.supplierName,
          value: supplierName,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.totalGroupedInvoice,
          value: totalGroupedInvoice,
          showAmountIcon: false,
        ),
      ],
    );
  }
}
