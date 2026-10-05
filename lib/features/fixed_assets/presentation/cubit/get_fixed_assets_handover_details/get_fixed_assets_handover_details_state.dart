import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/fixed_assets_handover_details_response.dart';

sealed class GetFixedAssetsHandoverDetailsState extends Equatable {
  const GetFixedAssetsHandoverDetailsState();

  @override
  List<Object> get props => [];
}

final class GetFixedAssetsHandoverDetailsInit
    extends GetFixedAssetsHandoverDetailsState {
  const GetFixedAssetsHandoverDetailsInit();
}

final class GetFixedAssetsHandoverDetailsLoading
    extends GetFixedAssetsHandoverDetailsState {
  const GetFixedAssetsHandoverDetailsLoading();
}

final class GetFixedAssetsHandoverDetailsSuccess
    extends GetFixedAssetsHandoverDetailsState {
  final FixedAssetsHandoverDetailsResponse response;

  const GetFixedAssetsHandoverDetailsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetFixedAssetsHandoverDetailsFailure
    extends GetFixedAssetsHandoverDetailsState {
  final ApiFailure failure;

  const GetFixedAssetsHandoverDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
