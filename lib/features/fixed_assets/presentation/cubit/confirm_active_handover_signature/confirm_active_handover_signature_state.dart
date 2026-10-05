import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ConfirmActiveHandoverSignatureState extends Equatable {
  const ConfirmActiveHandoverSignatureState();

  @override
  List<Object> get props => [];
}

final class ConfirmActiveHandoverSignatureInit
    extends ConfirmActiveHandoverSignatureState {
  const ConfirmActiveHandoverSignatureInit();
}

final class ConfirmActiveHandoverSignatureLoading
    extends ConfirmActiveHandoverSignatureState {
  const ConfirmActiveHandoverSignatureLoading();
}

final class ConfirmActiveHandoverSignatureSuccess
    extends ConfirmActiveHandoverSignatureState {
  const ConfirmActiveHandoverSignatureSuccess();
}

final class ConfirmActiveHandoverSignatureFailure
    extends ConfirmActiveHandoverSignatureState {
  final ApiFailure failure;

  const ConfirmActiveHandoverSignatureFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
