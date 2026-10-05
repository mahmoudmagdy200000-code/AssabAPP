import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/date_filter_model.dart';
import '../cubit/branch_manager_expenses/branch_manager_expenses_cubit.dart';
import 'branch_manager_expenses_bottom_section.dart';
import 'branch_manager_expenses_top_section.dart';
import 'expenses_empty_widget.dart';

class BranchManagerExpensesBody extends StatefulWidget {
  const BranchManagerExpensesBody({super.key});

  @override
  State<BranchManagerExpensesBody> createState() =>
      _BranchManagerExpensesBodyState();
}

class _BranchManagerExpensesBodyState extends State<BranchManagerExpensesBody> {
  @override
  void initState() {
    _getRecentExpenses();
    super.initState();
  }

  Future<void> _getRecentExpenses() async {
    await context.read<BranchManagerExpensesCubit>().getRecentExpenses();
  }

  Future<void> _getExpensesSummary() async {
    final dateManagementCubit = context.read<DateManagementCubit>();

    await context.read<BranchManagerExpensesCubit>().getExpensesSummary(
      model: DateFilterModel(
        month: dateManagementCubit.selectedMonthNumber,
        year: dateManagementCubit.selectedYear,
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.wait([_getRecentExpenses(), _getExpensesSummary()]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: AppPaddingWidget(
          bottom: 0,
          child: RefreshIndicator(
            onRefresh: () async => await _refreshData(),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: BranchManagerExpensesTopSection(),
                ),
                SliverToBoxAdapter(child: 8.verticalSpace),
                BlocBuilder<
                  BranchManagerExpensesCubit,
                  BranchManagerExpensesState
                >(
                  buildWhen: (previous, current) =>
                      current is BranchManagerRecentExpensesLoading ||
                      current is BranchManagerGetRecentExpensesSuccess ||
                      current is BranchManagerRecentExpensesFailure,
                  builder: (context, state) {
                    final List<ExpensesEntity> date = [];

                    if (state is BranchManagerRecentExpensesLoading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppLoadingWidget(),
                      );
                    } else if (state is BranchManagerRecentExpensesFailure) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppFailureWidget(
                          failure: state.failure,
                          onRetry: () => _getRecentExpenses(),
                        ),
                      );
                    } else if (state is BranchManagerGetRecentExpensesSuccess) {
                      date.addAll(state.recentExpenses);

                      if (date.isEmpty) {
                        return SliverToBoxAdapter(
                          child: ExpensesEmptyWidget(
                            icon: AppAssets.expensesEmptyPNG,
                            title: context.tr.noExpensesYet,
                            desc: context.tr.noExpensesYetDesc,
                          ),
                        );
                      }
                    }

                    return BranchManagerExpensesBottomSection(
                      recentExpenses: date,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
