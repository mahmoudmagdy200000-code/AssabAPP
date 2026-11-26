import 'package:assab/core/cubits/track_order/track_order_state.dart';
import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:assab/features/supplier_requests/data/repository/supplier_requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';

@injectable
class TrackOrderCubit extends SafeCubit<TrackOrderState> {
  final RequestsRepository _requestsRepository;
  final SupplierRequestsRepository _supplierRequestsRepository;

  TrackOrderCubit(this._requestsRepository, this._supplierRequestsRepository)
    : super(const TrackOrderInitial());

  Future<void> getTrackOrder({
    required String orderId,
    bool isSupplier = false,
  }) async {
    emit(const TrackOrderLoading());

    final result = isSupplier
        ? await _supplierRequestsRepository.getSupplierOrderTracking(
            orderId: orderId,
          )
        : await _requestsRepository.getTrackOrder(orderId: orderId);

    handle(
      result,
      failure: (failure) => emit(TrackOrderFailure(failure)),
      success: (track) => emit(TrackOrderSuccess(track)),
    );
  }
}
