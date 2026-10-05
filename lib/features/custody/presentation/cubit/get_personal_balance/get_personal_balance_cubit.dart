import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_personal_balance_state.dart';

@injectable
class GetPersonalBalanceCubit extends SafeCubit<GetPersonalBalanceState> {
  final CustodyRepository _custodyRepository;

  GetPersonalBalanceCubit(this._custodyRepository)
    : super(const GetPersonalBalanceInit());

  Future<void> getPersonalBalance({String? month, String? year}) async {
    emit(const GetPersonalBalanceLoading());

    final result = await _custodyRepository.getPersonalBalance(
      month: month,
      year: year,
    );

    handle(
      result,
      success: (balance) {
        emit(GetPersonalBalanceSuccess(balance));
      },
      failure: (failure) {
        emit(GetPersonalBalanceFailure(failure));
      },
    );
  }
}
