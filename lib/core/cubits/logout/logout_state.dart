import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

final class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

final class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

final class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

final class LogoutFailure extends LogoutState {
  final ApiFailure failure;

  const LogoutFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
