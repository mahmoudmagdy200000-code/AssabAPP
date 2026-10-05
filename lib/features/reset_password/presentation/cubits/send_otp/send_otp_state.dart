import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class SendOtpState extends Equatable {
  const SendOtpState();

  @override
  List<Object> get props => [];
}

final class SendOtpInit extends SendOtpState {
  const SendOtpInit();
}

final class SendOtpLoading extends SendOtpState {
  const SendOtpLoading();
}

final class SendOtpSuccess extends SendOtpState {
  const SendOtpSuccess();
}

final class SendOtpFailure extends SendOtpState {
  final ApiFailure failure;

  const SendOtpFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
