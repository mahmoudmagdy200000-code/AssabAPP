import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CompleteHandoverSessionState extends Equatable {
  const CompleteHandoverSessionState();

  @override
  List<Object> get props => [];
}

final class CompleteHandoverSessionInit extends CompleteHandoverSessionState {
  const CompleteHandoverSessionInit();
}

final class CompleteHandoverSessionLoading
    extends CompleteHandoverSessionState {
  const CompleteHandoverSessionLoading();
}

final class CompleteHandoverSessionSuccess
    extends CompleteHandoverSessionState {
  const CompleteHandoverSessionSuccess();
}

final class CompleteHandoverSessionFailure
    extends CompleteHandoverSessionState {
  final ApiFailure failure;
  const CompleteHandoverSessionFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
