import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_branch_balance_transactions_state.dart';

@injectable
class GetBranchBalanceTransactionsCubit
    extends SafeCubit<GetBranchBalanceTransactionsState> {
  final CustodyRepository _custodyRepository;

  GetBranchBalanceTransactionsCubit(this._custodyRepository)
    : super(const GetBranchBalanceTransactionsInit());

  Future<void> getBranchBalanceTransactions({
    String? status,
    String? timePeriod,
  }) async {
    emit(const GetBranchBalanceTransactionsLoading());

    final result = await _custodyRepository.getBranchTransactions(
      status: status,
      timePeriod: timePeriod,
    );

    handle(
      result,
      success: (response) {
        emit(GetBranchBalanceTransactionsSuccess(response));
      },
      failure: (failure) {
        emit(GetBranchBalanceTransactionsFailure(failure));
      },
    );
  }
}
