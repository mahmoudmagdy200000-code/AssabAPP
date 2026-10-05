import 'package:assab/core/errors/api_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/requests_repository.dart';

part 'approve_or_reject_responsibility_state.dart';

@injectable
class ApproveOrRejectResponsibilityCubit
    extends SafeCubit<ApproveOrRejectResponsibilityState> {
  final RequestsRepository _requestsRepository;
  ApproveOrRejectResponsibilityCubit(this._requestsRepository)
    : super(ApproveOrRejectResponsibilityInitial());

  Future<void> approveResponsibility({required String shiftId}) async {
    emit(ApproveOrRejectResponsibilityLoading());

    final result = await _requestsRepository.approveResponsibility(
      shiftId: shiftId,
    );

    handle(
      result,
      failure: (failure) => emit(ApproveOrRejectResponsibilityFailed(failure)),
      success: (success) => emit(ApproveOrRejectResponsibilitySuccess()),
    );
  }

  Future<void> rejectResponsibility({
    required String shiftId,
    required String managerComment,
  }) async {
    emit(ApproveOrRejectResponsibilityLoading());

    final result = await _requestsRepository.rejectResponsibility(
      shiftId: shiftId,
      managerComment: managerComment,
    );

    handle(
      result,
      failure: (failure) => emit(ApproveOrRejectResponsibilityFailed(failure)),
      success: (success) => emit(ApproveOrRejectResponsibilitySuccess()),
    );
  }
}
