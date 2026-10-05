import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_handover_included_zones_response.dart';

sealed class GetHandoverIncludedZonesState extends Equatable {
  const GetHandoverIncludedZonesState();

  @override
  List<Object> get props => [];
}

final class GetHandoverIncludedZonesInit extends GetHandoverIncludedZonesState {
  const GetHandoverIncludedZonesInit();
}

final class GetHandoverIncludedZonesLoading
    extends GetHandoverIncludedZonesState {
  const GetHandoverIncludedZonesLoading();
}

final class GetHandoverIncludedZonesSuccess
    extends GetHandoverIncludedZonesState {
  final FixedAssetsHandoverIncludedZonesResponse response;

  const GetHandoverIncludedZonesSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetHandoverIncludedZonesFailure
    extends GetHandoverIncludedZonesState {
  final ApiFailure failure;

  const GetHandoverIncludedZonesFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
