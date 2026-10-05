import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_active_handover_session_preview_response.dart';

sealed class GetActiveHandoverSessionPreviewAssetsState extends Equatable {
  const GetActiveHandoverSessionPreviewAssetsState();

  @override
  List<Object> get props => [];
}

final class GetActiveHandoverSessionPreviewAssetsInit
    extends GetActiveHandoverSessionPreviewAssetsState {
  const GetActiveHandoverSessionPreviewAssetsInit();
}

final class GetActiveHandoverSessionPreviewAssetsLoading
    extends GetActiveHandoverSessionPreviewAssetsState {
  const GetActiveHandoverSessionPreviewAssetsLoading();
}

final class GetActiveHandoverSessionPreviewAssetsSuccess
    extends GetActiveHandoverSessionPreviewAssetsState {
  final FixedAssetsActiveHandoverSessionPreviewResponse response;

  const GetActiveHandoverSessionPreviewAssetsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetActiveHandoverSessionPreviewAssetsFailure
    extends GetActiveHandoverSessionPreviewAssetsState {
  final ApiFailure failure;

  const GetActiveHandoverSessionPreviewAssetsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
