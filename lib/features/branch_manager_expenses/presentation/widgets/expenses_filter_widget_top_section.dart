import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/expenses_filter_keys.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../cubit/expenses_filter/expenses_filter_cubit.dart';
import '../cubit/expenses_filter/expenses_filter_state.dart';
import 'expenses_filter_text_button.dart';
import 'expenses_filter_widget_text_title.dart';

class ExpensesFilterWidgetTopSection extends StatelessWidget {
  const ExpensesFilterWidgetTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List buttons = [
      context.tr.all,
      context.tr.draft,
      context.tr.quickCashExpense,
      context.tr.singleInvoice,
      context.tr.groupedInvoices,
      context.tr.preApprovalRequest,
    ];

    return BlocBuilder<ExpensesFilterCubit, ExpensesFilterState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              context.tr.filterExpenseListBy,
              style: AppStyles.s16W600.copyWith(
                fontSize: 16.f,
                color: context.customColor.text1,
              ),
            ),
            16.verticalSpace,
            const CustomDivider(),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: ExpensesFilterWidgetTextTitle(text: context.tr.type),
            ),
            GridView.builder(
              itemCount: buttons.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 8.h,
                childAspectRatio: 3.5.h,
              ),
              itemBuilder: (context, index) {
                return ExpensesFilterTextButton(
                  isSelected:
                      state.type[ExpensesFilterKeys.values[index]] ?? false,
                  onClick: () {
                    context.read<ExpensesFilterCubit>().updateType(
                      ExpensesFilterKeys.values[index],
                    );
                  },
                  text: buttons[index],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
