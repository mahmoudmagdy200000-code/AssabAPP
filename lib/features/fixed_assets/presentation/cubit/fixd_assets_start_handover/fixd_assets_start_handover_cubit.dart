import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_start_handover_request.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'fixd_assets_start_handover_state.dart';

@injectable
class FixdAssetsStartHandoverCubit
    extends SafeCubit<FixdAssetsStartHandoverState> {
  final FixedAssetsRepository _repository;

  FixdAssetsStartHandoverCubit(this._repository)
    : super(const FixdAssetsStartHandoverInit());

  Future<void> startHandover({
    required FixedAssetsStartHandoverRequest request,
  }) async {
    emit(const FixdAssetsStartHandoverLoading());

    final result = await _repository.startHandover(request: request);

    handle(
      result,
      success: (_) => emit(const FixdAssetsStartHandoverSuccess()),
      failure: (failure) => emit(FixdAssetsStartHandoverFailure(failure)),
    );
  }
}
