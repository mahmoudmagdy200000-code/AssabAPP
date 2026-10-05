import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/expenses_filter_result_bottom_section.dart';
import 'package:flutter/material.dart';

import 'branch_manager_expenses_filter_app_bar.dart';
import 'expenses_filter_result_top_section.dart';

class ExpensesFilterResultScreen extends StatelessWidget {
  const ExpensesFilterResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          20.verticalSpace,
          const BranchManagerExpensesFilterAppBar(),
          10.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                children: [
                  const ExpensesFilterResultTopSection(),
                  10.verticalSpace,
                  const ExpensesFilterResultBottomSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
