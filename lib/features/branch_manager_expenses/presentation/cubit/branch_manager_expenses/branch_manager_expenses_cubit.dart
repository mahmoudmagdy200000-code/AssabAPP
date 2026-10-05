import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_entity.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_summary_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/date_filter_model.dart';

part 'branch_manager_expenses_state.dart';

@injectable
class BranchManagerExpensesCubit extends SafeCubit<BranchManagerExpensesState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  BranchManagerExpensesCubit(this._branchManagerExpensesRepository)
    : super(const BranchManagerExpensesInitial()) {
    // _registerAllStrategies();
  }

  // void _registerAllStrategies() {
  //   ExpensesRegistry.register(
  //     ExpensesStrategiesKeys.quickCash.key,
  //     () => QuickCashExpensesStrategy(),
  //   );
  //   ExpensesRegistry.register(
  //     ExpensesStrategiesKeys.singleInvoice.key,
  //     () => SingleInvoiceExpensesStrategy(),
  //   );
  //   ExpensesRegistry.register(
  //     ExpensesStrategiesKeys.preApproval.key,
  //     () => PreApprovalExpensesStrategy(),
  //   );
  //   ExpensesRegistry.register(
  //     ExpensesStrategiesKeys.groupedInvoice.key,
  //     () => GroupedInvoiceExpensesStrategy(),
  //   );
  // }

  Future<void> getExpensesSummary({required DateFilterModel model}) async {
    emit(const BranchManagerExpensesSummaryLoading());

    final result = await _branchManagerExpensesRepository.getExpensesSummary(
      model: model,
    );

    handle(
      result,
      failure: (failure) => emit(BranchManagerExpensesSummaryFailure(failure)),
      success: (expensesSummary) =>
          emit(BranchManagerGetExpensesSummarySuccess(expensesSummary)),
    );
  }

  Future<void> getRecentExpenses() async {
    emit(const BranchManagerRecentExpensesLoading());

    final result = await _branchManagerExpensesRepository.getExpensesRecent();

    handle(
      result,
      failure: (failure) => emit(BranchManagerRecentExpensesFailure(failure)),
      success: (recentExpenses) =>
          emit(BranchManagerGetRecentExpensesSuccess(recentExpenses)),
    );
  }
}
