import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/get_active_handover_session_preview_assets_use_case.dart';
import 'get_active_handover_session_preview_assets_state.dart';

@injectable
class GetActiveHandoverSessionPreviewAssetsCubit
    extends SafeCubit<GetActiveHandoverSessionPreviewAssetsState> {
  final GetActiveHandoverSessionPreviewAssetsUseCase _useCase;

  GetActiveHandoverSessionPreviewAssetsCubit(this._useCase)
    : super(const GetActiveHandoverSessionPreviewAssetsInit());

  Future<void> getPreviewAssets({required String sessionId}) async {
    emit(const GetActiveHandoverSessionPreviewAssetsLoading());

    final result = await _useCase(sessionId: sessionId);

    handle(
      result,
      success: (response) =>
          emit(GetActiveHandoverSessionPreviewAssetsSuccess(response)),
      failure: (failure) =>
          emit(GetActiveHandoverSessionPreviewAssetsFailure(failure)),
    );
  }
}
