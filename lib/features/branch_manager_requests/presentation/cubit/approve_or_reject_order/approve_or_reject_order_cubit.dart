import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/approve_all_order_request.dart';
import '../../../data/models/partial_approve_order_request.dart';
import '../../../data/models/reject_all_order_request.dart';
import 'approve_or_reject_order_state.dart';

@injectable
class ApproveOrRejectOrderCubit extends SafeCubit<ApproveOrRejectOrderState> {
  final RequestsRepository _requestsRepository;

  ApproveOrRejectOrderCubit(this._requestsRepository)
    : super(const ApproveOrRejectOrderInit());

  void approveOrder({
    required String orderId,
    required ApproveAllOrderRequest body,
  }) async {
    emit(const ApproveOrRejectOrderLoading());

    final result = await _requestsRepository.approveOrder(
      id: orderId,
      body: body,
    );

    handle(
      result,
      failure: (failure) => emit(ApproveOrRejectOrderFailure(failure)),
      success: (_) => emit(const ApproveOrRejectOrderSuccess()),
    );
  }

  void partialApproveOrder({
    required String orderId,
    required PartialApproveOrderRequest body,
  }) async {
    emit(const ApproveOrRejectOrderLoading());

    final result = await _requestsRepository.partialApproveOrder(
      id: orderId,
      body: body,
    );

    handle(
      result,
      failure: (failure) => emit(ApproveOrRejectOrderFailure(failure)),
      success: (_) => emit(const ApproveOrRejectOrderSuccess()),
    );
  }

  void rejectOrder({
    required String orderId,
    required RejectAllOrderRequest body,
  }) async {
    emit(const ApproveOrRejectOrderLoading());

    final result = await _requestsRepository.rejectOrder(
      id: orderId,
      body: body,
    );

    handle(
      result,
      failure: (failure) => emit(ApproveOrRejectOrderFailure(failure)),
      success: (_) => emit(const ApproveOrRejectOrderSuccess()),
    );
  }
}
