import 'package:assab/features/supplier_requests/data/repository/supplier_requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'supplier_get_modification_state.dart';

@injectable
class SupplierGetModificationCubit
    extends SafeCubit<SupplierGetModificationState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  SupplierGetModificationCubit(this._supplierRequestsRepository)
    : super(const SupplierGetModificationInit());

  void getSupplierModification({
    required String orderId,
    required String itemId,
  }) async {
    emit(const SupplierGetModificationLoading());
    final result = await _supplierRequestsRepository.getSupplierModification(
      orderId: orderId,
      itemId: itemId,
    );

    handle(
      result,
      success: (modification) {
        emit(SupplierGetModificationSuccess(modification));
      },
      failure: (failure) {
        emit(SupplierGetModificationFailure(failure));
      },
    );
  }
}
