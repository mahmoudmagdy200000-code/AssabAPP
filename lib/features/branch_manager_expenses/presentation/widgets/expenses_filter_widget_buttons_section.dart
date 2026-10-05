import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expenses_filter/expenses_filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_filter/expenses_filter_cubit.dart';

class ExpensesFilterWidgetButtonsSection extends StatelessWidget {
  final void Function(ExpensesFilterCubit cubit) onClickShowResults;

  const ExpensesFilterWidgetButtonsSection({
    super.key,
    required this.onClickShowResults,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppGestureDetectorButton(
            onTap: () => context.read<ExpensesFilterCubit>().resetFilter(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 23.r),
              child: Center(
                child: Text(
                  context.tr.defaultSettings,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ),
          ),
        ),
        20.horizontalSpace,
        BlocBuilder<ExpensesFilterCubit, ExpensesFilterState>(
          builder: (context, state) {
            final expensesFilterCubit = context.read<ExpensesFilterCubit>();
            final isValid = expensesFilterCubit.areAllFiltersValid;

            return Expanded(
              child: AppGestureDetectorButton(
                onTap: () => onClickShowResults(expensesFilterCubit),
                child: Container(
                  decoration: BoxDecoration(
                    color: isValid
                        ? context.theme.primaryColor
                        : context.customColor.text2,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.text2),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 18.r,
                    horizontal: 23.r,
                  ),
                  child: Center(
                    child: Text(
                      context.tr.showResults,
                      style: AppStyles.s14W400.copyWith(
                        color: isValid
                            ? context.customColor.reversedTextColor
                            : context.customColor.text3,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
