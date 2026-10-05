import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../returns_management/data/repository/return_management_repository.dart';
import 'get_pending_escelations_state.dart';

@injectable
class GetPendingEscelationsCubit extends SafeCubit<GetPendingEscelationsState> {
  final ReturnManagementRepository _returnManagementRepository;

  GetPendingEscelationsCubit(this._returnManagementRepository)
    : super(const GetPendingEscelationsInit());

  Future<void> getInprogressEscelations() async {
    emit(const GetPendingEscelationsLoading());

    final result = await _returnManagementRepository.getInprogressReturns();

    handle(
      result,
      success: (returns) {
        emit(GetPendingEscelationsSuccess(returns));
      },
      failure: (failure) {
        emit(GetPendingEscelationsFailure(failure));
      },
    );
  }
}
