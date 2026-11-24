import 'package:injectable/injectable.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/receive_goods_repository.dart';
import '../../../data/models/receive_order_supplier_request.dart';
import 'start_receive_order_state.dart';

@injectable
class StartReceiveOrderCubit extends SafeCubit<StartReceiveOrderState> {
  final ReceiveGoodsRepository _repository;

  StartReceiveOrderCubit(this._repository)
    : super(const StartReceiveOrderInitial());

  Future<void> startReceivingSupplierOrder({
    required String orderId,
    required ReceiveOrderSupplierRequest request,
  }) async {
    emit(const StartReceiveOrderLoading());

    final result = await _repository.startReceivingSupplierOrder(
      orderId: orderId,
      request: request,
    );

    handle(
      result,
      success: (_) => emit(const StartReceiveOrderSuccess()),
      failure: (failure) => emit(StartReceiveOrderFailure(failure)),
    );
  }

  Future<void> startReceivingBranchOrder({
    required String orderId,
    List<Map<String, dynamic>>? items,
    String? idempotencyKey,
  }) async {
    emit(const StartReceiveOrderLoading());

    final result = await _repository.startReceivingBranchOrder(
      orderId: orderId,
      items: items,
      idempotencyKey: idempotencyKey,
    );

    handle(
      result,
      success: (_) => emit(const StartReceiveOrderSuccess()),
      failure: (failure) => emit(StartReceiveOrderFailure(failure)),
    );
  }

  Future<void> closeTransferVariance({
    required String orderId,
    required String resolution,
    String? reason,
    String? evidencePath,
    String? idempotencyKey,
  }) async {
    emit(const StartReceiveOrderLoading());

    final result = await _repository.closeTransferVariance(
      orderId: orderId,
      resolution: resolution,
      reason: reason,
      evidencePath: evidencePath,
      idempotencyKey: idempotencyKey,
    );

    handle(
      result,
      success: (_) => emit(const StartReceiveOrderSuccess()),
      failure: (failure) => emit(StartReceiveOrderFailure(failure)),
    );
  }
}
