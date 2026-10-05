import 'package:assab/features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/expenses_strategy.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'expense_details_state.dart';

@injectable
class ExpenseDetailsCubit extends SafeCubit<ExpenseDetailsState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  ExpenseDetailsCubit(this._branchManagerExpensesRepository)
    : super(ExpenseDetailsInitial());

  void getExpenseDetails({
    required String id,
    required ExpensesStrategy strategy,
  }) {
    switch (strategy) {
      case QuickCashExpensesStrategy():
        getQuickCashExpensesDetails(id: id);
      case SingleInvoiceExpensesStrategy():
        getSingleInvoiceExpensesDetails(id: id);
      case PreApprovalExpensesStrategy():
        getPreApprovalExpensesDetails(id: id);
      case GroupedInvoiceExpensesStrategy():
        getGroupedInvoiceExpensesDetails(id: id);
    }
  }

  void getQuickCashExpensesDetails({required String id}) async {
    emit(ExpenseDetailsLoading());

    final result = await _branchManagerExpensesRepository
        .getQuickCashExpensesDetails(id: id);

    handle(
      result,
      failure: (failure) => emit(ExpenseDetailsFailure(failure)),
      success: (success) => emit(ExpenseQuickCashDetailsSuccess(success)),
    );
  }

  void getSingleInvoiceExpensesDetails({required String id}) async {
    emit(ExpenseDetailsLoading());

    final result = await _branchManagerExpensesRepository
        .getSingleInvoiceExpensesDetails(id: id);

    handle(
      result,
      failure: (failure) => emit(ExpenseDetailsFailure(failure)),
      success: (success) => emit(ExpenseSingleInvoiceDetailsSuccess(success)),
    );
  }

  void getPreApprovalExpensesDetails({required String id}) async {
    emit(ExpenseDetailsLoading());

    final result = await _branchManagerExpensesRepository
        .getPreApprovalExpensesDetails(id: id);

    handle(
      result,
      failure: (failure) => emit(ExpenseDetailsFailure(failure)),
      success: (success) => emit(ExpensePreApprovalDetailsSuccess(success)),
    );
  }

  void getGroupedInvoiceExpensesDetails({required String id}) async {
    emit(ExpenseDetailsLoading());

    final result = await _branchManagerExpensesRepository
        .getGroupedInvoiceExpensesDetails(id: id);

    handle(
      result,
      failure: (failure) => emit(ExpenseDetailsFailure(failure)),
      success: (success) => emit(ExpenseGroupedInvoiceDetailsSuccess(success)),
    );
  }
}
