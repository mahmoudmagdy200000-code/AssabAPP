import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/supplier_returns_repository.dart';
import 'get_return_details_state.dart';

@injectable
class SupplierGetReturnDetailsCubit
    extends SafeCubit<SupplierGetReturnDetailsState> {
  final SupplierReturnsRepository _supplierReturnsRepository;

  SupplierGetReturnDetailsCubit(this._supplierReturnsRepository)
    : super(const SupplierGetReturnDetailsInit());
  Future<void> getReturnDetails({required String id}) async {
    emit(const SupplierGetReturnDetailsLoading());

    final result = await _supplierReturnsRepository.getSupplierReturnDetails(
      id: id,
    );

    handle(
      result,
      success: (data) {
        emit(SupplierGetReturnDetailsSuccess(data));
      },
      failure: (failure) {
        emit(SupplierGetReturnDetailsFailure(failure));
      },
    );
  }
}
