import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class BrandOwnerPaymentState extends Equatable {
  const BrandOwnerPaymentState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerPaymentInitial extends BrandOwnerPaymentState {}

final class BrandOwnerPaymentLoading extends BrandOwnerPaymentState {}

final class BrandOwnerPaymentSuccess extends BrandOwnerPaymentState {}

final class BrandOwnerPaymentFailure extends BrandOwnerPaymentState {
  final ApiFailure failure;

  const BrandOwnerPaymentFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
