import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/requests_repository.dart';
import 'branch_get_cancel_reason_state.dart';

@injectable
class BranchGetCancelReasonCubit extends SafeCubit<BranchGetCancelReasonState> {
  final RequestsRepository _requestsRepository;

  BranchGetCancelReasonCubit(this._requestsRepository)
    : super(const BranchGetCancelReasonInit());

  void getCancellationReason({
    required String orderId,
    required String itemId,
  }) async {
    emit(const BranchGetCancelReasonLoading());

    final result = await _requestsRepository.getCancellationReason(
      orderId: orderId,
      itemId: itemId,
    );

    handle(
      result,
      success: (data) {
        emit(BranchGetCancelReasonSuccess(data));
      },
      failure: (failure) {
        emit(BranchGetCancelReasonFailure(failure));
      },
    );
  }
}
