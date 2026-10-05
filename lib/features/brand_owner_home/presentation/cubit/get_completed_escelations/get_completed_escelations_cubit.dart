import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../returns_management/data/repository/return_management_repository.dart';
import 'get_completed_escelations_state.dart';

@injectable
class GetCompletedEscelationsCubit
    extends SafeCubit<GetCompletedEscelationsState> {
  final ReturnManagementRepository _returnManagementRepository;

  GetCompletedEscelationsCubit(this._returnManagementRepository)
    : super(const GetCompletedEscelationsInit());

  Future<void> getCompletedEscelations() async {
    emit(const GetCompletedEscelationsLoading());

    final result = await _returnManagementRepository.getCompletedReturns();

    handle(
      result,
      success: (returns) {
        emit(GetCompletedEscelationsSuccess(returns));
      },
      failure: (failure) {
        emit(GetCompletedEscelationsFailure(failure));
      },
    );
  }
}
