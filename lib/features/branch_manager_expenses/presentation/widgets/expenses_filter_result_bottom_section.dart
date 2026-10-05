import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expenses_filter/expenses_filter_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expenses_search/expenses_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/expense_data_model.dart';
import '../../domain/strategies/expense_category.dart';
import '../cubit/expenses_search/expenses_search_cubit.dart';
import 'expenses_history_empty_widget.dart';
import 'expenses_list_view.dart';

class ExpensesFilterResultBottomSection extends StatefulWidget {
  const ExpensesFilterResultBottomSection({super.key});

  @override
  State<ExpensesFilterResultBottomSection> createState() =>
      _ExpensesFilterResultBottomSectionState();
}

class _ExpensesFilterResultBottomSectionState
    extends State<ExpensesFilterResultBottomSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _getSearchExpenses();
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300.h) {
      final cubit = context.read<ExpensesSearchCubit>();

      if (cubit.paginator.hasMore) {
        _getSearchExpenses(loadMore: true);
      }
    }
  }

  void _getSearchExpenses({bool loadMore = false}) {
    final expensesFilterCubit = context.read<ExpensesFilterCubit>();

    context.read<ExpensesSearchCubit>().getSearchExpenses(
      loadMore: loadMore,
      status: expensesFilterCubit.selectedStatus,
      type: expensesFilterCubit.selectedType,
      period: expensesFilterCubit.selectedSortBy,
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
    return BlocBuilder<ExpensesSearchCubit, ExpensesSearchState>(
      builder: (context, state) {
        final expenses = <ExpenseDataModel>[];

        if (state is ExpensesSearchLoading) {
          return const Expanded(child: Center(child: AppLoadingWidget()));
        } else if (state is ExpensesSearchFailure) {
          return Expanded(child: AppFailureWidget(failure: state.failure));
        } else if (state is ExpensesSearchSuccess) {
          expenses.addAll(state.expenses.data);
        }

        if (expenses.isEmpty) {
          return const ExpensesHistoryEmptyWidget(
            expenseCategory: AllExpense(),
            showAddButton: false,
          );
        }

        return ExpensesListView(
          expenses: expenses,
          controller: _scrollController,
          userTypeStrategy: BranchManagerUserStrategy(),
        );
      },
    );
  }
}
