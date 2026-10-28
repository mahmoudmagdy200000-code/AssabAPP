import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

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
    String? confirmedAmount,
    String? managerComment,
    String? transferAttemptId,
  }) async {
    emit(HandoverActionLoading());

    final result = await _repositoryImp.approveHandover(
      shiftId: shiftId,
      confirmedAmount: confirmedAmount,
      managerComment: managerComment,
      transferAttemptId: transferAttemptId,
    );

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }

  Future<void> acceptCashierHandover({
    required String shiftId,
    required String confirmedAmount,
    String? receivingShiftId,
    String? transferAttemptId,
    String? comment,
  }) async {
    emit(HandoverActionLoading());

    final result = await _repositoryImp.acceptCashierHandover(
      shiftId: shiftId,
      confirmedAmount: confirmedAmount,
      receivingShiftId: receivingShiftId,
      transferAttemptId: transferAttemptId,
      comment: comment,
    );

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }

  Future<void> rejectCashierHandover({
    required String shiftId,
    String? rejectionReason,
    String? correctionReason,
    String? confirmedAmount,
    String? transferAttemptId,
    String? managerComment,
  }) async {
    emit(HandoverActionLoading());

    final result = await _repositoryImp.rejectCashierHandover(
      shiftId: shiftId,
      rejectionReason: rejectionReason,
      correctionReason: correctionReason,
      confirmedAmount: confirmedAmount,
      transferAttemptId: transferAttemptId,
      managerComment: managerComment,
    );

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }

  /// Unified confirmation dispatch respecting the authenticated actor's validated role.
  Future<void> confirmHandoverReceipt({
    required String shiftId,
    required String confirmedAmount,
    UserType? actorRole,
    String? comment,
    String? receivingShiftId,
    String? transferAttemptId,
  }) async {
    final effectiveRole = actorRole ??
        UserTypeService.selectedUserType ??
        UserTypeService.getSavedUserType();

    if (effectiveRole == UserType.cashier) {
      await acceptCashierHandover(
        shiftId: shiftId,
        confirmedAmount: confirmedAmount,
        receivingShiftId: receivingShiftId,
        transferAttemptId: transferAttemptId,
        comment: comment,
      );
    } else {
      await approveHandover(
        shiftId: shiftId,
        confirmedAmount: confirmedAmount,
        managerComment: comment,
        transferAttemptId: transferAttemptId,
      );
    }
  }

  Future<void> rejectHandover({
    required String shiftId,
    required String managerComment,
    UserType? actorRole,
  }) async {
    emit(HandoverActionLoading());

    final effectiveRole = actorRole ??
        UserTypeService.selectedUserType ??
        UserTypeService.getSavedUserType();

    final result = effectiveRole == UserType.cashier
        ? await _repositoryImp.rejectCashierHandover(
            shiftId: shiftId,
            rejectionReason: managerComment,
          )
        : await _repositoryImp.rejectHandover(
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