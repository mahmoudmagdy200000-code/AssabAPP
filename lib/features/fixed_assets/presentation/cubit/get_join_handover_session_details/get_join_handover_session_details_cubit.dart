import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_join_handover_session_details_state.dart';

@injectable
class GetJoinHandoverSessionDetailsCubit
    extends SafeCubit<GetJoinHandoverSessionDetailsState> {
  final FixedAssetsRepository _repository;

  GetJoinHandoverSessionDetailsCubit(this._repository)
    : super(const GetJoinHandoverSessionDetailsInit());

  Future<void> getJoinHandoverSessionDetails({
    required String sessionId,
  }) async {
    emit(const GetJoinHandoverSessionDetailsLoading());

    final result = await _repository.getJoinHandoverSessionDetails(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (data) => emit(GetJoinHandoverSessionDetailsSuccess(data)),
      failure: (failure) => emit(GetJoinHandoverSessionDetailsFailure(failure)),
    );
  }
}
