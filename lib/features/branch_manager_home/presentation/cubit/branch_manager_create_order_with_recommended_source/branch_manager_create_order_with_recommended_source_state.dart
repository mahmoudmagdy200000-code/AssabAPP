import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class BranchManagerCreateOrderWithRecommendedSourceState
    extends Equatable {
  const BranchManagerCreateOrderWithRecommendedSourceState();

  @override
  List<Object?> get props => [];
}

final class BranchManagerCreateOrderWithRecommendedSourceInit
    extends BranchManagerCreateOrderWithRecommendedSourceState {
  const BranchManagerCreateOrderWithRecommendedSourceInit();
}

final class BranchManagerCreateOrderWithRecommendedSourceLoading
    extends BranchManagerCreateOrderWithRecommendedSourceState {
  const BranchManagerCreateOrderWithRecommendedSourceLoading();
}

final class BranchManagerCreateOrderWithRecommendedSourceSuccess
    extends BranchManagerCreateOrderWithRecommendedSourceState {
  const BranchManagerCreateOrderWithRecommendedSourceSuccess();
}

final class BranchManagerCreateOrderWithRecommendedSourceFailure
    extends BranchManagerCreateOrderWithRecommendedSourceState {
  final ApiFailure failure;

  const BranchManagerCreateOrderWithRecommendedSourceFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
