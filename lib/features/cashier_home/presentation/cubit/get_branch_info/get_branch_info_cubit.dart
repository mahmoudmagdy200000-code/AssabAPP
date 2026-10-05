import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/cashier_home_repository.dart';
import 'get_branch_info_state.dart';

@injectable
class GetBranchInfoCubit extends SafeCubit<GetBranchInfoState> {
  final CashierHomeRepository _repository;

  GetBranchInfoCubit(this._repository) : super(const GetBranchInfoInit());

  Future<void> getBranchInfo() async {
    emit(const GetBranchInfoLoading());

    final result = await _repository.getBranchInfo();

    handle(
      result,
      failure: (failure) => emit(GetBranchInfoFailure(failure)),
      success: (response) => emit(GetBranchInfoSuccess(response)),
    );
  }
}
