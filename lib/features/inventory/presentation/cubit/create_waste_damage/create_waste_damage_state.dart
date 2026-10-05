import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateWasteDamageState extends Equatable {
  const CreateWasteDamageState();

  @override
  List<Object> get props => [];
}

final class CreateWasteDamageInit extends CreateWasteDamageState {
  const CreateWasteDamageInit();
}

final class CreateWasteDamageLoading extends CreateWasteDamageState {
  const CreateWasteDamageLoading();
}

final class CreateWasteDamageSuccess extends CreateWasteDamageState {
  const CreateWasteDamageSuccess();
}

final class CreateWasteDamageFailure extends CreateWasteDamageState {
  final ApiFailure failure;

  const CreateWasteDamageFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
