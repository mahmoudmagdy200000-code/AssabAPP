import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

final class VerifyOtpInit extends VerifyOtpState {
  const VerifyOtpInit();
}

final class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

final class VerifyOtpRunning extends VerifyOtpState {
  final int secondsLeft;
  const VerifyOtpRunning(this.secondsLeft);

  @override
  List<Object> get props => [secondsLeft];
}

final class VerifyOtpCanResend extends VerifyOtpState {
  const VerifyOtpCanResend();
}

final class VerifyOtpSuccess extends VerifyOtpState {
  const VerifyOtpSuccess();
}

final class VerifyOtpFailure extends VerifyOtpState {
  final ApiFailure failure;
  const VerifyOtpFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
