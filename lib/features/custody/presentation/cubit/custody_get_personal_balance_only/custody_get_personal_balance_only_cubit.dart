import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'custody_get_personal_balance_only_state.dart';

@injectable
class CustodyGetPersonalBalanceOnlyCubit
    extends SafeCubit<CustodyGetPersonalBalanceOnlyState> {
  final CustodyRepository _custodyRepository;

  CustodyGetPersonalBalanceOnlyCubit(this._custodyRepository)
    : super(const CustodyGetPersonalBalanceOnlyInit());

  void getPersonalBalanceOnly() async {
    emit(const CustodyGetPersonalBalanceOnlyLoading());

    final result = await _custodyRepository.getPersonalBalanceOnly();

    handle(
      result,
      success: (balance) {
        emit(CustodyGetPersonalBalanceOnlySuccess(balance.personalBalance));
      },
      failure: (failure) {
        emit(CustodyGetPersonalBalanceOnlyFailure(failure));
      },
    );
  }
}
