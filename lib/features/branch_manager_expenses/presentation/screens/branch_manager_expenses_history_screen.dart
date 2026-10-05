import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/branch_manager_expenses_history_top_section.dart';
import 'package:flutter/material.dart';

import '../widgets/branch_manager_expenses_history_app_bar.dart';
import '../widgets/branch_manager_expenses_history_bottom_section.dart';

class BranchManagerExpensesHistoryScreen extends StatelessWidget {
  const BranchManagerExpensesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          10.verticalSpace,
          const BranchManagerExpensesHistoryAppBar(),
          15.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: const Column(
                children: [
                  BranchManagerExpensesHistoryTopSection(),
                  BranchManagerExpensesHistoryBottomSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
