part of 'aggregator_cubit.dart';

@immutable
sealed class AggregatorState {}

final class AggregatorInitial extends AggregatorState {}

final class AggregatorLoading extends AggregatorState {}

final class AggregatorEmpty extends AggregatorState {}

final class AggregatorFailure extends AggregatorState {
  final ApiFailure failure;
  AggregatorFailure(this.failure);
}

final class AggregatorLoadedSuccess extends AggregatorState {
  final List<AggregatorEntity> aggregators;
  AggregatorLoadedSuccess(this.aggregators);
}

final class AggregatorAddedSuccess extends AggregatorState {
  final List<AggregatorEntity> aggregators;
  AggregatorAddedSuccess(this.aggregators);
}
