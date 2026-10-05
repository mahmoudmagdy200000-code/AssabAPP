import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expenses_search/expenses_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/filter_button.dart';
import '../../domain/strategies/expense_category.dart';
import '../cubit/expenses_filter/expenses_filter_cubit.dart';
import 'expenses_filter_result_screen.dart';
import 'expenses_filter_widget.dart';

class BranchManagerExpensesHistoryTopSection extends StatelessWidget {
  const BranchManagerExpensesHistoryTopSection({super.key});

  void _updateSelectedCategory(BuildContext context, int index) {
    context.read<PagingCubit>().goToStep(index);
  }

  void _getExpenses({
    required BuildContext context,
    required int index,
    required ExpenseCategory expenseCategory,
  }) {
    _updateSelectedCategory(context, index);
    expenseCategory.get(context);
  }

  Color _selectedColor({
    required BuildContext context,
    required bool condition,
  }) {
    return condition ? context.theme.primaryColor : context.customColor.text3;
  }

  List<ExpenseCategory> get _expenseCategories {
    return const [
      AllExpense(),
      DraftExpense(),
      QuickCashExpense(),
      SingleInvoiceExpense(),
      GroupInvoicesExpense(),
      PreApprovalExpense(),
    ];
  }

  void _showResultsScreen({
    required BuildContext context,
    required bool isValid,
  }) {
    if (isValid) {
      final cubit = context.read<ExpensesFilterCubit>();

      NavigationService.I.pop();

      AppBottomSheet.customPageRoute(context, (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(create: (context) => getIt<ExpensesSearchCubit>()),
          ],
          child: const ExpensesFilterResultScreen(),
        );
      });
    }
  }

  void _showFilter(BuildContext context) {
    final cubit = context.read<ExpensesFilterCubit>();

    AppBottomSheet.show(
      context,
      (context) => BlocProvider.value(
        value: cubit,
        child: ExpensesFilterWidget(
          onClickShowResults: (cubit) => _showResultsScreen(
            context: context,
            isValid: cubit.areAllFiltersValid,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13.r),
      child: Column(
        children: [
          Row(
            children: [
              FilterButton(onClick: () => _showFilter(context)),
              6.horizontalSpace,
              Container(
                color: context.customColor.text2,
                width: 1.w,
                height: 10.h,
              ),
              6.horizontalSpace,
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    itemCount: _expenseCategories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return AppGestureDetectorButton(
                        onTap: () => _getExpenses(
                          context: context,
                          index: index,
                          expenseCategory: _expenseCategories[index],
                        ),
                        child: BlocBuilder<PagingCubit, PagingState>(
                          builder: (context, state) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: _selectedColor(
                                    context: context,
                                    condition: state.currentIndex == index,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(1000.r),
                              ),
                              margin: EdgeInsetsDirectional.only(
                                end: index == _expenseCategories.length - 1
                                    ? 0
                                    : 10.r,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 5.r,
                              ),
                              child: Center(
                                child: Text(
                                  _expenseCategories[index].name(context),
                                  style: AppStyles.s12W500.copyWith(
                                    color: _selectedColor(
                                      context: context,
                                      condition: state.currentIndex == index,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          13.verticalSpace,
          const CustomDivider(),
          4.verticalSpace,
        ],
      ),
    );
  }
}
