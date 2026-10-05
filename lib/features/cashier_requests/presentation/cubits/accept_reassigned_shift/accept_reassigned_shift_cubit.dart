import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../../../core/helpers/safe_cubit.dart';

part 'accept_reassigned_shift_state.dart';

@injectable
class AcceptReassignedShiftCubit extends SafeCubit<AcceptReassignedShiftState> {
  AcceptReassignedShiftCubit(this._repositoryImp)
    : super(const AcceptReassignedShiftState());

  final RequestsRepository _repositoryImp;

  Future<void> acceptReassignedShift({required String shiftId}) async {
    emit(
      state.copyWith(loadingShiftId: shiftId, failure: null, success: false),
    );

    final result = await _repositoryImp.acceptReassignedShift(shiftId: shiftId);

    handle(
      result,
      failure: (failure) => emit(
        state.copyWith(
          loadingShiftId: null,
          errorShiftId: shiftId, // Set which shift caused the error
          failure: failure,
        ),
      ),
      success: (_) => emit(state.copyWith(loadingShiftId: null, success: true)),
    );
  }
}
