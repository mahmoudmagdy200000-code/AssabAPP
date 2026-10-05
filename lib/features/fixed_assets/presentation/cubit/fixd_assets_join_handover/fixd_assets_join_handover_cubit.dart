import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'fixd_assets_join_handover_state.dart';

@injectable
class FixdAssetsJoinHandoverCubit
    extends SafeCubit<FixdAssetsJoinHandoverState> {
  final FixedAssetsRepository _repository;

  FixdAssetsJoinHandoverCubit(this._repository)
    : super(const FixdAssetsJoinHandoverInit());

  Future<void> joinHandoverSession({required String sessionId}) async {
    emit(const FixdAssetsJoinHandoverLoading());

    final result = await _repository.joinHandoverSession(sessionId: sessionId);

    handle(
      result,
      success: (_) => emit(const FixdAssetsJoinHandoverSuccess()),
      failure: (failure) => emit(FixdAssetsJoinHandoverFailure(failure)),
    );
  }
}
