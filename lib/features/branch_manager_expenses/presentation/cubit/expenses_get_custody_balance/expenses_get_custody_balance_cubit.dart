import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';
import 'expenses_get_custody_balance_state.dart';

@injectable
class ExpensesGetCustodyBalanceCubit
    extends SafeCubit<ExpensesGetCustodyBalanceState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  ExpensesGetCustodyBalanceCubit(this._branchManagerExpensesRepository)
    : super(const ExpensesGetCustodyBalanceInit());

  Future<void> getCustodyBalance() async {
    emit(const ExpensesGetCustodyBalanceLoading());

    final result = await _branchManagerExpensesRepository.getCustodyBalance();

    handle(
      result,
      failure: (failure) => emit(ExpensesGetCustodyBalanceFailure(failure)),
      success: (balance) =>
          emit(ExpensesGetCustodyBalanceSuccess(balance.balance)),
    );
  }
}
