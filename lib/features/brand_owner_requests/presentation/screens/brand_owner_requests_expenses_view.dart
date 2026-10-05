import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../branch_manager_expenses/data/models/expense_data_model.dart';
import '../../../branch_manager_expenses/domain/strategies/expense_category.dart';
import '../../../branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import '../../../branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_state.dart';
import '../../../branch_manager_expenses/presentation/widgets/expenses_history_empty_widget.dart';
import '../../../branch_manager_expenses/presentation/widgets/expenses_list_view.dart';

class BrandOwnerRequestsExpensesView extends StatefulWidget {
  const BrandOwnerRequestsExpensesView({super.key});

  @override
  State<BrandOwnerRequestsExpensesView> createState() =>
      _BrandOwnerRequestsExpensesViewState();
}

class _BrandOwnerRequestsExpensesViewState
    extends State<BrandOwnerRequestsExpensesView> {
  late final ScrollController _scrollController;

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
    return BlocBuilder<
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
          return const AppLoadingWidget();
        } else if (state is BranchManagerExpensesHistoryFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: _getAllExpenses,
          );
        } else if (state is BranchManagerExpensesHistorySuccess) {
          expenses.addAll(state.expenses.data);
          context
              .read<ValidationCubit>()
              .validateFieldAndStoreTypedValue<String>(
                fieldName: 'expensesCount',
                value: expenses.length.toString(),
                isValid: true,
              );
        }

        if (expenses.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => context
                .read<BranchManagerExpensesHistoryCubit>()
                .loadExpenses(type: const AllExpense()),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: ExpensesHistoryEmptyWidget(
                      expenseCategory: context
                          .read<BranchManagerExpensesHistoryCubit>()
                          .currentCategory,
                      showAddButton: false,
                      isExpanded: false,
                    ),
                  ),
                );
              },
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
              type: const AllExpense(),
            );
          },
          child: ExpensesListView(
            expenses: expenses,
            controller: _scrollController,
            onClickDraftExpense: () {},
            isExpanded: false,
            userTypeStrategy: BrandOwnerUserStrategy(),
            loadAllExpenses: true,
          ),
        );
      },
    );
  }
}
