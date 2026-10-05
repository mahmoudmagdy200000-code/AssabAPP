import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/string_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/pre_approval_draft_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../widgets/custom_data_table.dart';
import '../widgets/expense_summary_row_widget.dart';

class PreApprovalRequestSummaryView extends StatelessWidget {
  final PreApprovalDraftStrategy strategy;
  final List<AttachmentModel> apiAttachments;

  const PreApprovalRequestSummaryView({
    super.key,
    required this.strategy,
    required this.apiAttachments,
  });

  List<Map<String, String>> _collectTableData(Map<String, String> values) {
    final allItems = <Map<String, String>>[];

    final purchaseIds = values.keys
        .where((k) => k.startsWith('itemPurchasedName_'))
        .map((k) => k.split('_').last)
        .toList();

    for (final id in purchaseIds) {
      final name = values['itemPurchasedName_$id'] ?? '';
      final qty = values['purchaseQty_$id'] ?? '1';
      final price = values['purchaseUnitPrice_$id'] ?? '';

      allItems.add({
        'qty': qty,
        'name': name,
        'price': price,
        'total': (price.toDoubleOrZero() * qty.toDoubleOrZero())
            .toStringAsFixed(2),
      });
    }

    final expenseIds = values.keys
        .where((k) => k.startsWith('expenseItemName_'))
        .map((k) => k.split('_').last)
        .toList();

    for (final id in expenseIds) {
      final name = values['expenseItemName_$id'] ?? '';
      final price = values['expenseUnitPrice_$id'] ?? '';
      allItems.add({'qty': '1', 'name': name, 'price': price, 'total': price});
    }

    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.verticalSpace,
          Text(
            context.tr.reviewRequestSummary,
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          Text(
            context.tr.requestSummaryDesc,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          14.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.requestSummary,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['purpose'],
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.purpose,
                      value: state ?? 'N/A',
                      showAmountIcon: false,
                    );
                  },
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['estimatedAmount'],
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.estimatedAmount,
                      value: state ?? 'N/A',
                    );
                  },
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['paymentMethod'],
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.paymentMethod,
                      value: state ?? 'N/A',
                      showAmountIcon: false,
                    );
                  },
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['priority'],
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.priority,
                      value: state ?? 'N/A',
                      showAmountIcon: false,
                    );
                  },
                ),
                14.verticalSpace,
                Text(
                  context.tr.attachment,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                8.verticalSpace,
                strategy.buildSummaryAttachmentSection(context, apiAttachments),
              ],
            ),
          ),
          14.verticalSpace,
          BlocSelector<ValidationCubit, ValidationState, Map<String, String>>(
            selector: (state) => state.fieldsValue,
            builder: (context, values) {
              final allItems = _collectTableData(values);

              if (allItems.isEmpty) {
                return const SizedBox.shrink();
              }

              return CustomDataTable(
                headers: [
                  context.tr.description,
                  context.tr.qty,
                  context.tr.rate,
                  context.tr.total,
                ],
                keysOrder: const ['name', 'qty', 'price', 'total'],
                items: allItems,
              );
            },
          ),
        ],
      ),
    );
  }
}
