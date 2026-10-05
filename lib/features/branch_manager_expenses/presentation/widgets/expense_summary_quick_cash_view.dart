import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../domain/entities/quick_cash_entity.dart';
import 'expense_summary_row_widget.dart';
import 'row_payment_widget.dart';

class ExpenseSummaryQuickCashView extends StatelessWidget {
  final QuickCashEntity quickCashEntity;

  const ExpenseSummaryQuickCashView({super.key, required this.quickCashEntity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseSummaryRowWidget(
          title: context.tr.expenseDate,
          value:
              DateFormatter.formatDateMDY(
                DateTime.tryParse(quickCashEntity.createdAt),
              ) ??
              'N/A',
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.title,
          value: quickCashEntity.expenseName,
          showAmountIcon: false,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        ExpenseSummaryRowWidget(
          title: context.tr.totalAmount,
          value: quickCashEntity.totalAmount,
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
        RowPaymentWidget(paymentMethod: quickCashEntity.paymentMethod),
      ],
    );
  }
}
