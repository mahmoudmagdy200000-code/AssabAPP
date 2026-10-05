import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/reject_all_order_request.dart';
import 'branch_cancel_item_state.dart';

@injectable
class BranchCancelItemCubit extends SafeCubit<BranchCancelItemState> {
  final RequestsRepository _requestsRepository;

  BranchCancelItemCubit(this._requestsRepository)
    : super(const BranchCancelItemInit());

  void cancelItem({
    required String orderId,
    required String itemId,
    required RejectAllOrderRequest body,
  }) async {
    emit(const BranchCancelItemLoading());
    final result = await _requestsRepository.cancelItem(
      orderId: orderId,
      itemId: itemId,
      body: body,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchCancelItemSuccess());
      },
      failure: (failure) {
        emit(BranchCancelItemFailure(failure));
      },
    );
  }

  void cancelOrder({
    required String orderId,
    required RejectAllOrderRequest body,
  }) async {
    emit(const BranchCancelItemLoading());
    final result = await _requestsRepository.cancelOrder(
      orderId: orderId,
      body: body,
    );

    handle(
      result,
      success: (_) {
        emit(const BranchCancelItemSuccess());
      },
      failure: (failure) {
        emit(BranchCancelItemFailure(failure));
      },
    );
  }
}
