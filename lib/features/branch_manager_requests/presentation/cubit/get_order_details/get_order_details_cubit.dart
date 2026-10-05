import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/requests_repository.dart';
import 'get_order_details_state.dart';

@injectable
class GetOrderDetailsCubit extends SafeCubit<GetOrderDetailsState> {
  final RequestsRepository _requestsRepository;

  GetOrderDetailsCubit(this._requestsRepository)
    : super(const GetOrderDetailsInit());

  void getBranchOrdersDetails({required String id}) async {
    emit(const GetOrderDetailsLoading());

    final result = await _requestsRepository.getBranchOrdersDetails(id: id);

    handle(
      result,
      failure: (failure) => emit(GetOrderDetailsFailure(failure)),
      success: (orderDetails) =>
          emit(GetBranchOrderDetailsSuccess(orderDetails)),
    );
  }

  void getDirectSupplierOrdersDetails({required String id}) async {
    emit(const GetOrderDetailsLoading());

    final result = await _requestsRepository.getDirectSupplierOrdersDetails(
      id: id,
    );

    handle(
      result,
      failure: (failure) => emit(GetOrderDetailsFailure(failure)),
      success: (orderDetails) =>
          emit(GetDirectSupplierOrderDetailsSuccess(orderDetails)),
    );
  }

  void getOfficerOrdersDetails({required String id}) async {
    emit(const GetOrderDetailsLoading());

    final result = await _requestsRepository.getOfficerOrdersDetails(id: id);

    handle(
      result,
      failure: (failure) => emit(GetOrderDetailsFailure(failure)),
      success: (orderDetails) =>
          emit(GetOfficerOrderDetailsSuccess(orderDetails)),
    );
  }
}
