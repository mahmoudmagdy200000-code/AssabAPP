import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/branch_manager_setting_and_aggregators_usecases.dart';
import 'branch_manager_my_account_details_state.dart';

@injectable
class BranchManagerMyAccountDetailsCubit
    extends SafeCubit<BranchManagerMyAccountDetailsState> {
  final GetBranchManagerMyAccountDetailsUseCase _getMyAccountDetailsUseCase;

  BranchManagerMyAccountDetailsCubit(this._getMyAccountDetailsUseCase)
    : super(const BranchManagerMyAccountDetailsInitial());

  Future<void> loadData() async {
    emit(const BranchManagerMyAccountDetailsLoading());

    final result = await _getMyAccountDetailsUseCase();
    handle(
      result,
      success: (data) => emit(BranchManagerMyAccountDetailsLoaded(data)),
      failure: (failure) => emit(BranchManagerMyAccountDetailsFailure(failure)),
    );
  }
}