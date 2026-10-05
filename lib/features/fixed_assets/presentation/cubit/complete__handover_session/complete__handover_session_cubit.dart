import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'complete__handover_session_state.dart';

@injectable
class CompleteHandoverSessionCubit
    extends SafeCubit<CompleteHandoverSessionState> {
  final FixedAssetsRepository _repository;

  CompleteHandoverSessionCubit(this._repository)
    : super(const CompleteHandoverSessionInit());

  Future<void> completeHandoverSession({required String sessionId}) async {
    emit(const CompleteHandoverSessionLoading());

    final result = await _repository.completeActiveHandoverSession(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (_) => emit(const CompleteHandoverSessionSuccess()),
      failure: (failure) => emit(CompleteHandoverSessionFailure(failure)),
    );
  }
}
