import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_personal_balance_transactions_state.dart';

@injectable
class GetPersonalBalanceTransactionsCubit
    extends SafeCubit<GetPersonalBalanceTransactionsState> {
  final CustodyRepository _custodyRepository;

  GetPersonalBalanceTransactionsCubit(this._custodyRepository)
    : super(const GetPersonalBalanceTransactionsInit());

  Future<void> getPersonalBalanceTransactions({
    String? month,
    String? year,
  }) async {
    emit(const GetPersonalBalanceTransactionsLoading());

    final result = await _custodyRepository.getPersonalBalanceTransactions(
      month: month,
      year: year,
    );

    handle(
      result,
      success: (response) {
        emit(GetPersonalBalanceTransactionsSuccess(response));
      },
      failure: (failure) {
        emit(GetPersonalBalanceTransactionsFailure(failure));
      },
    );
  }
}
