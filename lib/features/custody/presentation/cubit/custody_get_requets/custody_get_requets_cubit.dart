import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'custody_get_requets_state.dart';

@injectable
class CustodyGetRequetsCubit extends SafeCubit<CustodyGetRequetsState> {
  final CustodyRepository _custodyRepository;

  CustodyGetRequetsCubit(this._custodyRepository)
    : super(const CustodyGetRequetsInit());

  void getCustodyRequests({String? status, String? timePeriod}) async {
    emit(const CustodyGetRequetsLoading());

    final result = await _custodyRepository.getRequests(
      status: status,
      timePeriod: timePeriod,
    );

    handle(
      result,
      failure: (failure) {
        emit(CustodyGetRequetsFailure(failure));
      },
      success: (requestsResponse) {
        emit(CustodyGetRequetsSuccess(requestsResponse));
      },
    );
  }

  void getCustodyPastRequests() async {
    emit(const CustodyGetRequetsLoading());

    final result = await _custodyRepository.getPastRequests();

    handle(
      result,
      failure: (failure) {
        emit(CustodyGetRequetsFailure(failure));
      },
      success: (requestsResponse) {
        emit(CustodyGetPastRequestsSuccess(requestsResponse));
      },
    );
  }
}
