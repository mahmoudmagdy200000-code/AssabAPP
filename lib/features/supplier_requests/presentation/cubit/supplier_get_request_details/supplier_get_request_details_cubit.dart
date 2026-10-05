import 'package:assab/features/supplier_requests/data/repository/supplier_requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'supplier_get_request_details_state.dart';

@injectable
class SupplierGetRequestDetailsCubit
    extends SafeCubit<SupplierGetRequestDetailsState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  SupplierGetRequestDetailsCubit(this._supplierRequestsRepository)
    : super(const SupplierGetRequestDetailsInit());

  void getRequestDetails({required String id}) async {
    emit(const SupplierGetRequestDetailsLoading());

    final result = await _supplierRequestsRepository.getSupplierOrderDetails(
      id: id,
    );

    handle(
      result,
      failure: (failure) {
        emit(SupplierGetRequestDetailsFailure(failure));
      },
      success: (details) {
        emit(SupplierGetRequestDetailsSuccess(details));
      },
    );
  }
}
