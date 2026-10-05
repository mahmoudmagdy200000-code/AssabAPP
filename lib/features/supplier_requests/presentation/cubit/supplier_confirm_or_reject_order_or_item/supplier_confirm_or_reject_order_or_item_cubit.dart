import 'package:assab/features/supplier_requests/data/models/supplier_partial_confirmItem_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../branch_manager_requests/data/models/reject_all_order_request.dart';
import '../../../data/models/supplier_alternative_product_request.dart';
import '../../../data/models/supplier_need_time_request.dart';
import '../../../data/repository/supplier_requests_repository.dart';
import 'supplier_confirm_or_reject_order_or_item_state.dart';

@injectable
class SupplierConfirmOrRejectOrderOrItemCubit
    extends SafeCubit<SupplierConfirmOrRejectOrderOrItemState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  SupplierConfirmOrRejectOrderOrItemCubit(this._supplierRequestsRepository)
    : super(const SupplierConfirmOrRejectOrderOrItemInit());

  void partialConfirmItem({
    required String id,
    required SupplierPartialConfirmItemRequest body,
  }) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository.supplierPartialConfirmItem(
      id: id,
      body: body,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }

  void supplierFullConfirmItem({
    required String orderId,
    required String itemId,
  }) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository.supplierFullConfirmItem(
      orderId: orderId,
      itemId: itemId,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }

  void supplierCancelItem({
    required String orderId,
    required String itemId,
    required RejectAllOrderRequest body,
  }) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository.supplierCancelItem(
      orderId: orderId,
      itemId: itemId,
      body: body,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }

  void supplierConfirmOrder({required String orderId}) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository.supplierConfirmOrder(
      orderId: orderId,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }

  void supplierCancelOrder({
    required String orderId,
    required RejectAllOrderRequest body,
  }) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository.supplierCancelOrder(
      orderId: orderId,
      body: body,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }

  void supplierNeedTimeItem({
    required String orderId,
    required String itemId,
    required SupplierNeedTimeRequest body,
  }) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository.supplierNeedTimeItem(
      orderId: orderId,
      itemId: itemId,
      body: body,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }

  void supplierAlternativeProductItem({
    required String orderId,
    required String itemId,
    required SupplierAlternativeProductRequest body,
  }) async {
    emit(const SupplierConfirmOrRejectOrderOrItemLoading());

    final result = await _supplierRequestsRepository
        .supplierAlternativeProductItem(
          orderId: orderId,
          itemId: itemId,
          body: body,
        );

    handle(
      result,
      success: (_) {
        emit(const SupplierConfirmOrRejectOrderOrItemSuccess());
      },
      failure: (failure) {
        emit(SupplierConfirmOrRejectOrderOrItemFailure(failure));
      },
    );
  }
}
