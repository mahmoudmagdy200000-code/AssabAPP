import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/smart_comparison_entity.dart';

sealed class SmartComparisonState extends Equatable {
  const SmartComparisonState();

  @override
  List<Object> get props => [];
}

final class SmartComparisonInitial extends SmartComparisonState {
  const SmartComparisonInitial();
}

final class SmartComparisonLoading extends SmartComparisonState {
  const SmartComparisonLoading();
}

final class SmartComparisonSuccess extends SmartComparisonState {
  final SmartComparisonEntity data;

  const SmartComparisonSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class SmartComparisonFailure extends SmartComparisonState {
  final ApiFailure failure;

  const SmartComparisonFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
