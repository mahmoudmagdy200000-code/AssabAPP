import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/supplier_returns_repository.dart';
import 'supplier_approve_reject_return_state.dart';

@injectable
class SupplierApproveRejectReturnCubit
    extends SafeCubit<SupplierApproveRejectReturnState> {
  final SupplierReturnsRepository _supplierReturnsRepository;

  SupplierApproveRejectReturnCubit(this._supplierReturnsRepository)
    : super(const SupplierApproveRejectReturnInit());

  Future<void> rejectReturn({
    required String id,
    required String reason,
  }) async {
    emit(const SupplierApproveRejectReturnLoading());

    final result = await _supplierReturnsRepository.rejectSupplierReturn(
      id: id,
      reason: reason,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierApproveRejectReturnSuccess());
      },
      failure: (failure) {
        emit(SupplierApproveRejectReturnFailure(failure));
      },
    );
  }

  Future<void> approveReturn({required String id}) async {
    emit(const SupplierApproveRejectReturnLoading());

    final result = await _supplierReturnsRepository.approveSupplierReturn(
      id: id,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierApproveRejectReturnSuccess());
      },
      failure: (failure) {
        emit(SupplierApproveRejectReturnFailure(failure));
      },
    );
  }
}
