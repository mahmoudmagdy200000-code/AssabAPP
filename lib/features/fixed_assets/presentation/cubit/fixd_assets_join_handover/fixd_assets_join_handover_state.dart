import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class FixdAssetsJoinHandoverState extends Equatable {
  const FixdAssetsJoinHandoverState();

  @override
  List<Object> get props => [];
}

final class FixdAssetsJoinHandoverInit extends FixdAssetsJoinHandoverState {
  const FixdAssetsJoinHandoverInit();
}

final class FixdAssetsJoinHandoverLoading extends FixdAssetsJoinHandoverState {
  const FixdAssetsJoinHandoverLoading();
}

final class FixdAssetsJoinHandoverSuccess extends FixdAssetsJoinHandoverState {
  const FixdAssetsJoinHandoverSuccess();
}

final class FixdAssetsJoinHandoverFailure extends FixdAssetsJoinHandoverState {
  final ApiFailure failure;

  const FixdAssetsJoinHandoverFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
