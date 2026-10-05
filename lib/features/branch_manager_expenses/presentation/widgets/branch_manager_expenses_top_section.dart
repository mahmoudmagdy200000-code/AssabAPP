import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_summary_entity.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/branch_manager_expenses/branch_manager_expenses_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/see_expenses_history_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/cubits/data_management/date_management/date_management_state.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/month_and_year_button_dropdown.dart';
import '../../../../core/widgets/month_and_year_button_dropdown_widget.dart';
import '../../../../core/widgets/price_label.dart';
import '../../data/models/date_filter_model.dart';
import 'expenses_header_name_with_price.dart';

class BranchManagerExpensesTopSection extends StatefulWidget {
  const BranchManagerExpensesTopSection({super.key});

  @override
  State<BranchManagerExpensesTopSection> createState() =>
      _BranchManagerExpensesTopSectionState();
}

class _BranchManagerExpensesTopSectionState
    extends State<BranchManagerExpensesTopSection> {
  @override
  void initState() {
    _getExpensesSummary(context);
    super.initState();
  }

  void _monthPicker(BuildContext context) {
    const months = DateManagementCubit.shortMonths;
    final cubit = context.read<DateManagementCubit>();

    AppBottomSheet.showModal(context, (context) {
      return MonthAndYearButtonDropdownWidget(
        text: months,
        onTap: (index) => cubit.selectMonth(months[index]),
        selectedText: cubit.state.selectedMonth,
      );
    });
  }

  void _yearPicker(BuildContext context) {
    final years = DateManagementCubit.years;
    final cubit = context.read<DateManagementCubit>();

    AppBottomSheet.showModal(context, (context) {
      return MonthAndYearButtonDropdownWidget(
        text: years,
        onTap: (index) => cubit.selectYear(years[index]),
        selectedText: cubit.state.selectedYear.toString(),
      );
    });
  }

  void _getExpensesSummary(BuildContext context) {
    final dateManagementCubit = context.read<DateManagementCubit>();

    context.read<BranchManagerExpensesCubit>().getExpensesSummary(
      model: DateFilterModel(
        month: dateManagementCubit.selectedMonthNumber,
        year: dateManagementCubit.selectedYear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<DateManagementCubit, DateManagementState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: MonthAndYearButtonDropdown(
                    text: state.selectedMonth,
                    onClick: () => _monthPicker(context),
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: MonthAndYearButtonDropdown(
                    text: state.selectedYear.toString(),
                    onClick: () => _yearPicker(context),
                  ),
                ),
              ],
            );
          },
        ),
        17.verticalSpace,
        BlocBuilder<BranchManagerExpensesCubit, BranchManagerExpensesState>(
          buildWhen: (previous, current) =>
              current is BranchManagerExpensesSummaryLoading ||
              current is BranchManagerGetExpensesSummarySuccess ||
              current is BranchManagerExpensesSummaryFailure,
          builder: (context, state) {
            ExpensesSummaryEntity date = ExpensesSummaryEntity.empty();

            if (state is BranchManagerExpensesSummaryLoading) {
              return SizedBox(
                width: double.infinity,
                height: 200.h,
                child: const AppLoadingWidget(),
              );
            } else if (state is BranchManagerExpensesSummaryFailure) {
              return AppFailureWidget(
                failure: state.failure,
                onRetry: () => _getExpensesSummary(context),
              );
            } else if (state is BranchManagerGetExpensesSummarySuccess) {
              date = state.expensesSummary;
            }

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.r,
                      vertical: 12.r,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr.totalExpenses,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        9.verticalSpace,
                        PriceLabel(amount: date.totalAmount.toString()),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  Column(
                    children: [
                      ExpensesHeaderNameWithPrice(
                        amount: date.quickCashTotal.toString(),
                        title: context.tr.quickCashExpense,
                        lineColor: AppColors.green,
                      ),
                      ExpensesHeaderNameWithPrice(
                        amount: date.singleInvoiceTotal.toString(),
                        title: context.tr.singleInvoice,
                        lineColor: AppColors.orange,
                      ),
                      ExpensesHeaderNameWithPrice(
                        amount: date.groupedInvoiceTotal.toString(),
                        title: context.tr.groupedInvoices,
                        lineColor: AppColors.errorLight,
                      ),
                      ExpensesHeaderNameWithPrice(
                        amount: date.preApprovalTotal.toString(),
                        title: context.tr.preApprovalRequest,
                        lineColor: AppColors.yellow,
                      ),
                      12.verticalSpace,
                      const SeeExpensesHistoryButton(),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
