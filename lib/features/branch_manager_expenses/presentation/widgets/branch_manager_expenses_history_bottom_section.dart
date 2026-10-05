import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/expense_data_model.dart';
import 'expenses_history_empty_widget.dart';
import 'expenses_list_view.dart';

class BranchManagerExpensesHistoryBottomSection extends StatefulWidget {
  const BranchManagerExpensesHistoryBottomSection({super.key});

  @override
  State<BranchManagerExpensesHistoryBottomSection> createState() =>
      _BranchManagerExpensesHistoryBottomSectionState();
}

class _BranchManagerExpensesHistoryBottomSectionState
    extends State<BranchManagerExpensesHistoryBottomSection> {
  late final ScrollController _scrollController;
  int _selectedTab = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _getAllExpenses();
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300.h) {
      final cubit = context.read<BranchManagerExpensesHistoryCubit>();

      if (cubit.hasMore) {
        _getAllExpenses(loadMore: true);
      }
    }
  }

  void _getAllExpenses({bool loadMore = false}) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
      loadMore: loadMore,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollControllerListener);

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PagingCubit, PagingState>(
      listener: (context, state) {
        _selectedTab = state.currentIndex;
      },
      child:
          BlocBuilder<
            BranchManagerExpensesHistoryCubit,
            BranchManagerExpensesHistoryState
          >(
            buildWhen: (previous, current) =>
                (current is BranchManagerExpensesHistoryLoading) ||
                (current is BranchManagerExpensesHistoryFailure) ||
                (current is BranchManagerExpensesHistorySuccess),
            builder: (context, state) {
              final expenses = <ExpenseDataModel>[];

              if (state is BranchManagerExpensesHistoryLoading) {
                return const Expanded(child: AppLoadingWidget());
              } else if (state is BranchManagerExpensesHistoryFailure) {
                return Expanded(
                  child: AppFailureWidget(
                    failure: state.failure,
                    onRetry: _getAllExpenses,
                  ),
                );
              } else if (state is BranchManagerExpensesHistorySuccess) {
                expenses.addAll(state.expenses.data);
              }

              if (expenses.isEmpty) {
                return ExpensesHistoryEmptyWidget(
                  expenseCategory: context
                      .read<BranchManagerExpensesHistoryCubit>()
                      .currentCategory,
                );
              }

              return ExpensesListView(
                expenses: expenses,
                controller: _scrollController,
                userTypeStrategy: BranchManagerUserStrategy(),
                loadAllExpenses: _selectedTab == 0,
                selectedTab: _selectedTab,
              );
            },
          ),
    );
  }
}
