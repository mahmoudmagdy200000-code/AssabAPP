import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_active_handover_session_details_state.dart';

@injectable
class GetActiveHandoverSessionDetailsCubit
    extends SafeCubit<GetActiveHandoverSessionDetailsState> {
  final FixedAssetsRepository _repository;

  GetActiveHandoverSessionDetailsCubit(this._repository)
    : super(const GetActiveHandoverSessionDetailsInit());

  String? _sessionId;

  Future<void> getActiveHandoverSessionDetails({
    required String sessionId,
  }) async {
    _sessionId = sessionId;
    emit(const GetActiveHandoverSessionDetailsLoading());

    final result = await _repository.getActiveHandoverSessionDetails(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (data) => emit(GetActiveHandoverSessionDetailsSuccess(data)),
      failure: (failure) =>
          emit(GetActiveHandoverSessionDetailsFailure(failure)),
    );
  }

  Future<void> refreshActiveHandoverSessionDetails() async {
    final sessionId = _sessionId;
    if (sessionId == null) {
      return;
    }

    final result = await _repository.getActiveHandoverSessionDetails(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (data) {
        if (state is GetActiveHandoverSessionDetailsSuccess ||
            state is GetActiveHandoverSessionDetailsFailure) {
          emit(GetActiveHandoverSessionDetailsSuccess(data));
        }
      },
      failure: (failure) {
        if (state is GetActiveHandoverSessionDetailsSuccess) {
          return;
        }
        emit(GetActiveHandoverSessionDetailsFailure(failure));
      },
    );
  }
}
