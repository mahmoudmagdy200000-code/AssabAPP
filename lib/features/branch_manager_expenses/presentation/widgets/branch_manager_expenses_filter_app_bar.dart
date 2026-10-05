import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_search/expenses_search_cubit.dart';
import '../cubit/expenses_search/expenses_search_state.dart';

class BranchManagerExpensesFilterAppBar extends StatelessWidget {
  const BranchManagerExpensesFilterAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      bottom: 0,
      child: Row(
        children: [
          const AppBackButton(),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocSelector<ExpensesSearchCubit, ExpensesSearchState, int>(
                selector: (state) => (state is ExpensesSearchSuccess)
                    ? state.expenses.data.length
                    : 0,
                builder: (context, state) {
                  return Text(
                    '${context.tr.expenseHistory} ($state)',
                    style: AppStyles.s17W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  );
                },
              ),
              Text(
                context.tr.manageSortAndViewDetailsOfExpenses,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
