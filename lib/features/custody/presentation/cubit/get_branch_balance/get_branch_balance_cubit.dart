import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_branch_balance_state.dart';

@injectable
class GetBranchBalanceCubit extends SafeCubit<GetBranchBalanceState> {
  final CustodyRepository _custodyRepository;

  GetBranchBalanceCubit(this._custodyRepository)
    : super(const GetBranchBalanceInit());

  Future<void> getBranchBalance() async {
    emit(const GetBranchBalanceLoading());

    final result = await _custodyRepository.getBranchBalance();

    handle(
      result,
      success: (balance) {
        emit(GetBranchBalanceSuccess(balance));
      },
      failure: (failure) {
        emit(GetBranchBalanceFailure(failure));
      },
    );
  }
}
