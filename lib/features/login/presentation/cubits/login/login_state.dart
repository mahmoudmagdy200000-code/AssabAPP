import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/login/domain/entities/login_entity.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final LoginEntity entity;

  const LoginSuccess(this.entity);
}

final class LoginFailure extends LoginState {
  final ApiFailure failure;

  const LoginFailure(this.failure);
}
