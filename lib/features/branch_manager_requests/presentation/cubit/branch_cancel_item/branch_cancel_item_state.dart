import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class BranchCancelItemState extends Equatable {
  const BranchCancelItemState();

  @override
  List<Object> get props => [];
}

final class BranchCancelItemInit extends BranchCancelItemState {
  const BranchCancelItemInit();
}

final class BranchCancelItemLoading extends BranchCancelItemState {
  const BranchCancelItemLoading();
}

final class BranchCancelItemSuccess extends BranchCancelItemState {
  const BranchCancelItemSuccess();
}

final class BranchCancelItemFailure extends BranchCancelItemState {
  final ApiFailure failure;

  const BranchCancelItemFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
