import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateInventoryState extends Equatable {
  const CreateInventoryState();

  @override
  List<Object> get props => [];
}

final class CreateInventoryInit extends CreateInventoryState {
  const CreateInventoryInit();
}

final class CreateInventoryLoading extends CreateInventoryState {
  const CreateInventoryLoading();
}

final class CreateInventorySuccess extends CreateInventoryState {
  const CreateInventorySuccess();
}

final class CreateInventoryFailure extends CreateInventoryState {
  final ApiFailure failure;

  const CreateInventoryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
