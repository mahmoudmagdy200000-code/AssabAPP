import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_asset_preview_generate_report_response.dart';

sealed class GenerateFixedAssetsPreviewHistoryAssetReportState
    extends Equatable {
  const GenerateFixedAssetsPreviewHistoryAssetReportState();

  @override
  List<Object> get props => [];
}

final class GenerateFixedAssetsPreviewHistoryAssetReportInit
    extends GenerateFixedAssetsPreviewHistoryAssetReportState {
  const GenerateFixedAssetsPreviewHistoryAssetReportInit();
}

final class GenerateFixedAssetsPreviewHistoryAssetReportLoading
    extends GenerateFixedAssetsPreviewHistoryAssetReportState {
  const GenerateFixedAssetsPreviewHistoryAssetReportLoading();
}

final class GenerateFixedAssetsPreviewHistoryAssetReportSuccess
    extends GenerateFixedAssetsPreviewHistoryAssetReportState {
  final FixedAssetPreviewGenerateReportResponse response;

  const GenerateFixedAssetsPreviewHistoryAssetReportSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GenerateFixedAssetsPreviewHistoryAssetReportFailure
    extends GenerateFixedAssetsPreviewHistoryAssetReportState {
  final ApiFailure failure;

  const GenerateFixedAssetsPreviewHistoryAssetReportFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
