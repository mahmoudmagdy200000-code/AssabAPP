import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateReturnState extends Equatable {
  const CreateReturnState();

  @override
  List<Object> get props => [];
}

final class CreateReturnInit extends CreateReturnState {
  const CreateReturnInit();
}

final class CreateReturnLoading extends CreateReturnState {
  const CreateReturnLoading();
}

final class CreateReturnSuccess extends CreateReturnState {
  const CreateReturnSuccess();
}

final class CreateReturnFailure extends CreateReturnState {
  final ApiFailure failure;
  const CreateReturnFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
