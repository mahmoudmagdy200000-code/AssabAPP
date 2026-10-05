import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/errors/api_failure.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/repository/shift_management_repository_imp.dart';

part 'approve_and_reject_handover_state.dart';

@injectable
class ApproveAndRejectHandoverCubit
    extends SafeCubit<ApproveAndRejectHandoverState> {
  ApproveAndRejectHandoverCubit(this._repositoryImp)
    : super(ApproveAndRejectHandoverInitial());

  final ShiftManagementRepositoryImp _repositoryImp;

  Future<void> approveHandover({
    required String shiftId,
    String? managerComment,
  }) async {
    emit(HandoverActionLoading());

    final result = await _repositoryImp.approveHandover(
      shiftId: shiftId,
      managerComment: managerComment,
    );

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }

  Future<void> rejectHandover({
    required String shiftId,
    required String managerComment,
  }) async {
    emit(HandoverActionLoading());

    final result = await _repositoryImp.rejectHandover(
      shiftId: shiftId,
      managerComment: managerComment,
    );

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }

  Future<void> requestHandoverCorrection({
    required String shiftId,
    String? managerComment,
  }) async {
    emit(HandoverActionLoading());

    final result = await _repositoryImp.requestHandoverCorrection(
      shiftId: shiftId,
      managerComment: managerComment,
    );

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }
}
