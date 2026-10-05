import 'package:assab/core/cubits/track_order/track_order_state.dart';
import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';

@injectable
class TrackOrderCubit extends SafeCubit<TrackOrderState> {
  final RequestsRepository _requestsRepository;

  TrackOrderCubit(this._requestsRepository) : super(const TrackOrderInitial());

  Future<void> getTrackOrder({required String orderId}) async {
    emit(const TrackOrderLoading());

    final result = await _requestsRepository.getTrackOrder(orderId: orderId);

    handle(
      result,
      failure: (failure) => emit(TrackOrderFailure(failure)),
      success: (track) => emit(TrackOrderSuccess(track)),
    );
  }
}
