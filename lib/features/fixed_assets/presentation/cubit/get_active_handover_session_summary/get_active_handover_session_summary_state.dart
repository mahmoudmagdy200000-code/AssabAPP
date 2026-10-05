import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_active_handover_session_summary_response.dart';

sealed class GetActiveHandoverSessionSummaryState extends Equatable {
  const GetActiveHandoverSessionSummaryState();

  @override
  List<Object> get props => [];
}

final class GetActiveHandoverSessionSummaryInit
    extends GetActiveHandoverSessionSummaryState {
  const GetActiveHandoverSessionSummaryInit();
}

final class GetActiveHandoverSessionSummaryLoading
    extends GetActiveHandoverSessionSummaryState {
  const GetActiveHandoverSessionSummaryLoading();
}

final class GetActiveHandoverSessionSummarySuccess
    extends GetActiveHandoverSessionSummaryState {
  final FixedAssetsActiveHandoverSessionSummaryResponse response;

  const GetActiveHandoverSessionSummarySuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetActiveHandoverSessionSummaryFailure
    extends GetActiveHandoverSessionSummaryState {
  final ApiFailure failure;
  const GetActiveHandoverSessionSummaryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
