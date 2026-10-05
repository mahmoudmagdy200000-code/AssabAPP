import 'package:assab/features/brand_owner_requests/data/repositories/brand_owner_requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../../brand_owner_home/data/repository/brand_owner_home_repository.dart';
import 'branch_owner_approve_reject_state.dart';

@injectable
class BranchOwnerApproveRejectCubit
    extends SafeCubit<BranchOwnerApproveRejectState> {
  final BrandOwnerRequestsRepository _repository;
  final BrandOwnerHomeRepository _brandOwnerHomeRepository;
  BranchOwnerApproveRejectCubit(
    this._repository,
    this._brandOwnerHomeRepository,
  )
    : super(const BranchOwnerApproveRejectInitial());

  Future<void> approveExpense({
    required String expenseId,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _repository.approveExpense(expenseId: expenseId);

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectExpenseSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> rejectExpense({
    required String expenseId,
    required String reason,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _repository.rejectExpense(
      expenseId: expenseId,
      reason: reason,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectExpenseSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> approveCustodyRequest({
    required String requestId,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _repository.approveCustodyRequest(
      requestId: requestId,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectCustodyRequestSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> rejectCustodyRequest({
    required String requestId,
    required String reason,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _repository.rejectCustodyRequest(
      requestId: requestId,
      reason: reason,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectCustodyRequestSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> approveSalesTransfer({
    required String salesTransferId,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _repository.approveSalesTransfer(
      salesTransferId: salesTransferId,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectSalesTransferSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> rejectSalesTransfer({
    required String salesTransferId,
    required String reason,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _repository.rejectSalesTransfer(
      salesTransferId: salesTransferId,
      reason: reason,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectSalesTransferSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> approveEscalation({
    required String returnId,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _brandOwnerHomeRepository.approveReturnEscalation(
      returnId: returnId,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectEscalationSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }

  Future<void> rejectEscalation({
    required String returnId,
    void Function()? onSuccess,
  }) async {
    emit(const BranchOwnerApproveRejectLoading());

    final result = await _brandOwnerHomeRepository.rejectReturnEscalation(
      returnId: returnId,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchOwnerApproveRejectEscalationSuccess());
        onSuccess?.call();
      },
      failure: (failure) => emit(BranchOwnerApproveRejectFailure(failure)),
    );
  }
}
