import 'package:assab/features/supplier_requests/data/repository/supplier_requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'supplier_get_cancellation_reason_state.dart';

@injectable
class SupplierGetCancellationReasonCubit
    extends SafeCubit<SupplierGetCancellationReasonState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  SupplierGetCancellationReasonCubit(this._supplierRequestsRepository)
    : super(const SupplierGetCancellationReasonInit());

  void getSupplierCancellationReason({
    required String orderId,
    required String itemId,
  }) async {
    emit(const SupplierGetCancellationReasonLoading());

    final result = await _supplierRequestsRepository
        .getSupplierCancellationReason(orderId: orderId, itemId: itemId);

    handle(
      result,
      success: (data) {
        emit(SupplierGetCancellationReasonSuccess(data));
      },
      failure: (failure) {
        emit(SupplierGetCancellationReasonFailure(failure));
      },
    );
  }
}
