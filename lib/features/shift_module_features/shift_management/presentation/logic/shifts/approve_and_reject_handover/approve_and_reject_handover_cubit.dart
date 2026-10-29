import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/errors/api_failure.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/repository/shift_management_repository_imp.dart';

part 'approve_and_reject_handover_state.dart';

@injectable
class ApproveAndRejectHandoverCubit
    extends SafeCubit<ApproveAndRejectHandoverState>
    with UserIntentOwner {
  ApproveAndRejectHandoverCubit(this._repositoryImp)
    : super(ApproveAndRejectHandoverInitial());

  final ShiftManagementRepositoryImp _repositoryImp;

  /// Runs one financial submission as ONE user intent (F-04). Returns null and
  /// emits a failure when a different submission is blocked until the unknown
  /// outcome of the previous one is reconciled.
  Future<T?> _asUserIntent<T>(String fingerprint, Future<T> Function() op) async {
    final result = await runUserIntent<T>(fingerprint, op);
    if (result == null) {
      emit(HandoverActionFailure(ValidationFailure(
        error: LocalErrorModel(
          message:
              'The previous submission has an unknown outcome. Refresh and verify its status before submitting again.',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_triangle,
        statusCode: 409,
        stackTrace: StackTrace.empty,
      )));
    }
    return result;
  }

  Future<void> approveHandover({
    required String shiftId,
    String? confirmedAmount,
    String? managerComment,
    String? transferAttemptId,
  }) async {
    final normalized = CurrencyNormalizer.normalizeSarInput(confirmedAmount);
    if (normalized == null) {
      emit(HandoverActionFailure(ValidationFailure(
        error: LocalErrorModel(
          message:
              'Confirmed amount is required and must be a valid non-negative number.',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_triangle,
        statusCode: 422,
        stackTrace: StackTrace.empty,
      )));
      return;
    }

    emit(HandoverActionLoading());

    final result = await _asUserIntent(
      'approve:$shiftId:$normalized:${managerComment ?? ''}',
      () => _repositoryImp.approveHandover(
        shiftId: shiftId,
        confirmedAmount: normalized,
        managerComment: managerComment,
        transferAttemptId: transferAttemptId,
      ),
    );
    if (result == null) return;

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
    final normalized = CurrencyNormalizer.normalizeSarInput(confirmedAmount);
    if (normalized == null) {
      emit(HandoverActionFailure(ValidationFailure(
        error: LocalErrorModel(
          message:
              'Confirmed amount is required and must be a valid non-negative number.',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_triangle,
        statusCode: 422,
        stackTrace: StackTrace.empty,
      )));
      return;
    }

    emit(HandoverActionLoading());

    final result = await _asUserIntent(
      'accept:$shiftId:$normalized:${comment ?? ''}',
      () => _repositoryImp.acceptCashierHandover(
      shiftId: shiftId,
      confirmedAmount: normalized,
      receivingShiftId: receivingShiftId,
      transferAttemptId: transferAttemptId,
      comment: comment,
      ),
    );
    if (result == null) return;

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

    final result = await _asUserIntent(
      'cashier-reject:$shiftId:${rejectionReason ?? ''}:${correctionReason ?? ''}:${confirmedAmount ?? ''}:${managerComment ?? ''}',
      () => _repositoryImp.rejectCashierHandover(
        shiftId: shiftId,
        rejectionReason: rejectionReason,
        correctionReason: correctionReason,
        confirmedAmount: confirmedAmount,
        transferAttemptId: transferAttemptId,
        managerComment: managerComment,
      ),
    );
    if (result == null) return;

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

    final parsed = CurrencyNormalizer.parseSarAmount(confirmedAmount);
    if (parsed == null) {
      emit(HandoverActionFailure(ValidationFailure(
        error: LocalErrorModel(
          message:
              'Confirmed amount is required and must be a valid non-negative number.',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_triangle,
        statusCode: 422,
        stackTrace: StackTrace.empty,
      )));
      return;
    }

    if (expectedAmount == null) {
      emit(HandoverActionFailure(ValidationFailure(
        error: LocalErrorModel(
          message:
              'Handover amount unavailable: cannot confirm receipt without the authoritative handover amount.',
          errors: null,
        ),
        icon: CupertinoIcons.exclamationmark_triangle,
        statusCode: 422,
        stackTrace: StackTrace.empty,
      )));
      return;
    }
    {
      if (!CurrencyNormalizer.areAmountsEqual(parsed, expectedAmount)) {
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

    final normalizedConfirmed = CurrencyNormalizer.formatSar(parsed);

    if (effectiveRole == UserType.cashier) {
      await acceptCashierHandover(
        shiftId: shiftId,
        confirmedAmount: normalizedConfirmed,
        receivingShiftId: receivingShiftId,
        transferAttemptId: transferAttemptId,
        comment: comment,
      );
    } else {
      await approveHandover(
        shiftId: shiftId,
        confirmedAmount: normalizedConfirmed,
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

    final validatedRole = effectiveRole!;
    emit(HandoverActionLoading());

    final result = await _asUserIntent(
      'reject:${validatedRole.name}:$shiftId:$managerComment',
      () => validatedRole == UserType.cashier
          ? _repositoryImp.rejectCashierHandover(
              shiftId: shiftId,
              rejectionReason: managerComment,
            )
          : _repositoryImp.rejectHandover(
              shiftId: shiftId,
              managerComment: managerComment,
            ),
    );
    if (result == null) return;

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

    final result = await _asUserIntent(
      'correction:$shiftId:${managerComment ?? ''}',
      () => _repositoryImp.requestHandoverCorrection(
        shiftId: shiftId,
        managerComment: managerComment,
      ),
    );
    if (result == null) return;

    handle(
      result,
      failure: (failure) => emit(HandoverActionFailure(failure)),
      success: (success) => emit(HandoverActionSuccess()),
    );
  }
}
