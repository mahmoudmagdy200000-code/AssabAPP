import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/generate_fixed_assets_preview_history_asset_report_use_case.dart';
import 'generate_fixed_assets_preview_history_asset_report_state.dart';

@injectable
class GenerateFixedAssetsPreviewHistoryAssetReportCubit
    extends SafeCubit<GenerateFixedAssetsPreviewHistoryAssetReportState> {
  final GenerateFixedAssetsPreviewHistoryAssetReportUseCase _useCase;

  GenerateFixedAssetsPreviewHistoryAssetReportCubit(this._useCase)
    : super(const GenerateFixedAssetsPreviewHistoryAssetReportInit());

  Future<void> generateReport({required String assetId}) async {
    emit(const GenerateFixedAssetsPreviewHistoryAssetReportLoading());

    final result = await _useCase(assetId: assetId);

    handle(
      result,
      success: (response) =>
          emit(GenerateFixedAssetsPreviewHistoryAssetReportSuccess(response)),
      failure: (failure) =>
          emit(GenerateFixedAssetsPreviewHistoryAssetReportFailure(failure)),
    );
  }
}
