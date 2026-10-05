import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class AcceptEscalateReturnRejectionState extends Equatable {
  const AcceptEscalateReturnRejectionState();

  @override
  List<Object> get props => [];
}

final class AcceptEscalateReturnRejectionInit
    extends AcceptEscalateReturnRejectionState {
  const AcceptEscalateReturnRejectionInit();
}

final class AcceptEscalateReturnRejectionLoading
    extends AcceptEscalateReturnRejectionState {
  const AcceptEscalateReturnRejectionLoading();
}

final class AcceptEscalateReturnRejectionSuccess
    extends AcceptEscalateReturnRejectionState {
  const AcceptEscalateReturnRejectionSuccess();
}

final class AcceptEscalateReturnRejectionFailure
    extends AcceptEscalateReturnRejectionState {
  final ApiFailure failure;

  const AcceptEscalateReturnRejectionFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
