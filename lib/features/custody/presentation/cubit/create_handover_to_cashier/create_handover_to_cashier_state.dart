import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateHandoverToCashierState extends Equatable {
  const CreateHandoverToCashierState();

  @override
  List<Object> get props => [];
}

final class CreateHandoverToCashierInit extends CreateHandoverToCashierState {
  const CreateHandoverToCashierInit();
}

final class CreateHandoverToCashierLoading
    extends CreateHandoverToCashierState {
  const CreateHandoverToCashierLoading();
}

final class CreateHandoverToCashierSuccess
    extends CreateHandoverToCashierState {
  const CreateHandoverToCashierSuccess();
}

final class CreateHandoverToCashierFailure
    extends CreateHandoverToCashierState {
  final ApiFailure failure;

  const CreateHandoverToCashierFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
