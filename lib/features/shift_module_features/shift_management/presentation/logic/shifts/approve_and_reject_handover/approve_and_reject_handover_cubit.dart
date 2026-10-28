import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:flutter/cupertino.dart';
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
  /// Fails closed if the role is unauthorized/unknown, or if physical counted cash does
  /// not match the requested handover amount under CASH-09.
  Future<void> confirmHandoverReceipt({
    required String shiftId,
    required String confirmedAmount,
    UserType? actorRole,
    String? comment,
    String? receivingShiftId,
    String? transferAttemptId,
    double? expectedAmount,
  }) async {
    final effectiveRole = actorRole ??
        UserTypeService.selectedUserType ??
        UserTypeService.getSavedUserType();

    if (effectiveRole != UserType.cashier &&
        effectiveRole != UserType.branchManager) {
      emit(HandoverActionFailure(AuthFailure(
        error: LocalErrorModel(
          message:
              'Unauthorized: Valid authenticated cashier or branch manager role required to confirm handover receipt',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_shield,
        statusCode: 403,
        stackTrace: StackTrace.empty,
      )));
      return;
    }

    if (expectedAmount != null) {
      final parsed =
          double.tryParse(confirmedAmount.replaceAll(',', '').trim());
      if (parsed == null || (parsed - expectedAmount).abs() > 0.001) {
        emit(HandoverActionFailure(ValidationFailure(
          error: LocalErrorModel(
            message:
                'Receipt amount mismatch (CASH-09): Counted amount does not match handover amount. Request must be rejected for correction.',
            errors: null,
          ),
          icon: CupertinoIcons.exclamationmark_triangle,
          statusCode: 422,
          stackTrace: StackTrace.empty,
        )));
        return;
      }
    }

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
    final effectiveRole = actorRole ??
        UserTypeService.selectedUserType ??
        UserTypeService.getSavedUserType();

    if (effectiveRole != UserType.cashier &&
        effectiveRole != UserType.branchManager) {
      emit(HandoverActionFailure(AuthFailure(
        error: LocalErrorModel(
          message:
              'Unauthorized: Valid authenticated cashier or branch manager role required to reject handover',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_shield,
        statusCode: 403,
        stackTrace: StackTrace.empty,
      )));
      return;
    }

    emit(HandoverActionLoading());

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
