import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/return_management_repository.dart';
import 'get_returns_state.dart';

@injectable
class GetReturnsCubit extends SafeCubit<GetReturnsState> {
  final ReturnManagementRepository _returnManagementRepository;

  GetReturnsCubit(this._returnManagementRepository)
    : super(const GetReturnsInit());

  Future<void> getInprogressReturns() async {
    emit(const GetReturnsLoading());

    final result = await _returnManagementRepository.getInprogressReturns();

    handle(
      result,
      success: (returns) {
        emit(GetReturnsSuccess(returns));
      },
      failure: (failure) {
        emit(GetReturnsFailure(failure));
      },
    );
  }

  Future<void> getCompletedReturns() async {
    emit(const GetReturnsLoading());

    final result = await _returnManagementRepository.getCompletedReturns();

    handle(
      result,
      success: (returns) {
        emit(GetReturnsSuccess(returns));
      },
      failure: (failure) {
        emit(GetReturnsFailure(failure));
      },
    );
  }
}
