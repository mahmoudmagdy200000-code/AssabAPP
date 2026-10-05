import 'package:equatable/equatable.dart';

import '../../../data/models/verify_otp_request_model.dart';

sealed class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object?> get props => [];
}

final class BranchVerifyOtpStarted extends VerifyOtpEvent {
  final VerifyOtpRequestModel request;

  const BranchVerifyOtpStarted(this.request);

  @override
  List<Object?> get props => [request];
}

final class SupplierVerifyOtpStarted extends VerifyOtpEvent {
  final VerifyOtpRequestModel request;

  const SupplierVerifyOtpStarted(this.request);

  @override
  List<Object?> get props => [request];
}

final class CashierVerifyOtpStarted extends VerifyOtpEvent {
  final VerifyOtpRequestModel request;

  const CashierVerifyOtpStarted(this.request);

  @override
  List<Object?> get props => [request];
}

final class BrandOwnerVerifyOtpStarted extends VerifyOtpEvent {
  final VerifyOtpRequestModel request;

  const BrandOwnerVerifyOtpStarted(this.request);

  @override
  List<Object?> get props => [request];
}

final class VerifyOtpTicked extends VerifyOtpEvent {}

final class VerifyOtpResend extends VerifyOtpEvent {}
