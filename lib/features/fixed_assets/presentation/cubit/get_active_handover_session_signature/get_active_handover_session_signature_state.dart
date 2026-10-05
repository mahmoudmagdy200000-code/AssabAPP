import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/fixed_assets_active_handover_session_signature_response.dart';

sealed class GetActiveHandoverSessionSignatureState extends Equatable {
  const GetActiveHandoverSessionSignatureState();

  @override
  List<Object> get props => [];
}

final class GetActiveHandoverSessionSignatureInit
    extends GetActiveHandoverSessionSignatureState {
  const GetActiveHandoverSessionSignatureInit();
}

final class GetActiveHandoverSessionSignatureLoading
    extends GetActiveHandoverSessionSignatureState {
  const GetActiveHandoverSessionSignatureLoading();
}

final class GetActiveHandoverSessionSignatureSuccess
    extends GetActiveHandoverSessionSignatureState {
  final FixedAssetsActiveHandoverSessionSignatureResponse response;

  const GetActiveHandoverSessionSignatureSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetActiveHandoverSessionSignatureFailure
    extends GetActiveHandoverSessionSignatureState {
  final ApiFailure failure;
  const GetActiveHandoverSessionSignatureFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
