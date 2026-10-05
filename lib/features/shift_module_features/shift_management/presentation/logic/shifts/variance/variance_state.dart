part of 'variance_cubit.dart';

@immutable
sealed class VarianceState {}

final class VarianceInitial extends VarianceState {}

final class VarianceLoading extends VarianceState {}

final class VarianceError extends VarianceState {
  final ApiFailure failure;
  VarianceError(this.failure);
}

final class VarianceLoaded extends VarianceState {
  final HandoverVarianceDetailsEntity? data;

  VarianceLoaded(this.data);
}
