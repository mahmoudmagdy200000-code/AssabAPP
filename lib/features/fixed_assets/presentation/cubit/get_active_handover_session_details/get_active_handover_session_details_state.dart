import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_active_handover_session_details_response.dart';

sealed class GetActiveHandoverSessionDetailsState extends Equatable {
  const GetActiveHandoverSessionDetailsState();

  @override
  List<Object> get props => [];
}

final class GetActiveHandoverSessionDetailsInit
    extends GetActiveHandoverSessionDetailsState {
  const GetActiveHandoverSessionDetailsInit();
}

final class GetActiveHandoverSessionDetailsLoading
    extends GetActiveHandoverSessionDetailsState {
  const GetActiveHandoverSessionDetailsLoading();
}

final class GetActiveHandoverSessionDetailsSuccess
    extends GetActiveHandoverSessionDetailsState {
  final FixedAssetsActiveHandoverSessionDetailsResponse response;

  const GetActiveHandoverSessionDetailsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetActiveHandoverSessionDetailsFailure
    extends GetActiveHandoverSessionDetailsState {
  final ApiFailure failure;

  const GetActiveHandoverSessionDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
