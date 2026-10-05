import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_disposals_details_response.dart';

sealed class FixedAssetsDisposalsDetailsState extends Equatable {
  const FixedAssetsDisposalsDetailsState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsDisposalsDetailsInitial
    extends FixedAssetsDisposalsDetailsState {
  const FixedAssetsDisposalsDetailsInitial();
}

final class FixedAssetsDisposalsDetailsLoading
    extends FixedAssetsDisposalsDetailsState {
  const FixedAssetsDisposalsDetailsLoading();
}

final class FixedAssetsDisposalsDetailsSuccess
    extends FixedAssetsDisposalsDetailsState {
  final FixedAssetsDisposalsDetailsResponse details;

  const FixedAssetsDisposalsDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class FixedAssetsDisposalsDetailsFailure
    extends FixedAssetsDisposalsDetailsState {
  final ApiFailure failure;

  const FixedAssetsDisposalsDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
