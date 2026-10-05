import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/requests_repository.dart';
import 'branch_approve_or_reject_modification_state.dart';

@injectable
class BranchApproveOrRejectModificationCubit
    extends SafeCubit<BranchApproveOrRejectModificationState> {
  final RequestsRepository _requestsRepository;

  BranchApproveOrRejectModificationCubit(this._requestsRepository)
    : super(const BranchApproveOrRejectModificationInit());

  void approveModification({
    required String orderId,
    required String itemId,
  }) async {
    emit(const BranchApproveOrRejectModificationLoading());

    final result = await _requestsRepository.approveModification(
      orderId: orderId,
      itemId: itemId,
    );

    handle(
      result,
      success: (data) {
        emit(const BranchApproveOrRejectModificationSuccess());
      },
      failure: (failure) {
        emit(BranchApproveOrRejectModificationFailure(failure));
      },
    );
  }

  void rejectModification({
    required String orderId,
    required String itemId,
    required String reason,
  }) async {
    emit(const BranchApproveOrRejectModificationLoading());

    final result = await _requestsRepository.rejectModification(
      orderId: orderId,
      itemId: itemId,
      reason: reason,
    );

    handle(
      result,
      success: (data) {
        emit(const BranchApproveOrRejectModificationSuccess());
      },
      failure: (failure) {
        emit(BranchApproveOrRejectModificationFailure(failure));
      },
    );
  }
}
