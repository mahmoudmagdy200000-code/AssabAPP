import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'reject_approve_delay_state.dart';

@injectable
class RejectApproveDelayCubit extends SafeCubit<RejectApproveDelayState> {
  final RequestsRepository _requestsRepository;

  RejectApproveDelayCubit(this._requestsRepository)
    : super(const RejectApproveDelayInit());

  Future<void> approveDelay({required String id}) async {
    emit(const RejectApproveDelayLoading());
    final result = await _requestsRepository.approveDelay(id: id);
    handle(
      result,
      success: (_) => emit(const RejectApproveDelaySuccess()),
      failure: (failure) => emit(RejectApproveDelayFailure(failure)),
    );
  }

  Future<void> rejectDelay({required String id, required String reason}) async {
    emit(const RejectApproveDelayLoading());
    final result = await _requestsRepository.rejectDelay(
      id: id,
      reason: reason,
    );
    handle(
      result,
      success: (_) => emit(const RejectApproveRejectedDelaySuccess()),
      failure: (failure) => emit(RejectApproveDelayFailure(failure)),
    );
  }
}
