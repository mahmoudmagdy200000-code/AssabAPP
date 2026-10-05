import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/purchase_create_order_request.dart';
import '../../../data/repository/purchase_repository.dart';
import 'create_purchase_order_state.dart';

@injectable
class CreatePurchaseOrderCubit extends SafeCubit<CreatePurchaseOrderState> {
  final PurchaseRepository _purchaseRepository;

  CreatePurchaseOrderCubit(this._purchaseRepository)
    : super(const CreatePurchaseOrderInit());

  void createPurchaseOrder({
    required PurchaseCreateOrderRequest request,
  }) async {
    emit(const CreatePurchaseOrderLoading());

    final result = await _purchaseRepository.createPurchaseOrder(
      request: request,
    );

    handle(
      result,
      failure: (failure) {
        emit(CreatePurchaseOrderFailure(failure));
      },
      success: (_) {
        emit(const CreatePurchaseOrderSuccess());
      },
    );
  }

  void submitDraft({
    required String id,
    required PurchaseCreateOrderRequest request,
  }) async {
    emit(const CreatePurchaseOrderLoading());

    final result = await _purchaseRepository.submitOrderDraft(
      id: id,
      request: request,
    );

    handle(
      result,
      failure: (failure) {
        emit(CreatePurchaseOrderFailure(failure));
      },
      success: (_) {
        emit(const CreatePurchaseOrderSuccess());
      },
    );
  }
}
