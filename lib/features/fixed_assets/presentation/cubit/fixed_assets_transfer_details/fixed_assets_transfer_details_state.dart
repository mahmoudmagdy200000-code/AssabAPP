import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_transfer_details_response.dart';

sealed class FixedAssetsTransferDetailsState extends Equatable {
  const FixedAssetsTransferDetailsState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsTransferDetailsInitial
    extends FixedAssetsTransferDetailsState {
  const FixedAssetsTransferDetailsInitial();
}

final class FixedAssetsTransferDetailsLoading
    extends FixedAssetsTransferDetailsState {
  const FixedAssetsTransferDetailsLoading();
}

final class FixedAssetsTransferDetailsSuccess
    extends FixedAssetsTransferDetailsState {
  final FixedAssetsTransferDetailsResponse details;

  const FixedAssetsTransferDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class FixedAssetsTransferDetailsFailure
    extends FixedAssetsTransferDetailsState {
  final ApiFailure failure;

  const FixedAssetsTransferDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
