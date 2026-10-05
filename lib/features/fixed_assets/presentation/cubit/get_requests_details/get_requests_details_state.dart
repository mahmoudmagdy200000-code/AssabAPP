import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_modify_details_response.dart';

sealed class GetRequestsDetailsState extends Equatable {
  const GetRequestsDetailsState();

  @override
  List<Object> get props => [];
}

final class GetRequestsDetailsInit extends GetRequestsDetailsState {
  const GetRequestsDetailsInit();
}

final class GetRequestsDetailsLoading extends GetRequestsDetailsState {
  const GetRequestsDetailsLoading();
}

final class GetRequestsDetailsModificationSuccess
    extends GetRequestsDetailsState {
  final FixedAssetsModifyDetailsResponse details;

  const GetRequestsDetailsModificationSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class GetRequestsDetailsFailure extends GetRequestsDetailsState {
  final ApiFailure failure;

  const GetRequestsDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
