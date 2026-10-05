import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_asset_preview_asset_history_response.dart';

sealed class GetFixedAssetsPreviewHistoryAssetState extends Equatable {
  const GetFixedAssetsPreviewHistoryAssetState();

  @override
  List<Object> get props => [];
}

final class GetFixedAssetsPreviewHistoryAssetInit
    extends GetFixedAssetsPreviewHistoryAssetState {
  const GetFixedAssetsPreviewHistoryAssetInit();
}

final class GetFixedAssetsPreviewHistoryAssetLoading
    extends GetFixedAssetsPreviewHistoryAssetState {
  const GetFixedAssetsPreviewHistoryAssetLoading();
}

final class GetFixedAssetsPreviewHistoryAssetSuccess
    extends GetFixedAssetsPreviewHistoryAssetState {
  final FixedAssetPreviewAssetHistoryResponse response;

  const GetFixedAssetsPreviewHistoryAssetSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetFixedAssetsPreviewHistoryAssetFailure
    extends GetFixedAssetsPreviewHistoryAssetState {
  final ApiFailure failure;

  const GetFixedAssetsPreviewHistoryAssetFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
