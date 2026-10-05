import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class DeleteOrderDraftState extends Equatable {
  const DeleteOrderDraftState();

  @override
  List<Object> get props => [];
}

final class DeleteOrderDraftInit extends DeleteOrderDraftState {
  const DeleteOrderDraftInit();
}

final class DeleteOrderDraftLoading extends DeleteOrderDraftState {
  const DeleteOrderDraftLoading();
}

final class DeleteOrderDraftSuccess extends DeleteOrderDraftState {
  const DeleteOrderDraftSuccess();
}

final class DeleteOrderDraftFailure extends DeleteOrderDraftState {
  final ApiFailure failure;

  const DeleteOrderDraftFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
