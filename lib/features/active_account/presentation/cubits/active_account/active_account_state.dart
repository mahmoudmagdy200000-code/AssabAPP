import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/api_failure.dart';
import '../../../../../shared/models/login_model/login_response_model.dart';

sealed class ActiveAccountState extends Equatable {
  const ActiveAccountState();

  @override
  List<Object> get props => [];
}

final class ActiveAccountInit extends ActiveAccountState {
  const ActiveAccountInit();
}

final class ActiveAccountLoading extends ActiveAccountState {
  const ActiveAccountLoading();
}

final class ActiveAccountSuccess extends ActiveAccountState {
  final LoginResponseModel firstLoginResponseModel;

  const ActiveAccountSuccess(this.firstLoginResponseModel);

  @override
  List<Object> get props => [firstLoginResponseModel];
}

final class ResetPasswordActiveAccountSuccess extends ActiveAccountState {
  const ResetPasswordActiveAccountSuccess();
}

final class ActiveAccountFailure extends ActiveAccountState {
  final ApiFailure failure;

  const ActiveAccountFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
