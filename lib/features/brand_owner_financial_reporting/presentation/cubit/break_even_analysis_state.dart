import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_break_even_analysis_entity.dart';

sealed class BreakEvenAnalysisState extends Equatable {
  const BreakEvenAnalysisState();

  @override
  List<Object> get props => [];
}

final class BreakEvenAnalysisInitial extends BreakEvenAnalysisState {
  const BreakEvenAnalysisInitial();
}

final class BreakEvenAnalysisLoading extends BreakEvenAnalysisState {
  const BreakEvenAnalysisLoading();
}

final class BreakEvenAnalysisSuccess extends BreakEvenAnalysisState {
  final BreakEvenAnalysisEntity data;

  const BreakEvenAnalysisSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class BreakEvenAnalysisFailure extends BreakEvenAnalysisState {
  final ApiFailure failure;

  const BreakEvenAnalysisFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
