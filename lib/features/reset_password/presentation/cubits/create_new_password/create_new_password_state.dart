import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateNewPasswordState extends Equatable {
  const CreateNewPasswordState();

  @override
  List<Object> get props => [];
}

final class CreateNewPasswordInit extends CreateNewPasswordState {
  const CreateNewPasswordInit();
}

final class CreateNewPasswordLoading extends CreateNewPasswordState {
  const CreateNewPasswordLoading();
}

final class CreateNewPasswordSuccess extends CreateNewPasswordState {
  const CreateNewPasswordSuccess();
}

final class CreateNewPasswordFailure extends CreateNewPasswordState {
  final ApiFailure failure;

  const CreateNewPasswordFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
