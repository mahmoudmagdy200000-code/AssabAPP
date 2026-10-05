import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_overview_response.dart';

sealed class GetFixedAssetsOverviewState extends Equatable {
  const GetFixedAssetsOverviewState();

  @override
  List<Object> get props => [];
}

final class GetFixedAssetsOverviewInit extends GetFixedAssetsOverviewState {
  const GetFixedAssetsOverviewInit();
}

final class GetFixedAssetsOverviewLoading extends GetFixedAssetsOverviewState {
  const GetFixedAssetsOverviewLoading();
}

final class GetFixedAssetsOverviewSuccess extends GetFixedAssetsOverviewState {
  final FixedAssetsOverviewResponse overview;

  const GetFixedAssetsOverviewSuccess(this.overview);

  @override
  List<Object> get props => [overview];
}

final class GetFixedAssetsOverviewFailure extends GetFixedAssetsOverviewState {
  final ApiFailure failure;

  const GetFixedAssetsOverviewFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
