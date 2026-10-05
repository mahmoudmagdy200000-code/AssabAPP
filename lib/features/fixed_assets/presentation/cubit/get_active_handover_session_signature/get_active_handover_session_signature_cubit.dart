import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_active_handover_session_signature_state.dart';

@injectable
class GetActiveHandoverSessionSignatureCubit
    extends SafeCubit<GetActiveHandoverSessionSignatureState> {
  final FixedAssetsRepository _repository;

  GetActiveHandoverSessionSignatureCubit(this._repository)
    : super(const GetActiveHandoverSessionSignatureInit());

  Future<void> getActiveHandoverSessionSignature({
    required String sessionId,
    bool loading = true,
  }) async {
    if (loading) {
      emit(const GetActiveHandoverSessionSignatureLoading());
    }

    final result = await _repository.getActiveHandoverSessionSignature(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (response) =>
          emit(GetActiveHandoverSessionSignatureSuccess(response)),
      failure: (failure) =>
          emit(GetActiveHandoverSessionSignatureFailure(failure)),
    );
  }
}
