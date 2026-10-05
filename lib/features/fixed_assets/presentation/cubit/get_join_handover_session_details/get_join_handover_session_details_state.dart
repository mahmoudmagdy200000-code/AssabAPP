import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_join_handover_session_details_response.dart';

sealed class GetJoinHandoverSessionDetailsState extends Equatable {
  const GetJoinHandoverSessionDetailsState();

  @override
  List<Object> get props => [];
}

final class GetJoinHandoverSessionDetailsInit
    extends GetJoinHandoverSessionDetailsState {
  const GetJoinHandoverSessionDetailsInit();
}

final class GetJoinHandoverSessionDetailsLoading
    extends GetJoinHandoverSessionDetailsState {
  const GetJoinHandoverSessionDetailsLoading();
}

final class GetJoinHandoverSessionDetailsSuccess
    extends GetJoinHandoverSessionDetailsState {
  final FixedAssetsJoinHandoverSessionDetailsResponse response;

  const GetJoinHandoverSessionDetailsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetJoinHandoverSessionDetailsFailure
    extends GetJoinHandoverSessionDetailsState {
  final ApiFailure failure;

  const GetJoinHandoverSessionDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
