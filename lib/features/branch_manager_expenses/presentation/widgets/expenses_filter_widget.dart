import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/expenses_filter_widget_buttons_section.dart';
import 'package:flutter/material.dart';

import '../cubit/expenses_filter/expenses_filter_cubit.dart';
import 'expenses_filter_widget_bottom_section.dart';
import 'expenses_filter_widget_middle_section.dart';
import 'expenses_filter_widget_top_section.dart';

class ExpensesFilterWidget extends StatelessWidget {
  final void Function(ExpensesFilterCubit cubit) onClickShowResults;

  const ExpensesFilterWidget({super.key, required this.onClickShowResults});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        children: [
          const ExpensesFilterWidgetTopSection(),
          const ExpensesFilterWidgetMiddleSection(),
          const ExpensesFilterWidgetBottomSection(),
          const Spacer(),
          ExpensesFilterWidgetButtonsSection(
            onClickShowResults: onClickShowResults,
          ),
        ],
      ),
    );
  }
}
