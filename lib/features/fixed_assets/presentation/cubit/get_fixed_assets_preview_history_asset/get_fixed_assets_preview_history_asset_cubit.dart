import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/get_fixed_assets_preview_history_asset_use_case.dart';
import 'get_fixed_assets_preview_history_asset_state.dart';

@injectable
class GetFixedAssetsPreviewHistoryAssetCubit
    extends SafeCubit<GetFixedAssetsPreviewHistoryAssetState> {
  final GetFixedAssetsPreviewHistoryAssetUseCase _useCase;

  GetFixedAssetsPreviewHistoryAssetCubit(this._useCase)
    : super(const GetFixedAssetsPreviewHistoryAssetInit());

  Future<void> getHistory({required String assetId}) async {
    emit(const GetFixedAssetsPreviewHistoryAssetLoading());

    final result = await _useCase(assetId: assetId);

    handle(
      result,
      success: (response) =>
          emit(GetFixedAssetsPreviewHistoryAssetSuccess(response)),
      failure: (failure) =>
          emit(GetFixedAssetsPreviewHistoryAssetFailure(failure)),
    );
  }
}
