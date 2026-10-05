import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

abstract class StartReceiveOrderState extends Equatable {
  const StartReceiveOrderState();

  @override
  List<Object> get props => [];
}

class StartReceiveOrderInitial extends StartReceiveOrderState {
  const StartReceiveOrderInitial();
}

class StartReceiveOrderLoading extends StartReceiveOrderState {
  const StartReceiveOrderLoading();
}

class StartReceiveOrderSuccess extends StartReceiveOrderState {
  const StartReceiveOrderSuccess();
}

class StartReceiveOrderFailure extends StartReceiveOrderState {
  final ApiFailure failure;

  const StartReceiveOrderFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
