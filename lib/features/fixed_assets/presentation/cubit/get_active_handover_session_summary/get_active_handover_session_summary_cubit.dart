import 'package:assab/features/fixed_assets/data/repositories/fixed_assets_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_active_handover_session_summary_state.dart';

@injectable
class GetActiveHandoverSessionSummaryCubit
    extends SafeCubit<GetActiveHandoverSessionSummaryState> {
  final FixedAssetsRepository _repository;

  GetActiveHandoverSessionSummaryCubit(this._repository)
    : super(const GetActiveHandoverSessionSummaryInit());

  Future<void> getActiveHandoverSessionSummary({
    required String sessionId,
  }) async {
    emit(const GetActiveHandoverSessionSummaryLoading());

    final result = await _repository.getActiveHandoverSessionSummary(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (response) =>
          emit(GetActiveHandoverSessionSummarySuccess(response)),
      failure: (failure) =>
          emit(GetActiveHandoverSessionSummaryFailure(failure)),
    );
  }
}
